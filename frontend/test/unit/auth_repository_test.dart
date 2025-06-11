import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:greenleaf_app/infrastructure/auth_repository.dart';
import 'package:greenleaf_app/domain/user.dart';
import 'package:greenleaf_app/domain/auth_failure.dart';
import 'package:greenleaf_app/infrastructure/token_storage.dart';

@GenerateMocks([Dio, TokenStorage])
import 'auth_repository_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late RemoteAuthRepository authRepository;
  const baseUrl = 'http://10.0.2.2:8000';
  late Box tokensBox;

  final testUser = User(
    email: 'test@example.com',
    firstName: 'Test',
    lastName: 'User',
    isActive: true,
  );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    tokensBox = await Hive.openBox('tokens');
  });

  setUp(() {
    mockDio = MockDio();
    authRepository = RemoteAuthRepository(mockDio, baseUrl: baseUrl);
    // Clear tokens before each test
    tokensBox.clear();
    // Set up default tokens for tests that need them
    tokensBox.put('access_token', 'test_access_token');
    tokensBox.put('refresh_token', 'test_refresh_token');
  });

  tearDown(() {
    tokensBox.clear();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('RemoteAuthRepository Tests', () {
    group('login', () {
      test('should return user on successful login', () async {
        when(mockDio.post(
          '$baseUrl/account/api/token/',
          data: {'email': 'test@example.com', 'password': 'password'},
        )).thenAnswer((_) async => Response(
          data: {'access': 'access_token', 'refresh': 'refresh_token'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/account/api/token/'),
        ));

        when(mockDio.get(
          '$baseUrl/account/api/profile/',
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          data: {
            'email': 'test@example.com',
            'first_name': 'Test',
            'last_name': 'User',
            'is_active': true,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/account/api/profile/'),
        ));

        final user = await authRepository.login('test@example.com', 'password');
        expect(user.email, 'test@example.com');
        expect(user.firstName, 'Test');
        expect(user.lastName, 'User');
        expect(user.isActive, true);
      });

      test('should throw AuthFailure on login error', () async {
        when(mockDio.post(
          '$baseUrl/account/api/token/',
          data: {'email': 'test@example.com', 'password': 'wrong_password'},
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/account/api/token/'),
          response: Response(
            data: {'detail': 'Invalid credentials'},
            statusCode: 401,
            requestOptions: RequestOptions(path: '/account/api/token/'),
          ),
        ));

        expect(
          () => authRepository.login('test@example.com', 'wrong_password'),
          throwsA(isA<AuthFailure>().having((e) => e.message, 'message', 'Invalid credentials')),
        );
      });
    });

    group('signup', () {
      test('should return user on successful signup', () async {
        when(mockDio.post(
          '$baseUrl/account/api/register/',
          data: {
            'email': 'new@example.com',
            'password': 'password',
            'confirm_password': 'password',
          },
        )).thenAnswer((_) async => Response(
          data: {'access': 'access_token', 'refresh': 'refresh_token'},
          statusCode: 201,
          requestOptions: RequestOptions(path: '/account/api/register/'),
        ));

        when(mockDio.get(
          '$baseUrl/account/api/profile/',
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          data: {
            'email': 'new@example.com',
            'first_name': 'New',
            'last_name': 'User',
            'is_active': true,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/account/api/profile/'),
        ));

        final user = await authRepository.signup('new@example.com', 'password', 'password');
        expect(user.email, 'new@example.com');
        expect(user.firstName, 'New');
        expect(user.lastName, 'User');
        expect(user.isActive, true);
      });

      test('should throw AuthFailure on signup error', () async {
        when(mockDio.post(
          '$baseUrl/account/api/register/',
          data: {
            'email': 'existing@example.com',
            'password': 'password',
            'confirm_password': 'password',
          },
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/account/api/register/'),
          response: Response(
            data: {'detail': 'Email already exists'},
            statusCode: 400,
            requestOptions: RequestOptions(path: '/account/api/register/'),
          ),
        ));

        expect(
          () => authRepository.signup('existing@example.com', 'password', 'password'),
          throwsA(isA<AuthFailure>().having((e) => e.message, 'message', 'Email already exists')),
        );
      });
    });

    group('fetchProfile', () {
      test('should return user profile on successful fetch', () async {
        // Set up access token
        await tokensBox.put('access_token', 'test_access_token');

        when(mockDio.get(
          '$baseUrl/account/api/profile/',
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          data: {
            'email': 'test@example.com',
            'first_name': 'Test',
            'last_name': 'User',
            'is_active': true,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/account/api/profile/'),
        ));

        final user = await authRepository.fetchProfile('test_access_token');
        expect(user.email, 'test@example.com');
        expect(user.firstName, 'Test');
        expect(user.lastName, 'User');
        expect(user.isActive, true);
      });

      test('should throw AuthFailure on fetch profile error', () async {
        // Set up access token
        await tokensBox.put('access_token', 'test_access_token');

        when(mockDio.get(
          '$baseUrl/account/api/profile/',
          options: anyNamed('options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/account/api/profile/'),
          response: Response(
            data: {'detail': 'Invalid token'},
            statusCode: 401,
            requestOptions: RequestOptions(path: '/account/api/profile/'),
          ),
        ));

        expect(
          () => authRepository.fetchProfile('test_access_token'),
          throwsA(isA<AuthFailure>().having((e) => e.message, 'message', 'Invalid token')),
        );
      });
    });

    group('logout', () {
      test('should clear tokens on logout', () async {
        // Set up tokens
        await tokensBox.put('access_token', 'test_access_token');
        await tokensBox.put('refresh_token', 'test_refresh_token');

        await authRepository.logout();
        expect(tokensBox.get('access_token'), null);
        expect(tokensBox.get('refresh_token'), null);
      });
    });

    group('updateProfile', () {
      test('should return updated user on successful update', () async {
        when(mockDio.patch(
          '$baseUrl/account/api/profile/',
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          data: {
            'email': 'test@example.com',
            'first_name': 'Updated',
            'last_name': 'Name',
            'is_active': true,
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/account/api/profile/'),
        ));

        final user = await authRepository.updateProfile({
          'first_name': 'Updated',
          'last_name': 'Name',
        });

        expect(user.email, 'test@example.com');
        expect(user.firstName, 'Updated');
        expect(user.lastName, 'Name');
        expect(user.isActive, true);
      });

      test('should throw AuthFailure on update profile error', () async {
        // Set up access token
        await tokensBox.put('access_token', 'test_access_token');

        when(mockDio.patch(
          '$baseUrl/account/api/profile/',
          data: anyNamed('data'),
          options: anyNamed('options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/account/api/profile/'),
          response: Response(
            data: {'detail': 'Update failed'},
            statusCode: 400,
            requestOptions: RequestOptions(path: '/account/api/profile/'),
          ),
        ));

        // Remove access token to simulate missing token
        await tokensBox.delete('access_token');

        expect(
          () => authRepository.updateProfile({'first_name': 'Updated'}),
          throwsA(isA<AuthFailure>().having((e) => e.message, 'message', 'No access token')),
        );
      });
    });

    group('deleteAccount', () {
      test('should delete account successfully', () async {
        when(mockDio.delete(
          '$baseUrl/account/api/profile/',
          options: anyNamed('options'),
        )).thenAnswer((_) async => Response(
          statusCode: 204,
          requestOptions: RequestOptions(path: '/account/api/profile/'),
        ));

        await authRepository.deleteAccount();
        expect(tokensBox.get('access_token'), null);
        expect(tokensBox.get('refresh_token'), null);
      });

      test('should throw AuthFailure on delete account error', () async {
        // Set up access token
        await tokensBox.put('access_token', 'test_access_token');

        when(mockDio.delete(
          '$baseUrl/account/api/profile/',
          options: anyNamed('options'),
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/account/api/profile/'),
          response: Response(
            data: {'detail': 'Delete failed'},
            statusCode: 400,
            requestOptions: RequestOptions(path: '/account/api/profile/'),
          ),
        ));

        // Remove access token to simulate missing token
        await tokensBox.delete('access_token');

        expect(
          () => authRepository.deleteAccount(),
          throwsA(isA<AuthFailure>().having((e) => e.message, 'message', 'No access token')),
        );
      });
    });

    group('refreshToken', () {
      test('should refresh token successfully', () async {
        when(mockDio.post(
          '$baseUrl/account/api/token/refresh/',
          data: {'refresh': 'test_refresh_token'},
        )).thenAnswer((_) async => Response(
          data: {'access': 'new_access_token'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/account/api/token/refresh/'),
        ));

        await authRepository.refreshToken();
        expect(tokensBox.get('access_token'), 'new_access_token');
      });

      test('should throw AuthFailure on refresh token error', () async {
        // Set up refresh token
        await tokensBox.put('refresh_token', 'test_refresh_token');

        when(mockDio.post(
          '$baseUrl/account/api/token/refresh/',
          data: {'refresh': 'test_refresh_token'},
        )).thenThrow(DioException(
          requestOptions: RequestOptions(path: '/account/api/token/refresh/'),
          response: Response(
            data: {'detail': 'Invalid refresh token'},
            statusCode: 401,
            requestOptions: RequestOptions(path: '/account/api/token/refresh/'),
          ),
        ));

        // Remove refresh token to simulate missing token
        await tokensBox.delete('refresh_token');

        expect(
          () => authRepository.refreshToken(),
          throwsA(isA<AuthFailure>().having((e) => e.message, 'message', 'No refresh token')),
        );
      });
    });
  });
} 
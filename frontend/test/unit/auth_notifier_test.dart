import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:greenleaf_app/application/auth_provider.dart';
import 'package:greenleaf_app/domain/user.dart';
import 'package:greenleaf_app/domain/auth_failure.dart';
import 'package:greenleaf_app/infrastructure/auth_repository.dart';

@GenerateMocks([AuthRepository])
import 'auth_notifier_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;
  late AuthNotifier authNotifier;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
    authNotifier = container.read(authProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier Tests', () {
    final testUser = User(
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      isActive: true,
    );

    test('initial state should be empty', () {
      expect(authNotifier.state.user, null);
      expect(authNotifier.state.isLoading, false);
      expect(authNotifier.state.failure, null);
    });

    group('login', () {
      test('should update state with user on successful login', () async {
        when(mockAuthRepository.login('test@example.com', 'password'))
            .thenAnswer((_) async => testUser);

        await authNotifier.login('test@example.com', 'password');

        expect(authNotifier.state.user, testUser);
        expect(authNotifier.state.isLoading, false);
        expect(authNotifier.state.failure, null);
      });

      test('should update state with failure on login error', () async {
        when(mockAuthRepository.login('test@example.com', 'wrong_password'))
            .thenThrow(AuthFailure('Invalid credentials'));

        await authNotifier.login('test@example.com', 'wrong_password');

        expect(authNotifier.state.user, null);
        expect(authNotifier.state.isLoading, false);
        expect(authNotifier.state.failure?.message, 'Invalid credentials');
      });
    });

    group('signup', () {
      test('should update state with user on successful signup', () async {
        when(mockAuthRepository.signup('new@example.com', 'password', 'password'))
            .thenAnswer((_) async => testUser);

        await authNotifier.signup('new@example.com', 'password', 'password');

        expect(authNotifier.state.user, testUser);
        expect(authNotifier.state.isLoading, false);
        expect(authNotifier.state.failure, null);
      });

      test('should update state with failure on signup error', () async {
        when(mockAuthRepository.signup('existing@example.com', 'password', 'password'))
            .thenThrow(AuthFailure('Email already exists'));

        await authNotifier.signup('existing@example.com', 'password', 'password');

        expect(authNotifier.state.user, null);
        expect(authNotifier.state.isLoading, false);
        expect(authNotifier.state.failure?.message, 'Email already exists');
      });
    });

    group('logout', () {
      test('should clear user state on logout', () async {
        // First login to set a user
        when(mockAuthRepository.login('test@example.com', 'password'))
            .thenAnswer((_) async => testUser);
        await authNotifier.login('test@example.com', 'password');
        expect(authNotifier.state.user, testUser);

        // Then logout
        await authNotifier.logout();

        expect(authNotifier.state.user, null);
        expect(authNotifier.state.isLoading, false);
        expect(authNotifier.state.failure, null);
      });
    });

    group('updateProfile', () {
      test('should update user profile successfully', () async {
        final updatedUser = User(
          email: 'test@example.com',
          firstName: 'Updated',
          lastName: 'Name',
          isActive: true,
        );

        when(mockAuthRepository.updateProfile(any, any))
            .thenAnswer((_) async => updatedUser);

        await authNotifier.updateProfile({
          'first_name': 'Updated',
          'last_name': 'Name',
        });

        expect(authNotifier.state.user, updatedUser);
        expect(authNotifier.state.isLoading, false);
        expect(authNotifier.state.failure, null);
      });

      test('should handle profile update failure', () async {
        when(mockAuthRepository.updateProfile(any, any))
            .thenThrow(AuthFailure('Update failed'));

        await authNotifier.updateProfile({
          'first_name': 'Updated',
          'last_name': 'Name',
        });

        expect(authNotifier.state.isLoading, false);
        expect(authNotifier.state.failure?.message, 'Update failed');
      });
    });

    group('deleteAccount', () {
      test('should clear state after successful account deletion', () async {
        // First login to set a user
        when(mockAuthRepository.login('test@example.com', 'password'))
            .thenAnswer((_) async => testUser);
        await authNotifier.login('test@example.com', 'password');
        expect(authNotifier.state.user, testUser);

        // Then delete account
        await authNotifier.deleteAccount();

        expect(authNotifier.state.user, null);
        expect(authNotifier.state.isLoading, false);
        expect(authNotifier.state.failure, null);
      });

      test('should handle account deletion failure', () async {
        when(mockAuthRepository.deleteAccount())
            .thenThrow(AuthFailure('Deletion failed'));

        await authNotifier.deleteAccount();

        expect(authNotifier.state.isLoading, false);
        expect(authNotifier.state.failure?.message, 'Deletion failed');
      });
    });
  });
} 

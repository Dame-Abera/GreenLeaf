import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:greenleaf_app/application/user_provider.dart';
import 'package:greenleaf_app/domain/user.dart';
import 'package:greenleaf_app/infrastructure/user_repository.dart';

@GenerateMocks([UserRepository])
import 'user_notifier_test.mocks.dart';

void main() {
  late MockUserRepository mockUserRepository;
  late ProviderContainer container;
  late UserNotifier userNotifier;

  final testUser = User(
    email: 'user1@example.com',
    firstName: 'User',
    lastName: 'One',
    isActive: true,
    isStaff: false,
    isSuperuser: false,
  );

  final testUser2 = User(
    email: 'user2@example.com',
    firstName: 'User',
    lastName: 'Two',
    isActive: true,
    isStaff: true,
    isSuperuser: false,
  );

  setUp(() {
    mockUserRepository = MockUserRepository();
    container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
    );
    userNotifier = container.read(userProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('UserNotifier Tests', () {
    test('initial state should be empty', () {
      expect(userNotifier.state.users, []);
      expect(userNotifier.state.isLoading, false);
      expect(userNotifier.state.error, null);
    });

    group('fetchUsers', () {
      test('should update state with users on successful fetch', () async {
        when(mockUserRepository.getUsers())
            .thenAnswer((_) async => [testUser, testUser2]);

        await userNotifier.fetchUsers();

        expect(userNotifier.state.users, [testUser, testUser2]);
        expect(userNotifier.state.isLoading, false);
        expect(userNotifier.state.error, null);
      });

      test('should handle fetch error and return empty list', () async {
        when(mockUserRepository.getUsers())
            .thenThrow(Exception('Failed to fetch users'));

        await userNotifier.fetchUsers();

        expect(userNotifier.state.users, []);
        expect(userNotifier.state.isLoading, false);
        expect(userNotifier.state.error, 'Exception: Failed to fetch users');
      });
    });
  });
} 

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:greenleaf_app/domain/plant.dart';
import 'package:greenleaf_app/domain/observation.dart';
import 'package:greenleaf_app/domain/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenleaf_app/presentation/app.dart';
import 'package:greenleaf_app/application/auth_provider.dart';
import 'package:greenleaf_app/infrastructure/auth_repository.dart';
import 'test_helpers.dart';

class MockTokenStorage {
  static Future<void> saveTokens(String access, String refresh) async {
    final box = Hive.box('tokens');
    await box.put('access_token', access);
    await box.put('refresh_token', refresh);
  }

  static Future<void> clearTokens() async {
    final box = Hive.box('tokens');
    await box.clear();
  }

  static String? get accessToken => Hive.box('tokens').get('access_token');
  static String? get refreshToken => Hive.box('tokens').get('refresh_token');
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    await MockTokenStorage.saveTokens('mock_access_token', 'mock_refresh_token');
    return User(
      email: email,
      firstName: 'Test',
      lastName: 'User',
      isActive: true,
      isStaff: false,
      isSuperuser: false,
    );
  }

  @override
  Future<User> signup(String email, String password, String confirmPassword) async {
    throw UnimplementedError();
  }

  @override
  Future<User> fetchProfile(String? token) async {
    if (token == null && MockTokenStorage.accessToken == null) {
      throw Exception('No access token');
    }
    return User(
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      isActive: true,
      isStaff: false,
      isSuperuser: false,
    );
  }

  @override
  Future<void> logout() async {
    await MockTokenStorage.clearTokens();
  }

  @override
  Future<User> updateProfile(Map<String, dynamic> data, [String? imagePath]) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount() async {
    throw UnimplementedError();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    try {
      // Initialize Hive only once
      final appDir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDir.path);
      
      // Register adapters
      Hive.registerAdapter(PlantAdapter());
      Hive.registerAdapter(ObservationAdapter());
      Hive.registerAdapter(TimeOfDayAdapter());
      Hive.registerAdapter(SyncStatusAdapter());
      
      // Open boxes
      await Hive.openBox('tokens');
      await Hive.openBox<Plant>('plants');
      await Hive.openBox<Observation>('observations');
    } catch (e) {
      print('Error in setUpAll: $e');
      rethrow;
    }
  });

  setUp(() async {
    try {
      // Clear boxes before each test
      await Hive.box('tokens').clear();
      await Hive.box<Plant>('plants').clear();
      await Hive.box<Observation>('observations').clear();
      await MockTokenStorage.clearTokens();
    } catch (e) {
      print('Error in setUp: $e');
      rethrow;
    }
  });

  tearDownAll(() async {
    try {
      await Hive.close();
    } catch (e) {
      print('Error in tearDownAll: $e');
      rethrow;
    }
  });

  group('End-to-end test', () {
    testWidgets('App launch and navigation test', (WidgetTester tester) async {
      try {
        // Override the auth repository provider
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(MockAuthRepository()),
          ],
        );

        // Initialize app with the container
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const GreenLeafApp(),
          ),
        );
        await tester.pumpAndSettle();

        // Initialize auth state
        await container.read(authProvider.notifier).init();
        await tester.pumpAndSettle();

        // Login first
        await TestHelpers.login(tester);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify bottom navigation bar is visible
        expect(find.byType(BottomNavigationBar), findsOneWidget);
        await tester.pumpAndSettle();

        // Navigate to different tabs
        await TestHelpers.navigateToTab(tester, 1); // Profile tab
        await tester.pumpAndSettle(const Duration(seconds: 2));
        expect(find.byType(BottomNavigationBar), findsOneWidget);

        await TestHelpers.navigateToTab(tester, 0); // Home tab
        await tester.pumpAndSettle(const Duration(seconds: 2));
        expect(find.byType(BottomNavigationBar), findsOneWidget);
      } catch (e) {
        print('Error in app launch test: $e');
        rethrow;
      }
    });

    testWidgets('Plant observation flow test', (WidgetTester tester) async {
      try {
        // Override the auth repository provider
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(MockAuthRepository()),
          ],
        );

        // Initialize app with the container
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const GreenLeafApp(),
          ),
        );
        await tester.pumpAndSettle();

        // Initialize auth state
        await container.read(authProvider.notifier).init();
        await tester.pumpAndSettle();

        // Login first
        await TestHelpers.login(tester);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Add a plant observation
        await TestHelpers.addPlantObservation(tester);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify the observation was added
        expect(find.text('Test Plant'), findsOneWidget);
        expect(find.text('Test Observation'), findsOneWidget);
      } catch (e) {
        print('Error in plant observation test: $e');
        rethrow;
      }
    });

    testWidgets('Logout flow test', (WidgetTester tester) async {
      try {
        // Override the auth repository provider
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(MockAuthRepository()),
          ],
        );

        // Initialize app with the container
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const GreenLeafApp(),
          ),
        );
        await tester.pumpAndSettle();

        // Initialize auth state
        await container.read(authProvider.notifier).init();
        await tester.pumpAndSettle();

        // Login first
        await TestHelpers.login(tester);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to profile tab
        await TestHelpers.navigateToTab(tester, 1);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Find and tap logout button
        final logoutButton = find.widgetWithText(ElevatedButton, 'Log Out');
        expect(logoutButton, findsOneWidget);
        await tester.tap(logoutButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify we're back at login screen
        expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
        expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
      } catch (e) {
        print('Error in logout test: $e');
        rethrow;
      }
    });
  });
}

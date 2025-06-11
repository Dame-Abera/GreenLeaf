import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenleaf_app/presentation/admin_dashboard_page.dart';
import 'package:greenleaf_app/application/user_provider.dart';
import 'package:greenleaf_app/domain/user.dart';
import 'package:greenleaf_app/infrastructure/user_repository.dart';

void main() {
  Widget createWidgetUnderTest({UserState? userState, UserNotifier? userNotifier}) {
    return ProviderScope(
      overrides: [
        userProvider.overrideWith((ref) => userNotifier ?? FakeUserNotifier(_FakeUserRepository(), userState)),
      ],
      child: MaterialApp(home: const AdminDashboardPage()),
    );
  }

  testWidgets('renders all main UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    
    // Test AppBar
    expect(find.text('Registered Users'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    
    // Test Search Field
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('Search users...'), findsOneWidget);
    
    // Test Bottom Navigation
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });

  testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
    final loadingState = UserState(isLoading: true);
    await tester.pumpWidget(createWidgetUnderTest(userState: loadingState));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when error is present', (WidgetTester tester) async {
    final errorState = UserState(error: 'Failed to fetch users');
    await tester.pumpWidget(createWidgetUnderTest(userState: errorState));
    await tester.pump();
    expect(find.text('Error: Failed to fetch users'), findsOneWidget);
  });

  testWidgets('shows no users message when users list is empty', (WidgetTester tester) async {
    final emptyState = UserState(users: []);
    await tester.pumpWidget(createWidgetUnderTest(userState: emptyState));
    await tester.pump();
    expect(find.text('No users found.'), findsOneWidget);
  });

  testWidgets('displays user cards correctly', (WidgetTester tester) async {
    final users = [
      User(
        email: 'admin@example.com',
        firstName: 'Admin',
        lastName: 'User',
        isSuperuser: true,
        isStaff: true,
      ),
      User(
        email: 'staff@example.com',
        firstName: 'Staff',
        lastName: 'User',
        isSuperuser: false,
        isStaff: true,
      ),
      User(
        email: 'user@example.com',
        firstName: 'Regular',
        lastName: 'User',
        isSuperuser: false,
        isStaff: false,
      ),
      User(
        email: 'no.name@example.com',
        firstName: null,
        lastName: null,
        isSuperuser: false,
        isStaff: false,
      ),
    ];

    final userState = UserState(users: users);
    await tester.pumpWidget(createWidgetUnderTest(userState: userState));
    await tester.pump();

    // Verify user cards are displayed
    expect(find.text('Admin User'), findsOneWidget);
    expect(find.text('Staff User'), findsOneWidget);
    expect(find.text('Regular User'), findsOneWidget);
    expect(find.text('no.name@example.com'), findsNWidgets(2)); // appears as both title and subtitle

    // Verify role chips
    expect(find.text('ADMIN'), findsOneWidget);
    expect(find.text('STAFF'), findsOneWidget);
    expect(find.text('USER'), findsNWidgets(2)); // two users with USER role
  });

  testWidgets('search functionality filters users', (WidgetTester tester) async {
    final users = [
      User(
        email: 'john@example.com',
        firstName: 'John',
        lastName: 'Doe',
      ),
      User(
        email: 'jane@example.com',
        firstName: 'Jane',
        lastName: 'Smith',
      ),
    ];

    final userState = UserState(users: users);
    await tester.pumpWidget(createWidgetUnderTest(userState: userState));
    await tester.pump();

    // Enter search query
    await tester.enterText(find.byType(TextField), 'john');
    await tester.pump();

    // Verify filtered results
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Jane Smith'), findsNothing);
  });
}

// A fake UserNotifier for testing
class FakeUserNotifier extends UserNotifier {
  FakeUserNotifier(UserRepository repository, [UserState? initialState]) : super(repository) {
    if (initialState != null) {
      state = initialState;
    }
  }
  @override
  Future<void> fetchUsers() async {}
}

class _FakeUserRepository implements UserRepository {
  @override
  Future<List<User>> getUsers() async => throw UnimplementedError();
} 

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenleaf_app/presentation/pages/profile_page.dart';
import 'package:greenleaf_app/domain/user.dart';
import 'package:greenleaf_app/application/auth_provider.dart';
import 'package:greenleaf_app/domain/auth_failure.dart';
import 'package:greenleaf_app/infrastructure/auth_repository.dart';

class TestAuthState extends AuthState {
  TestAuthState({super.user, super.isLoading = false, super.failure});

  TestAuthState copyWith({User? user, bool? isLoading, AuthFailure? failure}) {
    return TestAuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
    );
  }
}

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(Ref ref, [AuthState? initialState]) : super(_FakeAuthRepository(), ref) {
    if (initialState != null) {
      state = initialState;
    }
  }

  void setUser(User user) {
    print('DEBUG: Setting user in FakeAuthNotifier: ${user.email}');
    state = TestAuthState(user: user);
  }

  void setError(String message) {
    print('DEBUG: Setting error in FakeAuthNotifier: $message');
    state = TestAuthState(failure: AuthFailure(message));
  }

  @override
  Future<void> logout() async {
    print('DEBUG: Logging out in FakeAuthNotifier');
    state = TestAuthState();
  }
}

class _FakeAuthRepository implements AuthRepository {
  User? _user;
  
  @override
  Future<void> deleteAccount() async {}
  
  @override
  Future<User> fetchProfile(String? token) async {
    if (_user == null) {
      throw AuthFailure('No user set');
    }
    return _user!;
  }
  
  @override
  Future<User> login(String email, String password) async {
    if (_user == null) {
      throw AuthFailure('No user set');
    }
    return _user!;
  }
  
  @override
  Future<void> logout() async {
    _user = null;
  }
  
  @override
  Future<User> signup(String email, String password, String confirmPassword) async {
    if (_user == null) {
      throw AuthFailure('No user set');
    }
    return _user!;
  }
  
  @override
  Future<User> updateProfile(Map<String, dynamic> data, [String? imagePath]) async {
    if (_user == null) {
      throw AuthFailure('No user set');
    }
    return _user!;
  }
  
  void setUser(User user) {
    _user = user;
  }
}

void main() {
  Widget createWidgetUnderTest({AuthState? authState, AuthNotifier? authNotifier}) {
    print('DEBUG: Creating widget under test with auth state: ${authState?.user?.email ?? 'null'}');
    return MaterialApp(
      home: ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => authNotifier ?? FakeAuthNotifier(ref, authState)),
        ],
        child: const ProfilePage(),
      ),
    );
  }

  testWidgets('displays user information correctly', (WidgetTester tester) async {
    print('DEBUG: Starting user information test...');
    final testUser = User(
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      isActive: true,
    );
    final authState = TestAuthState(user: testUser);

    await tester.pumpWidget(createWidgetUnderTest(authState: authState));
    await tester.pumpAndSettle();
    print('DEBUG: Widget tree built and settled');

    // Debug: Print all widgets in the tree
    print('DEBUG: Current widget tree:');
    for (var w in tester.allWidgets) {
      print('  ${w.toStringShort()}');
    }

    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    print('DEBUG: User information displayed correctly');
  });

  testWidgets('shows loading indicator when auth state is loading', (WidgetTester tester) async {
    print('DEBUG: Starting loading indicator test...');
    final authState = TestAuthState(isLoading: true);

    await tester.pumpWidget(createWidgetUnderTest(authState: authState));
    await tester.pumpAndSettle();
    print('DEBUG: Widget tree built and settled');

    // Debug: Print all widgets in the tree
    print('DEBUG: Current widget tree:');
    for (var w in tester.allWidgets) {
      print('  ${w.toStringShort()}');
    }

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    print('DEBUG: Loading indicator displayed correctly');
  });

  testWidgets('enables editing mode when edit button is pressed', (WidgetTester tester) async {
    print('DEBUG: Starting edit mode test...');
    final testUser = User(
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      isActive: true,
    );
    final authState = TestAuthState(user: testUser);

    await tester.pumpWidget(createWidgetUnderTest(authState: authState));
    await tester.pumpAndSettle();
    print('DEBUG: Widget tree built and settled');

    // Debug: Print all widgets in the tree
    print('DEBUG: Current widget tree:');
    for (var w in tester.allWidgets) {
      print('  ${w.toStringShort()}');
    }

    final editButton = find.byType(ElevatedButton).first;
    print('DEBUG: Looking for edit button: ${editButton.evaluate().length} found');
    expect(editButton, findsOneWidget);
    
    await tester.tap(editButton);
    await tester.pumpAndSettle();
    print('DEBUG: Edit button tapped');

    final textFields = find.byType(TextFormField);
    print('DEBUG: Found ${textFields.evaluate().length} text fields');
    for (final field in textFields.evaluate()) {
      final widget = field.widget as TextFormField;
      print('DEBUG: Text field enabled: ${widget.enabled}');
      expect(widget.enabled, isTrue);
    }
  });

  testWidgets('shows delete account confirmation dialog', (WidgetTester tester) async {
    print('DEBUG: Starting delete account dialog test...');
    final testUser = User(
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      isActive: true,
    );
    final authState = TestAuthState(user: testUser);

    await tester.pumpWidget(createWidgetUnderTest(authState: authState));
    await tester.pumpAndSettle();
    print('DEBUG: Widget tree built and settled');

    // Debug: Print all widgets in the tree
    print('DEBUG: Current widget tree:');
    for (var w in tester.allWidgets) {
      print('  ${w.toStringShort()}');
    }

    final deleteButton = find.byType(ElevatedButton).last;
    print('DEBUG: Looking for delete button: ${deleteButton.evaluate().length} found');
    expect(deleteButton, findsOneWidget);
    
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    print('DEBUG: Delete button tapped');

    expect(find.text('Are you sure you want to delete your account?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    print('DEBUG: Delete confirmation dialog displayed correctly');
  });

  testWidgets('calls logout when logout button is pressed', (WidgetTester tester) async {
    print('DEBUG: Starting logout test...');
    final testUser = User(
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      isActive: true,
    );
    final authState = TestAuthState(user: testUser);

    await tester.pumpWidget(createWidgetUnderTest(authState: authState));
    await tester.pumpAndSettle();
    print('DEBUG: Widget tree built and settled');

    // Debug: Print all widgets in the tree
    print('DEBUG: Current widget tree:');
    for (var w in tester.allWidgets) {
      print('  ${w.toStringShort()}');
    }

    final logoutButton = find.byType(ElevatedButton).at(1);
    print('DEBUG: Looking for logout button: ${logoutButton.evaluate().length} found');
    expect(logoutButton, findsOneWidget);
    
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();
    print('DEBUG: Logout button tapped');

    // Verify that the user is no longer displayed
    expect(find.text('Test User'), findsNothing);
    expect(find.text('test@example.com'), findsNothing);
    print('DEBUG: Logout successful');
  });

  testWidgets('displays error message when auth state has failure', (WidgetTester tester) async {
    print('DEBUG: Starting error message test...');
    final authState = TestAuthState(failure: AuthFailure('Test error message'));

    await tester.pumpWidget(createWidgetUnderTest(authState: authState));
    await tester.pumpAndSettle();
    print('DEBUG: Widget tree built and settled');

    // Debug: Print all widgets in the tree
    print('DEBUG: Current widget tree:');
    for (var w in tester.allWidgets) {
      print('  ${w.toStringShort()}');
    }

    expect(find.text('Test error message'), findsOneWidget);
    print('DEBUG: Error message displayed correctly');
  });
} 

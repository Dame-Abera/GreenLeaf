import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenleaf_app/presentation/signup_page.dart';
import 'package:greenleaf_app/application/auth_provider.dart';
import 'package:greenleaf_app/domain/auth_failure.dart';
import 'package:greenleaf_app/infrastructure/auth_repository.dart';
import 'package:greenleaf_app/domain/user.dart';

void main() {
  Widget createWidgetUnderTest({AuthState? authState, AuthNotifier? authNotifier}) {
    return ProviderScope(
      overrides: [
        authProvider.overrideWith((ref) => authNotifier ?? FakeAuthNotifier(ref, authState ?? AuthState())),
      ],
      child: MaterialApp(home: SignUpPage()),
    );
  }

  testWidgets('renders all main UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Back to login'), findsOneWidget);
    expect(find.text('Sign Up', findRichText: true), findsAtLeastNWidgets(1));
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
  });

  testWidgets('can enter email, password, and confirm password', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final confirmPasswordField = find.byType(TextField).at(2);
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');
    await tester.enterText(confirmPasswordField, 'password123');
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password123'), findsNWidgets(2));
  });

  testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
    final loadingState = AuthState(isLoading: true);
    await tester.pumpWidget(createWidgetUnderTest(authState: loadingState));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when authState.failure is set', (WidgetTester tester) async {
    final errorState = AuthState(failure: AuthFailure('Signup failed'));
    await tester.pumpWidget(createWidgetUnderTest(authState: errorState));
    expect(find.text('Signup failed'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
  });

  testWidgets('shows SnackBar when passwords do not match', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    final confirmPasswordField = find.byType(TextField).at(2);
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');
    await tester.enterText(confirmPasswordField, 'different');
    final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
    await tester.ensureVisible(signUpButton);
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();
    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}

// A fake AuthNotifier for testing
class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(Ref ref, [AuthState? state]) : super(_FakeAuthRepository(), ref) {
    if (state != null) {
      this.state = state;
    }
  }
  @override
  Future<void> signup(String email, String password, String confirmPassword) async {}
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<void> deleteAccount() async => throw UnimplementedError();
  @override
  Future<User> fetchProfile(String? token) async => throw UnimplementedError();
  @override
  Future<User> login(String email, String password) async => throw UnimplementedError();
  @override
  Future<void> logout() async => throw UnimplementedError();
  @override
  Future<User> signup(String email, String password, String confirmPassword) async => throw UnimplementedError();
  @override
  Future<User> updateProfile(Map<String, dynamic> data, [String? imagePath]) async => throw UnimplementedError();
} 

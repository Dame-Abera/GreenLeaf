import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenleaf_app/presentation/login_page.dart';
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
      child: MaterialApp(home: LoginPage()),
    );
  }

  testWidgets('renders all main UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text('Log in'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text("Don't have account? "), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('can enter email and password', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password123');
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.text('password123'), findsOneWidget);
  });

  testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
    final loadingState = AuthState(isLoading: true);
    await tester.pumpWidget(createWidgetUnderTest(authState: loadingState));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Find the only ElevatedButton
    final loginButton = find.byType(ElevatedButton);
    expect(loginButton, findsOneWidget);
    final button = tester.widget<ElevatedButton>(loginButton);
    expect(button.onPressed, isNull);
  });

  testWidgets('shows error message when authState.failure is set', (WidgetTester tester) async {
    final errorState = AuthState(failure: AuthFailure('Invalid credentials'));
    await tester.pumpWidget(createWidgetUnderTest(authState: errorState));
    expect(find.text('Invalid credentials'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
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
  Future<void> login(String email, String password) async {}
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

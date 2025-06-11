import 'package:flutter_test/flutter_test.dart';
import 'package:greenleaf_app/domain/auth_failure.dart';

void main() {
  group('AuthFailure Tests', () {
    test('should create an AuthFailure instance with a message', () {
      const message = 'Authentication failed';
      final failure = AuthFailure(message);

      expect(failure.message, equals(message));
    });

    test('toString should return the message', () {
      const message = 'Invalid credentials';
      final failure = AuthFailure(message);

      expect(failure.toString(), equals(message));
    });

    test('should handle empty message', () {
      const message = '';
      final failure = AuthFailure(message);

      expect(failure.message, isEmpty);
      expect(failure.toString(), isEmpty);
    });

    test('should handle long messages', () {
      const message = 'This is a very long authentication failure message that '
          'describes in detail what went wrong during the authentication process '
          'and provides additional context about the error';
      final failure = AuthFailure(message);

      expect(failure.message, equals(message));
      expect(failure.toString(), equals(message));
    });

    test('should handle special characters in message', () {
      const message = r'Error: Invalid email format! @#$%^&*()';
      final failure = AuthFailure(message);

      expect(failure.message, equals(message));
      expect(failure.toString(), equals(message));
    });

    test('should handle unicode characters in message', () {
      const message = 'Erro: Formato de e-mail inválido!';
      final failure = AuthFailure(message);

      expect(failure.message, equals(message));
      expect(failure.toString(), equals(message));
    });
  });
} 

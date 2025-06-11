import 'package:flutter_test/flutter_test.dart';
import 'package:greenleaf_app/domain/user.dart';

void main() {
  group('User Model Tests', () {
    test('should create a User instance with required and default fields', () {
      final user = User(email: 'user@example.com');
      expect(user.email, 'user@example.com');
      expect(user.firstName, isNull);
      expect(user.lastName, isNull);
      expect(user.profileImage, isNull);
      expect(user.birthdate, isNull);
      expect(user.gender, isNull);
      expect(user.phoneNumber, isNull);
      expect(user.isActive, isTrue);
      expect(user.isStaff, isFalse);
      expect(user.isSuperuser, isFalse);
    });

    test('should create a User instance with all fields', () {
      final birthdate = DateTime(2000, 1, 1);
      final user = User(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        profileImage: 'profile.jpg',
        birthdate: birthdate,
        gender: 'male',
        phoneNumber: '1234567890',
        isActive: false,
        isStaff: true,
        isSuperuser: true,
      );
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.profileImage, 'profile.jpg');
      expect(user.birthdate, birthdate);
      expect(user.gender, 'male');
      expect(user.phoneNumber, '1234567890');
      expect(user.isActive, isFalse);
      expect(user.isStaff, isTrue);
      expect(user.isSuperuser, isTrue);
    });

    test('isAdmin should be true for specific admin email', () {
      final user = User(email: 'dameabera@gmail.com');
      expect(user.isAdmin, isTrue);
    });

    test('isAdmin should be true for @admin.com email', () {
      final user = User(email: 'someone@admin.com');
      expect(user.isAdmin, isTrue);
    });

    test('isAdmin should be true for staff or superuser', () {
      final staffUser = User(email: 'user@example.com', isStaff: true);
      final superUser = User(email: 'user@example.com', isSuperuser: true);
      expect(staffUser.isAdmin, isTrue);
      expect(superUser.isAdmin, isTrue);
    });

    test('isAdmin should be false for regular user', () {
      final user = User(email: 'user@example.com');
      expect(user.isAdmin, isFalse);
    });

    test('should handle null and empty optional fields', () {
      final user = User(email: 'user@example.com');
      expect(user.firstName, isNull);
      expect(user.lastName, isNull);
      expect(user.profileImage, isNull);
      expect(user.birthdate, isNull);
      expect(user.gender, isNull);
      expect(user.phoneNumber, isNull);
    });
  });
} 

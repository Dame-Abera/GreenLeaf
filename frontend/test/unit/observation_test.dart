import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenleaf_app/domain/observation.dart';
import 'package:greenleaf_app/domain/plant.dart';

void main() {
  group('Observation Model Tests', () {
    test('should create an Observation instance with all required fields', () {
      final observation = Observation(
        id: 1,
        time: const TimeOfDay(hour: 14, minute: 30),
        date: DateTime(2024, 3, 15),
        location: 'Test Location',
        note: 'Test Note',
      );

      expect(observation.id, equals(1));
      expect(observation.time, equals(const TimeOfDay(hour: 14, minute: 30)));
      expect(observation.date, equals(DateTime(2024, 3, 15)));
      expect(observation.location, equals('Test Location'));
      expect(observation.note, equals('Test Note'));
      expect(observation.observationImage, isNull);
      expect(observation.relatedPlant, isNull);
      expect(observation.createdBy, isNull);
      expect(observation.syncStatus, equals(SyncStatus.synced));
    });

    test('should create an Observation instance with optional fields', () {
      final observation = Observation(
        id: 1,
        observationImage: 'test_image.jpg',
        relatedPlant: 123,
        time: const TimeOfDay(hour: 14, minute: 30),
        date: DateTime(2024, 3, 15),
        location: 'Test Location',
        note: 'Test Note',
        createdBy: 'test_user',
        syncStatus: SyncStatus.pending_create,
      );

      expect(observation.observationImage, equals('test_image.jpg'));
      expect(observation.relatedPlant, equals(123));
      expect(observation.createdBy, equals('test_user'));
      expect(observation.syncStatus, equals(SyncStatus.pending_create));
    });

    test('copyWith should create a new instance with updated fields', () {
      final originalObservation = Observation(
        id: 1,
        time: const TimeOfDay(hour: 14, minute: 30),
        date: DateTime(2024, 3, 15),
        location: 'Original Location',
        note: 'Original Note',
      );

      final updatedObservation = originalObservation.copyWith(
        location: 'Updated Location',
        note: 'Updated Note',
      );

      expect(updatedObservation.id, equals(originalObservation.id));
      expect(updatedObservation.time, equals(originalObservation.time));
      expect(updatedObservation.date, equals(originalObservation.date));
      expect(updatedObservation.location, equals('Updated Location'));
      expect(updatedObservation.note, equals('Updated Note'));
    });

    test('fromJson should create an Observation instance from JSON', () {
      final json = {
        'id': 1,
        'observation_image': 'test_image.jpg',
        'related_plant': 123,
        'time': '14:30:00',
        'date': '2024-03-15',
        'location': 'Test Location',
        'note': 'Test Note',
        'created_by': 'test_user',
      };

      final observation = Observation.fromJson(json);

      expect(observation.id, equals(1));
      expect(observation.observationImage, equals('test_image.jpg'));
      expect(observation.relatedPlant, equals(123));
      expect(observation.time, equals(const TimeOfDay(hour: 14, minute: 30)));
      expect(observation.date, equals(DateTime(2024, 3, 15)));
      expect(observation.location, equals('Test Location'));
      expect(observation.note, equals('Test Note'));
      expect(observation.createdBy, equals('test_user'));
      expect(observation.syncStatus, equals(SyncStatus.synced));
    });

    test('fromJson should handle null or empty observation_image', () {
      final json = {
        'id': 1,
        'observation_image': null,
        'time': '14:30:00',
        'date': '2024-03-15',
        'location': 'Test Location',
        'note': 'Test Note',
      };

      final observation = Observation.fromJson(json);
      expect(observation.observationImage, isNull);

      final jsonWithEmptyString = {
        ...json,
        'observation_image': '',
      };

      final observationWithEmptyString = Observation.fromJson(jsonWithEmptyString);
      expect(observationWithEmptyString.observationImage, isNull);
    });

    test('fromJson should handle different related_plant types', () {
      final json = {
        'id': 1,
        'time': '14:30:00',
        'date': '2024-03-15',
        'location': 'Test Location',
        'note': 'Test Note',
      };

      // Test with integer
      final jsonWithInt = {
        ...json,
        'related_plant': 123,
      };
      final observationWithInt = Observation.fromJson(jsonWithInt);
      expect(observationWithInt.relatedPlant, equals(123));

      // Test with string
      final jsonWithString = {
        ...json,
        'related_plant': '456',
      };
      final observationWithString = Observation.fromJson(jsonWithString);
      expect(observationWithString.relatedPlant, equals(456));

      // Test with double
      final jsonWithDouble = {
        ...json,
        'related_plant': 789.0,
      };
      final observationWithDouble = Observation.fromJson(jsonWithDouble);
      expect(observationWithDouble.relatedPlant, equals(789));
    });

    test('toJson should convert Observation instance to JSON', () {
      final observation = Observation(
        id: 1,
        observationImage: 'test_image.jpg',
        relatedPlant: 123,
        time: const TimeOfDay(hour: 14, minute: 30),
        date: DateTime(2024, 3, 15),
        location: 'Test Location',
        note: 'Test Note',
        createdBy: 'test_user',
      );

      final json = observation.toJson();

      expect(json['id'], equals(1));
      expect(json['observation_image'], equals('test_image.jpg'));
      expect(json['related_plant'], equals(123));
      expect(json['time'], equals('14:30:00'));
      expect(json['date'], equals('2024-03-15'));
      expect(json['location'], equals('Test Location'));
      expect(json['note'], equals('Test Note'));
      expect(json['created_by'], equals('test_user'));
    });

    test('fromJson should handle invalid date format', () {
      final json = {
        'id': 1,
        'time': '14:30:00',
        'date': 'invalid-date',
        'location': 'Test Location',
        'note': 'Test Note',
      };

      final observation = Observation.fromJson(json);
      // Should default to current date
      expect(observation.date, isA<DateTime>());
    });

    test('fromJson should handle missing optional fields', () {
      final json = {
        'id': 1,
        'time': '14:30:00',
        'date': '2024-03-15',
        'location': 'Test Location',
        'note': 'Test Note',
      };

      final observation = Observation.fromJson(json);

      expect(observation.observationImage, isNull);
      expect(observation.relatedPlant, isNull);
      expect(observation.createdBy, isNull);
    });

    test('fromJson should handle non-string values for string fields', () {
      final json = {
        'id': 1,
        'observation_image': 123,
        'time': '14:30:00',
        'date': '2024-03-15',
        'location': 456,
        'note': 789,
        'created_by': 101,
      };

      final observation = Observation.fromJson(json);

      expect(observation.observationImage, isNull);
      expect(observation.location, isEmpty);
      expect(observation.note, isEmpty);
      expect(observation.createdBy, isNull);
    });
  });
} 

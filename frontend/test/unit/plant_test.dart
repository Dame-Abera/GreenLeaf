import 'package:flutter_test/flutter_test.dart';
import 'package:greenleaf_app/domain/plant.dart';

void main() {
  group('Plant Model Tests', () {
    test('should create a Plant instance with all required fields', () {
      final plant = Plant(
        id: 1,
        commonName: 'Test Plant',
        scientificName: 'Testus Plantus',
        habitat: 'Test Habitat',
        origin: 'Test Origin',
        description: 'Test Description',
      );

      expect(plant.id, equals(1));
      expect(plant.commonName, equals('Test Plant'));
      expect(plant.scientificName, equals('Testus Plantus'));
      expect(plant.habitat, equals('Test Habitat'));
      expect(plant.origin, equals('Test Origin'));
      expect(plant.description, equals('Test Description'));
      expect(plant.plantImage, isNull);
      expect(plant.createdBy, isNull);
      expect(plant.syncStatus, equals(SyncStatus.synced));
    });

    test('should create a Plant instance with optional fields', () {
      final plant = Plant(
        id: 1,
        plantImage: 'test_image.jpg',
        commonName: 'Test Plant',
        scientificName: 'Testus Plantus',
        habitat: 'Test Habitat',
        origin: 'Test Origin',
        description: 'Test Description',
        createdBy: 'test_user',
        syncStatus: SyncStatus.pending_create,
      );

      expect(plant.plantImage, equals('test_image.jpg'));
      expect(plant.createdBy, equals('test_user'));
      expect(plant.syncStatus, equals(SyncStatus.pending_create));
    });

    test('copyWith should create a new instance with updated fields', () {
      final originalPlant = Plant(
        id: 1,
        commonName: 'Original Plant',
        scientificName: 'Original Scientific',
        habitat: 'Original Habitat',
        origin: 'Original Origin',
        description: 'Original Description',
      );

      final updatedPlant = originalPlant.copyWith(
        commonName: 'Updated Plant',
        scientificName: 'Updated Scientific',
      );

      expect(updatedPlant.id, equals(originalPlant.id));
      expect(updatedPlant.commonName, equals('Updated Plant'));
      expect(updatedPlant.scientificName, equals('Updated Scientific'));
      expect(updatedPlant.habitat, equals(originalPlant.habitat));
      expect(updatedPlant.origin, equals(originalPlant.origin));
      expect(updatedPlant.description, equals(originalPlant.description));
    });

    test('fromJson should create a Plant instance from JSON', () {
      final json = {
        'id': 1,
        'plant_image': 'test_image.jpg',
        'common_name': 'Test Plant',
        'scientific_name': 'Testus Plantus',
        'habitat': 'Test Habitat',
        'origin': 'Test Origin',
        'description': 'Test Description',
        'created_by': 'test_user',
      };

      final plant = Plant.fromJson(json);

      expect(plant.id, equals(1));
      expect(plant.plantImage, equals('test_image.jpg'));
      expect(plant.commonName, equals('Test Plant'));
      expect(plant.scientificName, equals('Testus Plantus'));
      expect(plant.habitat, equals('Test Habitat'));
      expect(plant.origin, equals('Test Origin'));
      expect(plant.description, equals('Test Description'));
      expect(plant.createdBy, equals('test_user'));
      expect(plant.syncStatus, equals(SyncStatus.synced));
    });

    test('fromJson should handle null or empty plant_image', () {
      final json = {
        'id': 1,
        'plant_image': null,
        'common_name': 'Test Plant',
        'scientific_name': 'Testus Plantus',
        'habitat': 'Test Habitat',
        'origin': 'Test Origin',
        'description': 'Test Description',
      };

      final plant = Plant.fromJson(json);
      expect(plant.plantImage, isNull);

      final jsonWithEmptyString = {
        ...json,
        'plant_image': '',
      };

      final plantWithEmptyString = Plant.fromJson(jsonWithEmptyString);
      expect(plantWithEmptyString.plantImage, isNull);
    });

    test('toJson should convert Plant instance to JSON', () {
      final plant = Plant(
        id: 1,
        plantImage: 'test_image.jpg',
        commonName: 'Test Plant',
        scientificName: 'Testus Plantus',
        habitat: 'Test Habitat',
        origin: 'Test Origin',
        description: 'Test Description',
        createdBy: 'test_user',
      );

      final json = plant.toJson();

      expect(json['id'], equals(1));
      expect(json['plant_image'], equals('test_image.jpg'));
      expect(json['common_name'], equals('Test Plant'));
      expect(json['scientific_name'], equals('Testus Plantus'));
      expect(json['habitat'], equals('Test Habitat'));
      expect(json['origin'], equals('Test Origin'));
      expect(json['description'], equals('Test Description'));
      expect(json['created_by'], equals('test_user'));
    });

    test('fromJson should handle missing optional fields', () {
      final json = {
        'id': 1,
        'common_name': 'Test Plant',
        'scientific_name': 'Testus Plantus',
        'habitat': 'Test Habitat',
        'origin': 'Test Origin',
        'description': 'Test Description',
      };

      final plant = Plant.fromJson(json);

      expect(plant.plantImage, isNull);
      expect(plant.createdBy, isNull);
    });

    test('fromJson should handle non-string values for string fields', () {
      final json = {
        'id': 1,
        'plant_image': 123,
        'common_name': 456,
        'scientific_name': 'Testus Plantus',
        'habitat': 'Test Habitat',
        'origin': 'Test Origin',
        'description': 'Test Description',
        'created_by': 789,
      };

      final plant = Plant.fromJson(json);

      expect(plant.plantImage, isNull);
      expect(plant.commonName, isEmpty);
      expect(plant.createdBy, isNull);
    });
  });
} 

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:greenleaf_app/application/plant_provider.dart';
import 'package:greenleaf_app/domain/plant.dart';
import 'package:greenleaf_app/infrastructure/plant_repository.dart';
import 'package:greenleaf_app/infrastructure/local_data_source.dart';
import 'package:greenleaf_app/application/providers/local_data_provider.dart';

@GenerateMocks([PlantRepository, LocalDataSource])
import 'plant_notifier_test.mocks.dart';

void main() {
  late MockPlantRepository mockPlantRepository;
  late MockLocalDataSource mockLocalDataSource;
  late ProviderContainer container;
  late PlantNotifier plantNotifier;

  final testPlant = Plant(
    id: 1,
    commonName: 'Test Plant',
    scientificName: 'Testus Plantus',
    habitat: 'Test Habitat',
    origin: 'Test Origin',
    description: 'Test Description',
    plantImage: 'test_image.jpg',
  );

  final testPlant2 = Plant(
    id: 2,
    commonName: 'Test Plant 2',
    scientificName: 'Testus Plantus 2',
    habitat: 'Test Habitat 2',
    origin: 'Test Origin 2',
    description: 'Test Description 2',
    plantImage: 'test_image2.jpg',
  );

  setUp(() {
    mockPlantRepository = MockPlantRepository();
    mockLocalDataSource = MockLocalDataSource();
    container = ProviderContainer(
      overrides: [
        plantRepositoryProvider.overrideWithValue(mockPlantRepository),
        localDataSourceProvider.overrideWithValue(mockLocalDataSource),
      ],
    );
    plantNotifier = container.read(plantProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('PlantNotifier Tests', () {
    test('initial state should be empty', () {
      expect(plantNotifier.state.plants, []);
      expect(plantNotifier.state.selectedPlant, null);
      expect(plantNotifier.state.isLoading, false);
      expect(plantNotifier.state.error, null);
    });

    group('fetchPlants', () {
      test('should update state with plants on successful fetch', () async {
        when(mockPlantRepository.getPlants())
            .thenAnswer((_) async => [testPlant, testPlant2]);

        await plantNotifier.fetchPlants();

        expect(plantNotifier.state.plants, [testPlant, testPlant2]);
        expect(plantNotifier.state.isLoading, false);
        expect(plantNotifier.state.error, null);
      });

      test('should handle fetch error and return empty list', () async {
        when(mockPlantRepository.getPlants())
            .thenThrow(Exception('Failed to fetch plants'));

        await plantNotifier.fetchPlants();

        expect(plantNotifier.state.plants, []);
        expect(plantNotifier.state.isLoading, false);
        expect(plantNotifier.state.error, 'Exception: Failed to fetch plants');
      });
    });

    group('fetchPlant', () {
      test('should update state with selected plant on successful fetch', () async {
        when(mockPlantRepository.getPlant(1))
            .thenAnswer((_) async => testPlant);

        await plantNotifier.fetchPlant(1);

        expect(plantNotifier.state.selectedPlant, testPlant);
        expect(plantNotifier.state.isLoading, false);
        expect(plantNotifier.state.error, null);
      });

      test('should handle fetch error for single plant', () async {
        when(mockPlantRepository.getPlant(1))
            .thenThrow(Exception('Failed to fetch plant'));

        await plantNotifier.fetchPlant(1);

        expect(plantNotifier.state.selectedPlant, null);
        expect(plantNotifier.state.isLoading, false);
        expect(plantNotifier.state.error, 'Exception: Failed to fetch plant');
      });
    });

    group('addPlant', () {
      final plantData = {
        'common_name': 'New Plant',
        'scientific_name': 'Newus Plantus',
        'habitat': 'New Habitat',
        'origin': 'New Origin',
        'description': 'New Description',
      };

      test('should add plant to state on successful creation', () async {
        final newPlant = Plant(
          id: 3,
          commonName: 'New Plant',
          scientificName: 'Newus Plantus',
          habitat: 'New Habitat',
          origin: 'New Origin',
          description: 'New Description',
        );

        when(mockPlantRepository.addPlant(plantData, null))
            .thenAnswer((_) async => newPlant);

        await plantNotifier.addPlant(plantData, null);

        expect(plantNotifier.state.plants, [newPlant]);
        expect(plantNotifier.state.isLoading, false);
        expect(plantNotifier.state.error, null);
      });

      test('should handle add plant error', () async {
        when(mockPlantRepository.addPlant(plantData, null))
            .thenThrow(Exception('Failed to add plant'));

        await plantNotifier.addPlant(plantData, null);

        expect(plantNotifier.state.plants, []);
        expect(plantNotifier.state.isLoading, false);
        expect(plantNotifier.state.error, 'Exception: Failed to add plant');
      });
    });

    group('updatePlant', () {
      final updateData = {
        'common_name': 'Updated Plant',
        'scientific_name': 'Updatedus Plantus',
        'habitat': 'Updated Habitat',
        'origin': 'Updated Origin',
        'description': 'Updated Description',
      };

      test('should update plant in state on successful update', () async {
        // First add a plant to the state
        when(mockPlantRepository.getPlants())
            .thenAnswer((_) async => [testPlant]);
        await plantNotifier.fetchPlants();

        final updatedPlant = testPlant.copyWith(
          commonName: 'Updated Plant',
          scientificName: 'Updatedus Plantus',
          habitat: 'Updated Habitat',
          origin: 'Updated Origin',
          description: 'Updated Description',
        );

        when(mockPlantRepository.updatePlant(1, updateData, null))
            .thenAnswer((_) async => updatedPlant);

        await plantNotifier.updatePlant(1, updateData, null);

        expect(plantNotifier.state.plants, [updatedPlant]);
        expect(plantNotifier.state.isLoading, false);
        expect(plantNotifier.state.error, null);
      });

      test('should handle update plant error', () async {
        when(mockPlantRepository.updatePlant(1, updateData, null))
            .thenThrow(Exception('Failed to update plant'));

        await plantNotifier.updatePlant(1, updateData, null);

        expect(plantNotifier.state.isLoading, false);
        expect(plantNotifier.state.error, 'Exception: Failed to update plant');
      });
    });

    group('deletePlant', () {
      test('should remove plant from state on successful deletion', () async {
        // First add plants to the state
        when(mockPlantRepository.getPlants())
            .thenAnswer((_) async => [testPlant, testPlant2]);
        await plantNotifier.fetchPlants();

        when(mockPlantRepository.deletePlant(1))
            .thenAnswer((_) async => null);

        await plantNotifier.deletePlant(1);

        expect(plantNotifier.state.plants, [testPlant2]);
        expect(plantNotifier.state.isLoading, false);
        expect(plantNotifier.state.error, null);
      });

      test('should handle delete plant error', () async {
        when(mockPlantRepository.deletePlant(1))
            .thenThrow(Exception('Failed to delete plant'));

        await plantNotifier.deletePlant(1);

        expect(plantNotifier.state.isLoading, false);
        expect(plantNotifier.state.error, 'Exception: Failed to delete plant');
      });
    });
  });
} 

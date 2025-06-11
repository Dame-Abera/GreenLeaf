import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:greenleaf_app/application/observation_provider.dart';
import 'package:greenleaf_app/domain/observation.dart';
import 'package:greenleaf_app/infrastructure/observation_repository.dart';
import 'package:greenleaf_app/infrastructure/local_data_source.dart';
import 'package:greenleaf_app/application/providers/local_data_provider.dart';
import 'package:flutter/material.dart';

@GenerateMocks([ObservationRepository, LocalDataSource])
import 'observation_notifier_test.mocks.dart';

void main() {
  late MockObservationRepository mockObservationRepository;
  late MockLocalDataSource mockLocalDataSource;
  late ProviderContainer container;
  late ObservationNotifier observationNotifier;

  final testObservation = Observation(
    id: 1,
    observationImage: 'obs_image.jpg',
    relatedPlant: 1,
    time: const TimeOfDay(hour: 10, minute: 30),
    date: DateTime(2024, 1, 1),
    location: 'Test Location',
    note: 'Test Note',
  );

  final testObservation2 = Observation(
    id: 2,
    observationImage: 'obs_image2.jpg',
    relatedPlant: 2,
    time: const TimeOfDay(hour: 12, minute: 0),
    date: DateTime(2024, 2, 2),
    location: 'Test Location 2',
    note: 'Test Note 2',
  );

  setUp(() {
    mockObservationRepository = MockObservationRepository();
    mockLocalDataSource = MockLocalDataSource();
    container = ProviderContainer(
      overrides: [
        observationRepositoryProvider.overrideWithValue(mockObservationRepository),
        localDataSourceProvider.overrideWithValue(mockLocalDataSource),
      ],
    );
    observationNotifier = container.read(observationProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('ObservationNotifier Tests', () {
    test('initial state should be empty', () {
      expect(observationNotifier.state.observations, []);
      expect(observationNotifier.state.selectedObservation, null);
      expect(observationNotifier.state.isLoading, false);
      expect(observationNotifier.state.error, null);
    });

    group('fetchObservations', () {
      test('should update state with observations on successful fetch', () async {
        when(mockObservationRepository.getObservations())
            .thenAnswer((_) async => [testObservation, testObservation2]);

        await observationNotifier.fetchObservations();

        expect(observationNotifier.state.observations, [testObservation, testObservation2]);
        expect(observationNotifier.state.isLoading, false);
        expect(observationNotifier.state.error, null);
      });

      test('should handle fetch error and return empty list', () async {
        when(mockObservationRepository.getObservations())
            .thenThrow(Exception('Failed to fetch observations'));

        await observationNotifier.fetchObservations();

        expect(observationNotifier.state.observations, []);
        expect(observationNotifier.state.isLoading, false);
        expect(observationNotifier.state.error, 'Exception: Failed to fetch observations');
      });
    });

    group('fetchObservation', () {
      test('should update state with selected observation on successful fetch', () async {
        when(mockObservationRepository.getObservation(1))
            .thenAnswer((_) async => testObservation);

        await observationNotifier.fetchObservation(1);

        expect(observationNotifier.state.selectedObservation, testObservation);
        expect(observationNotifier.state.isLoading, false);
        expect(observationNotifier.state.error, null);
      });

      test('should handle fetch error for single observation', () async {
        when(mockObservationRepository.getObservation(1))
            .thenThrow(Exception('Failed to fetch observation'));

        await observationNotifier.fetchObservation(1);

        expect(observationNotifier.state.selectedObservation, null);
        expect(observationNotifier.state.isLoading, false);
        expect(observationNotifier.state.error, 'Exception: Failed to fetch observation');
      });
    });

    group('addObservation', () {
      final obsData = {
        'related_plant': 1,
        'date': '2024-01-01',
        'time': '10:30',
        'location': 'Test Location',
        'note': 'Test Note',
      };

      test('should add observation to state on successful creation', () async {
        final newObservation = testObservation.copyWith(id: 3);

        when(mockObservationRepository.addObservation(obsData, null))
            .thenAnswer((_) async => newObservation);

        await observationNotifier.addObservation(obsData, null);

        expect(observationNotifier.state.observations, [newObservation]);
        expect(observationNotifier.state.isLoading, false);
        expect(observationNotifier.state.error, null);
      });

      test('should handle add observation error', () async {
        when(mockObservationRepository.addObservation(obsData, null))
            .thenThrow(Exception('Failed to add observation'));

        await observationNotifier.addObservation(obsData, null);

        expect(observationNotifier.state.observations, []);
        expect(observationNotifier.state.isLoading, false);
        expect(observationNotifier.state.error, 'Exception: Failed to add observation');
      });
    });

    group('updateObservation', () {
      final updateData = {
        'related_plant': 1,
        'date': '2024-01-01',
        'time': '11:00',
        'location': 'Updated Location',
        'note': 'Updated Note',
      };

      test('should update observation in state on successful update', () async {
        // First add an observation to the state
        when(mockObservationRepository.getObservations())
            .thenAnswer((_) async => [testObservation]);
        await observationNotifier.fetchObservations();

        final updatedObservation = testObservation.copyWith(
          time: const TimeOfDay(hour: 11, minute: 0),
          location: 'Updated Location',
          note: 'Updated Note',
        );

        when(mockObservationRepository.updateObservation(1, updateData, null))
            .thenAnswer((_) async => updatedObservation);

        await observationNotifier.updateObservation(1, updateData, null);

        expect(observationNotifier.state.observations, [updatedObservation]);
        expect(observationNotifier.state.isLoading, false);
        expect(observationNotifier.state.error, null);
      });

      test('should handle update observation error', () async {
        when(mockObservationRepository.updateObservation(1, updateData, null))
            .thenThrow(Exception('Failed to update observation'));

        await observationNotifier.updateObservation(1, updateData, null);

        expect(observationNotifier.state.isLoading, false);
        expect(observationNotifier.state.error, 'Exception: Failed to update observation');
      });
    });

    group('deleteObservation', () {
      test('should remove observation from state on successful deletion', () async {
        // First add observations to the state
        when(mockObservationRepository.getObservations())
            .thenAnswer((_) async => [testObservation, testObservation2]);
        await observationNotifier.fetchObservations();

        when(mockObservationRepository.deleteObservation(1))
            .thenAnswer((_) async => null);

        await observationNotifier.deleteObservation(1);

        expect(observationNotifier.state.observations, [testObservation2]);
        expect(observationNotifier.state.isLoading, false);
        expect(observationNotifier.state.error, null);
      });

      test('should handle delete observation error', () async {
        when(mockObservationRepository.deleteObservation(1))
            .thenThrow(Exception('Failed to delete observation'));

        await observationNotifier.deleteObservation(1);

        expect(observationNotifier.state.isLoading, false);
        expect(observationNotifier.state.error, 'Exception: Failed to delete observation');
      });
    });
  });
} 

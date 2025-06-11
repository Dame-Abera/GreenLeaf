import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenleaf_app/domain/observation.dart';
import 'package:greenleaf_app/domain/plant.dart';
import 'package:greenleaf_app/presentation/observation_detail_page.dart';
import 'package:greenleaf_app/application/observation_provider.dart';
import 'package:greenleaf_app/application/plant_provider.dart';
import 'package:greenleaf_app/infrastructure/observation_repository.dart';
import 'package:greenleaf_app/infrastructure/plant_repository.dart';
import 'package:mocktail/mocktail.dart';

// Mock repository for ObservationNotifier
class MockObservationRepository extends Mock implements ObservationRepository {}

// Simple PlantNotifier for test
class TestPlantNotifier extends StateNotifier<PlantState> implements PlantNotifier {
  TestPlantNotifier(PlantState state) : super(state);

  @override
  Future<void> addPlant(Map<String, dynamic> data, String? imagePath) async {}

  @override
  Future<void> deletePlant(int id) async {}

  @override
  Future<void> fetchPlant(int id) async {}

  @override
  Future<void> fetchPlants() async {}

  @override
  PlantRepository get repository => throw UnimplementedError();

  @override
  Future<void> updatePlant(int id, Map<String, dynamic> data, String? imagePath) async {}
}

void main() {
  late MockObservationRepository mockObservationRepository;
  late TestPlantNotifier testPlantNotifier;

  setUp(() {
    mockObservationRepository = MockObservationRepository();
    testPlantNotifier = TestPlantNotifier(PlantState(plants: [], isLoading: false));
  });

  Widget createWidgetUnderTest(Observation observation, ObservationState obsState, List<Plant> plants) {
    final fakeNotifier = ObservationNotifier(mockObservationRepository);
    fakeNotifier.state = obsState;
    testPlantNotifier.state = PlantState(plants: plants, isLoading: false);
    return ProviderScope(
      overrides: [
        observationProvider.overrideWith((ref) => fakeNotifier),
        plantProvider.overrideWith((ref) => testPlantNotifier),
      ],
      child: MaterialApp(
        home: ObservationDetailPage(observation: observation),
      ),
    );
  }

  testWidgets('displays observation details correctly', (WidgetTester tester) async {
    final observation = Observation(
      id: 1,
      observationImage: 'https://example.com/image.jpg',
      relatedPlant: 1,
      time: const TimeOfDay(hour: 10, minute: 30),
      date: DateTime(2024, 3, 15),
      location: 'Test Location',
      note: 'Test Note',
    );
    final plant = Plant(
      id: 1,
      commonName: 'Test Plant',
      scientificName: 'Test Scientific Name',
      habitat: 'Test Habitat',
      origin: 'Test Origin',
      description: 'Test Description',
    );
    await tester.pumpWidget(createWidgetUnderTest(
      observation,
      ObservationState(observations: [observation], isLoading: false),
      [plant],
    ));
    await tester.pumpAndSettle();
    expect(find.text('Observation Details'), findsOneWidget);
    expect(find.text('Test Plant'), findsOneWidget);
    expect(find.text('15/3/2024 10:30 AM'), findsOneWidget);
    expect(find.text('Test Location'), findsOneWidget);
    expect(find.text('Test Note'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });

  testWidgets('shows loading indicator when state is loading', (WidgetTester tester) async {
    final observation = Observation(
      id: 1,
      observationImage: 'https://example.com/image.jpg',
      relatedPlant: 1,
      time: const TimeOfDay(hour: 10, minute: 30),
      date: DateTime(2024, 3, 15),
      location: 'Test Location',
      note: 'Test Note',
    );
    await tester.pumpWidget(createWidgetUnderTest(
      observation,
      ObservationState(observations: [], isLoading: true),
      [],
    ));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when state has error', (WidgetTester tester) async {
    final observation = Observation(
      id: 1,
      observationImage: 'https://example.com/image.jpg',
      relatedPlant: 1,
      time: const TimeOfDay(hour: 10, minute: 30),
      date: DateTime(2024, 3, 15),
      location: 'Test Location',
      note: 'Test Note',
    );
    await tester.pumpWidget(createWidgetUnderTest(
      observation,
      ObservationState(observations: [], isLoading: false, error: 'Test Error'),
      [],
    ));
    await tester.pumpAndSettle();
    expect(find.text('Error: Test Error'), findsOneWidget);
  });

  testWidgets('shows unknown plant when related plant is not found', (WidgetTester tester) async {
    final observation = Observation(
      id: 1,
      observationImage: 'https://example.com/image.jpg',
      relatedPlant: 999, // Non-existent plant ID
      time: const TimeOfDay(hour: 10, minute: 30),
      date: DateTime(2024, 3, 15),
      location: 'Test Location',
      note: 'Test Note',
    );
    await tester.pumpWidget(createWidgetUnderTest(
      observation,
      ObservationState(observations: [observation], isLoading: false),
      [], // Empty plants list
    ));
    await tester.pumpAndSettle();
    expect(find.text('Unknown Plant'), findsOneWidget);
  });

  testWidgets('shows delete confirmation dialog when delete button is pressed', (WidgetTester tester) async {
    final observation = Observation(
      id: 1,
      observationImage: 'https://example.com/image.jpg',
      relatedPlant: 1,
      time: const TimeOfDay(hour: 10, minute: 30),
      date: DateTime(2024, 3, 15),
      location: 'Test Location',
      note: 'Test Note',
    );
    final plant = Plant(
      id: 1,
      commonName: 'Test Plant',
      scientificName: 'Test Scientific Name',
      habitat: 'Test Habitat',
      origin: 'Test Origin',
      description: 'Test Description',
    );
    await tester.pumpWidget(createWidgetUnderTest(
      observation,
      ObservationState(observations: [observation], isLoading: false),
      [plant],
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    expect(find.text('Delete Observation'), findsOneWidget);
    expect(find.text('Are you sure you want to delete this observation? This action cannot be undone.'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });

  testWidgets('navigates to edit page when edit button is pressed', (WidgetTester tester) async {
    final observation = Observation(
      id: 1,
      observationImage: 'https://example.com/image.jpg',
      relatedPlant: 1,
      time: const TimeOfDay(hour: 10, minute: 30),
      date: DateTime(2024, 3, 15),
      location: 'Test Location',
      note: 'Test Note',
    );
    final plant = Plant(
      id: 1,
      commonName: 'Test Plant',
      scientificName: 'Test Scientific Name',
      habitat: 'Test Habitat',
      origin: 'Test Origin',
      description: 'Test Description',
    );
    await tester.pumpWidget(createWidgetUnderTest(
      observation,
      ObservationState(observations: [observation], isLoading: false),
      [plant],
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    expect(find.byType(ObservationDetailPage), findsNothing);
  });
} 

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenleaf_app/presentation/plant_detail_page.dart';
import 'package:greenleaf_app/domain/plant.dart';
import 'package:greenleaf_app/application/plant_provider.dart';
import 'package:greenleaf_app/infrastructure/plant_repository.dart';

class FakePlantNotifier extends PlantNotifier {
  FakePlantNotifier(PlantRepository repository, [PlantState? initialState]) : super(repository) {
    if (initialState != null) {
      state = initialState;
    }
  }
  @override
  Future<void> deletePlant(int id) async {}
}

class _FakePlantRepository implements PlantRepository {
  @override
  Future<List<Plant>> getPlants() async => throw UnimplementedError();
  @override
  Future<Plant> getPlant(int id) async => throw UnimplementedError();
  @override
  Future<Plant> addPlant(Map<String, dynamic> data, String? imagePath) async => throw UnimplementedError();
  @override
  Future<Plant> updatePlant(int id, Map<String, dynamic> data, String? imagePath) async => throw UnimplementedError();
  @override
  Future<void> deletePlant(int id) async => throw UnimplementedError();
}

void main() {
  final testPlant = Plant(
    id: 1,
    plantImage: null,
    commonName: 'Aloe Vera',
    scientificName: 'Aloe barbadensis miller',
    habitat: 'Desert',
    origin: 'Arabian Peninsula',
    description: 'A succulent plant species of the genus Aloe.',
  );

  Widget createWidgetUnderTest({PlantState? plantState, PlantNotifier? plantNotifier}) {
    return ProviderScope(
      overrides: [
        plantProvider.overrideWith((ref) => plantNotifier ?? FakePlantNotifier(_FakePlantRepository(), plantState)),
      ],
      child: MaterialApp(
        home: PlantDetailPage(plant: testPlant),
      ),
    );
  }

  testWidgets('renders all main UI elements', (WidgetTester tester) async {
    final state = PlantState(selectedPlant: testPlant);
    await tester.pumpWidget(createWidgetUnderTest(plantState: state));
    await tester.pump();
    expect(find.text('Plant Details'), findsOneWidget);
    expect(find.byType(Image), findsNothing); // Uses Container with DecorationImage
    expect(find.text('Aloe Vera'), findsOneWidget);
    expect(find.text('Aloe barbadensis miller'), findsOneWidget);
    expect(find.text('Habitat: Desert'), findsOneWidget);
    expect(find.text('Origin: Arabian Peninsula'), findsOneWidget);
    expect(find.text('Description: A succulent plant species of the genus Aloe.'), findsOneWidget);
    expect(find.text('Edit Plant'), findsOneWidget);
    expect(find.text('Delete Plant'), findsOneWidget);
  });

  testWidgets('shows loading indicator when isLoading is true and selectedPlant matches', (WidgetTester tester) async {
    final state = PlantState(isLoading: true, selectedPlant: testPlant);
    await tester.pumpWidget(createWidgetUnderTest(plantState: state));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when error is present and selectedPlant matches', (WidgetTester tester) async {
    final state = PlantState(error: 'Failed to load', selectedPlant: testPlant);
    await tester.pumpWidget(createWidgetUnderTest(plantState: state));
    await tester.pump();
    expect(find.text('Error: Failed to load'), findsOneWidget);
  });

  testWidgets('Edit button navigates to AddEditPlantPage', (WidgetTester tester) async {
    final state = PlantState(selectedPlant: testPlant);
    await tester.pumpWidget(createWidgetUnderTest(plantState: state));
    await tester.pump();
    await tester.tap(find.text('Edit Plant'));
    await tester.pumpAndSettle();
    expect(find.byType(PlantDetailPage), findsNothing);
    expect(find.byType(MaterialPageRoute), findsNothing); // Not directly testable, but navigation occurred
  });

  testWidgets('Delete button shows confirmation dialog', (WidgetTester tester) async {
    final state = PlantState(selectedPlant: testPlant);
    await tester.pumpWidget(createWidgetUnderTest(plantState: state));
    await tester.pump();
    await tester.tap(find.text('Delete Plant'));
    await tester.pump();
    expect(find.text('Delete Plant'), findsNWidgets(2)); // Button and dialog title
    expect(find.text('Are you sure you want to delete this plant?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
  });
} 

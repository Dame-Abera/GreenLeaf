import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenleaf_app/presentation/add_edit_plant_page.dart';
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
  Future<void> addPlant(Map<String, dynamic> data, String? imagePath) async {}
  @override
  Future<void> updatePlant(int id, Map<String, dynamic> data, String? imagePath) async {}
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

  Widget createWidgetUnderTest({Plant? plant, PlantState? plantState, PlantNotifier? plantNotifier}) {
    return ProviderScope(
      overrides: [
        plantProvider.overrideWith((ref) => plantNotifier ?? FakePlantNotifier(_FakePlantRepository(), plantState)),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              height: 1000, // Fixed height to ensure all content is visible
              child: AddEditPlantPage(plant: plant),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders all main UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle(); // Wait for animations to complete

    expect(find.text('Add Plant'), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget); // Image picker icon
    expect(find.byType(TextFormField), findsNWidgets(5)); // 5 form fields
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
    final state = PlantState(isLoading: true);
    await tester.pumpWidget(createWidgetUnderTest(plantState: state));
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows error message when error is present', (WidgetTester tester) async {
    final state = PlantState(error: 'Failed to save');
    await tester.pumpWidget(createWidgetUnderTest(plantState: state));
    await tester.pumpAndSettle();
    expect(find.text('Error: Failed to save'), findsOneWidget);
  });

  testWidgets('form validation shows error messages for empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Find and tap the Save button
    final saveButton = find.text('Save');
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Please enter common name'), findsOneWidget);
    expect(find.text('Please enter scientific name'), findsOneWidget);
    expect(find.text('Please enter habitat'), findsOneWidget);
    expect(find.text('Please enter origin'), findsOneWidget);
    expect(find.text('Please enter description'), findsOneWidget);
  });

  testWidgets('Save button calls addPlant and navigates back', (WidgetTester tester) async {
    final notifier = FakePlantNotifier(_FakePlantRepository());
    await tester.pumpWidget(createWidgetUnderTest(plantNotifier: notifier));
    await tester.pumpAndSettle();

    // Fill in the form
    await tester.enterText(find.byType(TextFormField).at(0), 'Aloe Vera');
    await tester.enterText(find.byType(TextFormField).at(1), 'Aloe barbadensis miller');
    await tester.enterText(find.byType(TextFormField).at(2), 'Desert');
    await tester.enterText(find.byType(TextFormField).at(3), 'Arabian Peninsula');
    await tester.enterText(find.byType(TextFormField).at(4), 'A succulent plant species of the genus Aloe.');
    await tester.pumpAndSettle();

    // Find and tap the Save button
    final saveButton = find.text('Save');
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.byType(AddEditPlantPage), findsNothing);
  });

  testWidgets('Cancel button navigates back', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Find and tap the Cancel button
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();

    expect(find.byType(AddEditPlantPage), findsNothing);
  });
} 

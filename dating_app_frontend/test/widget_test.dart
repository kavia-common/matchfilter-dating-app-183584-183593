import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dating_app_frontend/main.dart';

void main() {
  testWidgets('Filters page renders and shows preference field',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    // App bar title for Filters
    expect(find.text('Filters'), findsOneWidget);

    // Preference field exists
    final prefField = find.byKey(const Key('preference_textfield'));
    expect(prefField, findsOneWidget);

    // Ethnicity and race dropdowns exist
    expect(find.byKey(const Key('ethnicity_dropdown')), findsOneWidget);
    expect(find.byKey(const Key('race_dropdown')), findsOneWidget);

    // Hair color chips exist
    expect(find.byKey(const Key('hair_blonde_chip')), findsOneWidget);
    expect(find.byKey(const Key('hair_brunette_chip')), findsOneWidget);
    expect(find.byKey(const Key('hair_dyed_chip')), findsOneWidget);
  });

  testWidgets('Apply and Clear buttons work', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Type into preference
    await tester.enterText(
        find.byKey(const Key('preference_textfield')), 'Casual');
    await tester.pump();

    // Open ethnicity dropdown and check curated options visible
    await tester.tap(find.byKey(const Key('ethnicity_dropdown')));
    await tester.pumpAndSettle();
    expect(find.text('Asian'), findsWidgets);
    expect(find.text('Black/African'), findsWidgets);
    expect(find.text('White/European'), findsWidgets);

    // Select one option
    await tester.tap(find.text('Asian').last);
    await tester.pumpAndSettle();

    // Open race dropdown and check curated options visible
    await tester.tap(find.byKey(const Key('race_dropdown')));
    await tester.pumpAndSettle();
    expect(find.text('American Indian or Alaska Native'), findsWidgets);
    expect(find.text('Black or African American'), findsWidgets);
    expect(find.text('Native Hawaiian or Other Pacific Islander'), findsWidgets);
    expect(find.text('Two or More Races'), findsWidgets);

    // Select one option
    await tester.tap(find.text('White').last);
    await tester.pumpAndSettle();

    // Tap Apply
    await tester.tap(find.byKey(const Key('apply_filters_button')));
    await tester.pump();

    // Tap Clear
    await tester.tap(find.byKey(const Key('clear_filters_button')));
    await tester.pump();
  });
}

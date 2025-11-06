import 'package:dating_app_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-end: open filters and interact', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Filters'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('preference_textfield')), 'Serious');
    await tester.pump();

    await tester.tap(find.byKey(const Key('ethnicity_dropdown')));
    await tester.pumpAndSettle();
    expect(find.text('Asian'), findsWidgets);

    await tester.tap(find.text('Asian').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('hair_blonde_chip')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('apply_filters_button')));
    await tester.pump(); // snack shows (not asserted here)
  });
}

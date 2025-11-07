import 'package:dating_app_frontend/screens/chat_screen.dart';
import 'package:dating_app_frontend/screens/matches_screen.dart';
import 'package:dating_app_frontend/services/match_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestApp extends StatelessWidget {
  const _TestApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (_) => MatchesScreen(),
        '/chat': (_) => const ChatScreen(),
      },
    );
  }
}

void main() {
  testWidgets('MockMatchService returns 3 items', (tester) async {
    final service = MockMatchService();
    final items = await service.fetchMatches({'eth': 'asian', 'hair': 'blonde'});
    expect(items.length, 3);
    expect(items.first.name.contains('eth:asian'), isTrue);
    expect(items.first.name.contains('hair:blonde'), isTrue);
  });

  testWidgets('Navigate from Matches to Chat', (tester) async {
    await tester.pumpWidget(const _TestApp());
    expect(find.text('Matches'), findsOneWidget);
    await tester.tap(find.byKey(const Key('match_item_0')));
    await tester.pumpAndSettle();
    expect(find.text('Chat'), findsOneWidget);
    expect(find.byKey(const Key('chat_with_text')), findsOneWidget);
  });
}

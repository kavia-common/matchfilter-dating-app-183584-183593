import 'package:dating_app_frontend/widgets/profile_card.dart';
import 'package:dating_app_frontend/widgets/swipe_deck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileCard renders like/dislike icons', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ProfileCard(name: 'Alice', subtitle: 'NYC'),
      ),
    ));
    expect(find.text('Alice'), findsOneWidget);
    expect(find.byKey(const Key('dislike_icon')), findsOneWidget);
    expect(find.byKey(const Key('like_icon')), findsOneWidget);
  });

  testWidgets('SwipeDeck like/dislike advances and calls callbacks', (tester) async {
    int likes = 0;
    int dislikes = 0;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SwipeDeck(
          cards: const [
            Card(child: SizedBox(height: 100, width: 100, child: Text('Card 1'))),
            Card(child: SizedBox(height: 100, width: 100, child: Text('Card 2'))),
          ],
          onSwipe: (liked) {
            if (liked) {
              likes++;
            } else {
              dislikes++;
            }
          },
        ),
      ),
    ));

    expect(find.text('Card 1'), findsOneWidget);
    await tester.tap(find.byKey(const Key('swipe_like_button')));
    await tester.pump();
    expect(likes, 1);
    expect(find.text('Card 2'), findsOneWidget);

    await tester.tap(find.byKey(const Key('swipe_dislike_button')));
    await tester.pump();
    expect(dislikes, 1);
    expect(find.text('No more cards'), findsOneWidget);
  });
}

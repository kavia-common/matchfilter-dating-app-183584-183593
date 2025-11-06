import 'package:dating_app_frontend/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FilterPreferences encodes multiple selections as CSV', () {
    final prefs = FilterPreferences(
      preference: 'Casual',
      ethnicity: const ['asian', 'mena'],
      race: const ['white', 'two_or_more'],
      hairColor: const [HairColor.blonde, HairColor.brunette],
    );
    final q = prefs.toQueryParams();
    expect(q['pref'], 'Casual');
    expect(q['eth'], 'asian,mena');
    expect(q['race'], 'white,two_or_more');
    expect(q['hair'], 'blonde,brunette');
  });

  test('Empty values are omitted from query', () {
    final prefs = FilterPreferences(
      preference: '   ',
      ethnicity: const ['', '   '],
      race: const <String>[],
      hairColor: const <HairColor>[],
    );
    final q = prefs.toQueryParams();
    expect(q.containsKey('pref'), isFalse);
    expect(q.containsKey('eth'), isFalse);
    expect(q.containsKey('race'), isFalse);
    expect(q.containsKey('hair'), isFalse);
  });
}

import 'package:dating_app_frontend/main.dart';
import 'package:dating_app_frontend/repositories/match_repository.dart';
import 'package:dating_app_frontend/services/match_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _CapturingMockService implements MatchService {
  Map<String, String>? lastQuery;

  _CapturingMockService();

  @override
  Future<List<MatchItem>> fetchMatches(Map<String, String> query) async {
    lastQuery = Map<String, String>.from(query);
    return const <MatchItem>[];
  }
}

void main() {
  test('Repository maps FilterPreferences to correct query params', () async {
    final mock = _CapturingMockService();
    final repo = MatchRepository(mock);

    final prefs = FilterPreferences(
      preference: 'Serious',
      ethnicity: const ['asian'],
      race: const ['white'],
      hairColor: const [HairColor.brunette],
    );

    await repo.fetchMatches(prefs);

    expect(mock.lastQuery, isNotNull);
    expect(mock.lastQuery!['pref'], 'Serious');
    expect(mock.lastQuery!['eth'], 'asian');
    expect(mock.lastQuery!['race'], 'white');
    expect(mock.lastQuery!['hair'], 'brunette');
  });

  test('Repository omits empty/null fields from query', () async {
    final mock = _CapturingMockService();
    final repo = MatchRepository(mock);

    final prefs = FilterPreferences(
      preference: '   ', // trimmed empty
      ethnicity: null,
      race: const ['white'],
      hairColor: null,
    );

    await repo.fetchMatches(prefs);
    expect(mock.lastQuery, isNotNull);
    expect(mock.lastQuery!.containsKey('pref'), isFalse);
    expect(mock.lastQuery!.containsKey('eth'), isFalse);
    expect(mock.lastQuery!['race'], 'white');
    expect(mock.lastQuery!.containsKey('hair'), isFalse);
  });

  test('Repository CSV encodes multiple selections', () async {
    final mock = _CapturingMockService();
    final repo = MatchRepository(mock);

    final prefs = FilterPreferences(
      preference: 'Casual',
      ethnicity: const ['asian', 'mena'],
      race: const ['white', 'two_or_more'],
      hairColor: const [HairColor.blonde, HairColor.dyed],
    );

    await repo.fetchMatches(prefs);

    expect(mock.lastQuery, isNotNull);
    expect(mock.lastQuery!['pref'], 'Casual');
    expect(mock.lastQuery!['eth'], 'asian,mena');
    expect(mock.lastQuery!['race'], 'white,two_or_more');
    expect(mock.lastQuery!['hair'], 'blonde,dyed');
  });

  test('Repository omits keys when lists empty or only empty strings', () async {
    final mock = _CapturingMockService();
    final repo = MatchRepository(mock);

    final prefs = FilterPreferences(
      preference: null,
      ethnicity: const ['', '   '], // empties should be ignored -> omit key
      race: const <String>[], // empty -> omit key
      hairColor: const <HairColor>[], // empty -> omit key
    );

    await repo.fetchMatches(prefs);

    expect(mock.lastQuery, isNotNull);
    expect(mock.lastQuery!.containsKey('eth'), isFalse);
    expect(mock.lastQuery!.containsKey('race'), isFalse);
    expect(mock.lastQuery!.containsKey('hair'), isFalse);
  });

  test('Mock service returns deterministic results', () async {
    final service = MockMatchService();
    final items = await service.fetchMatches({'eth': 'asian', 'hair': 'blonde'});
    expect(items.length, 3);
    expect(items.first.name.contains('eth:asian'), isTrue);
    expect(items.first.name.contains('hair:blonde'), isTrue);
  });
}

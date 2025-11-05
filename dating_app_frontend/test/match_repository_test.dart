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
      ethnicity: 'asian',
      race: 'white',
      hairColor: HairColor.brunette,
    );

    await repo.fetchMatches(prefs);

    expect(mock.lastQuery, isNotNull);
    expect(mock.lastQuery!['preference'], 'Serious');
    expect(mock.lastQuery!['ethnicity'], 'asian');
    expect(mock.lastQuery!['race'], 'white');
    expect(mock.lastQuery!['hair_color'], 'brunette');
  });

  test('Repository omits empty/null fields from query', () async {
    final mock = _CapturingMockService();
    final repo = MatchRepository(mock);

    final prefs = FilterPreferences(
      preference: '   ', // trimmed empty
      ethnicity: null,
      race: 'white',
      hairColor: null,
    );

    await repo.fetchMatches(prefs);
    expect(mock.lastQuery, isNotNull);
    expect(mock.lastQuery!.containsKey('preference'), isFalse);
    expect(mock.lastQuery!.containsKey('ethnicity'), isFalse);
    expect(mock.lastQuery!['race'], 'white');
    expect(mock.lastQuery!.containsKey('hair_color'), isFalse);
  });

  test('Mock service returns deterministic results', () async {
    final service = MockMatchService();
    final items = await service.fetchMatches({'ethnicity': 'asian', 'hair_color': 'blonde'});
    expect(items.length, 3);
    expect(items.first.name.contains('ethnicity:asian'), isTrue);
    expect(items.first.name.contains('hair_color:blonde'), isTrue);
  });
}

import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:haruharu9600/word.dart';
import 'package:state_notifier/state_notifier.dart';

String randomString(int length) {
  const _randomChars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  const _charsLength = _randomChars.length;

  final rand = Random();
  final codeUnits = List.generate(
    length,
    (index) {
      final n = rand.nextInt(_charsLength);
      return _randomChars.codeUnitAt(n);
    },
  );
  return String.fromCharCodes(codeUnits);
}

class WordPairListViewModel extends StateNotifier<Words> {
  WordPairListViewModel() : super(const Words(words: [])) {
    fetchList();
  }

  void fetchList() {
    var index = 0;
    final words = generateWordPairs()
        .take(15)
        .map((wordPair) => Word(
              id: state.words.length + index++,
              wordPair: wordPair.asPascalCase,
              isFavorite: false,
            ))
        .toList();
    final newList = [...state.words, ...words];
    state = state.copyWith(words: newList);
  }

  void updateFavorite({required int id, required bool hasFavorite}) {
    final newList = state.words
        .map((word) =>
            word.id == id ? word.copyWith(isFavorite: !hasFavorite) : word)
        .toList();
    state = state.copyWith(words: newList);
  }
}

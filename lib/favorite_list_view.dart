import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:haruharu9600/main.dart';
import 'package:haruharu9600/word.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoriteListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('backyard'),
      ),
      body: _BuildList(),
    );
  }
}

class _BuildList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = useProvider(favoriteListViewModelProvider.state).words;
    return favorites.isNotEmpty
        ? ListView.builder(
            itemCount: favorites.length,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            itemBuilder: (BuildContext _context, int index) =>
                _buildRow(context, favorites[index]))
        : _emptyView();
  }

  Widget _emptyView() {
    return const Center(
      child: Text('登録されていません'),
    );
  }

  Widget _buildRow(BuildContext context, Word word) {
    return SizedBox(
      height: 80,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                word.wordPair,
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: Icon(word.isFavorite
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank),
                color: word.isFavorite ? Colors.green : null,
                onPressed: () {
                  context
                      .read(favoriteListViewModelProvider)
                      .insertOrDeleteFavorite(
                          id: word.id,
                          wordPair: word.wordPair,
                          hasFavorite: word.isFavorite);

                  context.read(wordPairListViewModelProvider).updateFavorite(
                      id: word.id, hasFavorite: word.isFavorite);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

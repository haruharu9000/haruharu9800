import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:haruharu9600/main.dart';
import 'package:haruharu9600/word.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WordPairListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<WordPairListView> {
  var _city = '';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('order'),
      ),
      drawer: Container(
        width: 300,
        child: ClipRRect(
          // 角丸のためにラップ
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
          child: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Text('ヘッダー'),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                  ),
                ),
                ListTile(
                  title: Text("ログイン画面"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    setState(() => _city = 'Los Angeles, CA');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  },
                ),
                ListTile(
                  title: Text("ボタン"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
                ListTile(
                  title: Text("ボタン"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _BuildList(),
    );
  }
}

class _BuildList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final words = useProvider(wordPairListViewModelProvider.state).words;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      itemBuilder: (BuildContext _context, int index) {
        if (index >= words.length) {
          // build中にstateを操作をするとErrorになる為Futureで非同期化
          Future<void>(
            () => context.read(wordPairListViewModelProvider).fetchList(),
          );
        }
        return _buildRow(context, words[index]);
      },
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
                  context.read(wordPairListViewModelProvider).updateFavorite(
                      id: word.id, hasFavorite: word.isFavorite);
                  context
                      .read(favoriteListViewModelProvider)
                      .insertOrDeleteFavorite(
                          id: word.id,
                          wordPair: word.wordPair,
                          hasFavorite: word.isFavorite);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

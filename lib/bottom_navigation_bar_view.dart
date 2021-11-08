import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:haruharu9600/favorite_list_view.dart';
import 'package:haruharu9600/main.dart';
import 'package:haruharu9600/word_pair_list_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BottomNavigationBarView extends HookWidget {
  final _views = [
    WordPairListView(),
    FavoriteListView(),
  ];

  static Map<int, Color> color = {
    50: const Color(0xFFe4f1f5),
    100: const Color(0xFFbcdbe5),
    200: const Color(0xFF8fc4d4),
    300: const Color(0xFF62acc2),
    400: const Color(0xFF409ab5),
    500: const Color(0xFF1e88a8),
    600: const Color(0xFF1a80a0),
    700: const Color(0xFF167597),
    800: const Color(0xFF126b8d),
    900: const Color(0xFF0a587d),
  };

  final MaterialColor primeColor = MaterialColor(0xFF1e88a8, color);

  @override
  Widget build(BuildContext context) {
    final tabType = useProvider(tabTypeProvider);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: primeColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.expand_less),
              label: 'お待ち番号',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.expand_more),
              label: 'お呼出中の番号',
            ),
          ],
          onTap: (int selectIndex) {
            tabType.state = TabType.values[selectIndex];
          },
          currentIndex: tabType.state.index,
        ),
        body: _views[tabType.state.index],

        // body: ProviderScope(
        //   child: _views[_selectIndex],
        // ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:haruharu9600/bottom_navigation_bar_view.dart';
import 'package:haruharu9600/provider/google_sign_in.dart';
import 'package:haruharu9600/word_pair_list_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'favorite_list_view_model.dart';

final tabTypeProvider =
    AutoDisposeStateProvider<TabType>((ref) => TabType.wordPair);

final googleSignInProvider =
    ChangeNotifierProvider((ref) => GoogleSignInProvider());

enum TabType {
  wordPair,
  favorite,
}

final wordPairListViewModelProvider = StateNotifierProvider(
  (ref) => WordPairListViewModel(),
);

final favoriteListViewModelProvider = StateNotifierProvider(
  (ref) => FavoriteListViewModel(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primeColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final provider = watch(googleSignInProvider);

      return Scaffold(
        appBar: AppBar(
          title: Text('Google Sign In'),
        ),
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (provider.isSignIn) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                final user = FirebaseAuth.instance.currentUser;
                return Container(
                  alignment: Alignment.center,
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Logged In'),
                      SizedBox(height: 10),
                      CircleAvatar(
                          maxRadius: 25,
                          backgroundImage:
                              NetworkImage(user!.photoURL.toString())),
                      SizedBox(height: 10),
                      Text('Name: ' + user.displayName.toString()),
                      SizedBox(height: 10),
                      Text('Email: ' + user.email.toString()),
                      SizedBox(
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(
                        height: 40, // Widgetの高さを指定
                        width: 80, // W
                        child: ElevatedButton(
                          onPressed: () {
                            context.read(googleSignInProvider).logout();
                          },
                          child: Text('Logout'),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: 40,
                      ),
                      SizedBox(
                        height: 40, // Widgetの高さを指定
                        width: 80, // W
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BottomNavigationBarView()),
                            );
                          },
                          child: Text("order"),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SignInButton(
                        Buttons.Google,
                        text: "Sign up with Google",
                        onPressed: () {
                          context.read(googleSignInProvider).login();
                        },
                      ),
                    ],
                  ),
                );
              }
            }),
      );
    });
  }
}

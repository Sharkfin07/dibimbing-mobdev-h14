import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_note/firebase/firebase_options.dart';
import 'package:flutter_note/pages/note_home_page.dart';
import 'package:flutter_note/pages/signin_page.dart';
import 'package:flutter_note/pages/signup_page.dart';
import 'package:flutter_note/providers/auth_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
      ),
      routes: {
        '/home': (context) => const NoteHomePage(),
        '/signup': (context) => const SignupPage(),
        '/signin': (context) => const SigninPage(),
      },
      home: authState.when(
        data: (user) =>
            user == null ? const SigninPage() : const NoteHomePage(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) =>
            Scaffold(body: Center(child: Text('Auth error: $err'))),
      ),
    );
  }
}

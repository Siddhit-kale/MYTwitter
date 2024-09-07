import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mytwitter/firebase_options.dart';
import 'package:mytwitter/services/auth/auth_gate.dart';
import 'package:mytwitter/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // Firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ChangeNotifierProvider(
    create: (conetext) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

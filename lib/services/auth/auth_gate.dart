import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytwitter/pages/home_page.dart';
import 'package:mytwitter/services/auth/login_or_register.dart';

/*
  Auth Gate

  if user is logged in -> go to home page
  if user is not logged in -> go to login and register page

 */

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // user logged in
        if (snapshot.hasData) {
          return const HomePage();
        }

        // user not logged in
        else {
          return const LoginOrRegister();
        }
      },
    ));
  }
}

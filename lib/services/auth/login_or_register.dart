import 'package:flutter/material.dart';
import 'package:mytwitter/pages/login_page.dart';
import 'package:mytwitter/pages/register_page.dart';

/* 
  Login or Register page
*/

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially, show login page
  bool showLoginPage = true;

  // toggle between login & Register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTab: togglePages,
      );
    } else {
      return RegisterPage(
        onTab: togglePages,
      );
    }
  }
}

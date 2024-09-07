import 'package:flutter/material.dart';
import 'package:mytwitter/components/my_button.dart';
import 'package:mytwitter/components/my_loading_circle.dart';
import 'package:mytwitter/components/my_text_field.dart';
import 'package:mytwitter/services/auth/auth_service.dart';

/*
    login page 

    - email
    - password

*/

class LoginPage extends StatefulWidget {
  final void Function()? onTab;

  const LoginPage({super.key, required this.onTab});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // access with service
  final _auth = AuthService();

  // text contorller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  // login method
  void login() async {
    // show loading circle
    showLoadingCircle(context);

    try {
      await _auth.loginEmailPassword(emailController.text, pwController.text);

      // finished Loading..
      if (mounted) hideLoadingCircle(context);

    } catch (e) {
      // finished Loading..
      if (mounted) hideLoadingCircle(context);
      
      // let user know there was an error
       if (mounted) {
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text("Invalid Credential"),
                  ),
            );
        }
    }
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    // Scaffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // Body
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),

                // Logo
                Icon(
                  Icons.lock_open_rounded,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),

                const SizedBox(
                  height: 50,
                ),

                // Welcome back message
                Text("Welcome back, you've beem missed!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    )),

                const SizedBox(height: 25),

                // Email textfile
                MyTextField(
                  controller: emailController,
                  hintText: "Enter Email..",
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Password textfiled
                MyTextField(
                  controller: pwController,
                  hintText: "Enter Password",
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // Forget password
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Sign in Button
                MyButton(
                  text: "Login",
                  onTab: login,
                ),

                const SizedBox(height: 25),

                // Not a member? Register now
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Not a member?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 5),

                  // user can tap this to register page.
                  GestureDetector(
                    onTap: widget.onTab,
                    child: Text(
                      " register Now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

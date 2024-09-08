import 'package:flutter/material.dart';
import 'package:mytwitter/components/my_button.dart';
import 'package:mytwitter/components/my_loading_circle.dart';
import 'package:mytwitter/components/my_text_field.dart';
import 'package:mytwitter/services/auth/auth_service.dart';
import 'package:mytwitter/services/database/database_service.dart';

/*
  Register page

  - name
  - email
  - password
  - confirm password

*/

class RegisterPage extends StatefulWidget {
  final void Function()? onTab;

  const RegisterPage({super.key, required this.onTab});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // access auth services
  final _auth = AuthService();
  final _db = DatabaseService();

  // text contorller
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  // register button tapped
  void register() async {
    // password macth -> create user
    if (pwController.text == confirmPwController.text) {
      // show loading circle
      showLoadingCircle(context);

      // attempt to register new user
      try {
        await _auth.registerEmailPassword(
            emailController.text, pwController.text);

        // finished loading..
        if (mounted) hideLoadingCircle(context);

        // once registered, create and save user profile in database
        await _db.saveUserInfoInFirebase(
            name: nameController.text, 
            email: emailController.text
          );

        // everythime we add a new package, it's will restart the app
        
      }

      // catch an error
      catch (e) {
        // finished loading..
        if (mounted) hideLoadingCircle(context);

        // let user know of the error
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
          );
        }
      }
    }

    // password don't match -> show error
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Password don't Match"),
        ),
      );
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

                // Create an account message
                Text("Let's Create an account for you",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    )),

                const SizedBox(height: 25),

                // Name textfile
                MyTextField(
                  controller: nameController,
                  hintText: "Enter Name..",
                  obscureText: false,
                ),

                const SizedBox(height: 10),

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

                // Confirm Password textfiled
                MyTextField(
                  controller: confirmPwController,
                  hintText: "Confirm Password",
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // Sign Up Button
                MyButton(
                  text: "Register",
                  onTab: register,
                ),

                const SizedBox(height: 25),

                // Already a member? Login here
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    "Already a member?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 5),

                  // user can tap this to Login page.
                  GestureDetector(
                    onTap: widget.onTab,
                    child: Text(
                      "Login here",
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

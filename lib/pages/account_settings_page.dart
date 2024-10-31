/*

  Accont settings page

*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mytwitter/services/auth/auth_service.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  // build ui
  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
  
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {

    // ask for confirmation from the user before deleting their account
  void confirmDeletion(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Account"),
              content: const Text("Are you sure you want to Delete this Account??"),
              actions: [
                // canecl
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),

                TextButton(
                  onPressed: () async {
                    await AuthService().deleteAccount();

                    // then navigate to initial route (Auth gate -> login/register)
                    Navigator.pushNamedAndRemoveUntil(
                        context, 
                        '/',
                        (route) => false
                      );
                  },
                  child: const Text("Delete"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Settings"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // body
      body: Column(
        children: [
          // delete tile
          GestureDetector(
            onTap: () => confirmDeletion(context),
            child: Container(
              padding: const EdgeInsets.all(25),
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text("Delete Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytwitter/components/my_settings_title.dart';
import 'package:mytwitter/themes/theme_provider.dart';
import 'package:provider/provider.dart';

/*
  Settings page

  -Dark mode
  -Blocked users
  -Account settings
 */

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // build ui
  @override
  Widget build(BuildContext context) {

    //sacffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // AppBar
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: Column(
        children: [
          MySettingsTitle(
            
            title: "Dark Mode",
            action: CupertinoSwitch(
              onChanged: (value) =>
                Provider.of<ThemeProvider>(context, listen: false)
                .toggletheme(),
              value: 
                Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            ),
            
            )
        ],
      ),


    );
  }
}
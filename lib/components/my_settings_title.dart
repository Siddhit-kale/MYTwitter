import 'package:flutter/material.dart';

/*
  Settings List title
    - this is a single title for each item in the settings page.

  -title eg. dark mode
  -action eg. toggleTheme()
*/

class MySettingsTitle extends StatelessWidget {
  final String title;
  final Widget action;

  const MySettingsTitle({
    super.key,
    required this.title,
    required this.action,
    });

  //build Ui
  @override
  Widget build(BuildContext context) {

    //List tile
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,

        borderRadius: BorderRadius.circular(12),
      ),

      //padding outside
      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),

      //padding inside 
      padding: const EdgeInsets.all(25),

      //List tile
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //title
          Text(
            title, 
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          //action
          action,
        ],

      ),
    );
  }
}

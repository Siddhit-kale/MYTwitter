import 'package:flutter/material.dart';

/*
User Bio Box

- this is a single box text inside
  - text
*/

class MyBioBox extends StatelessWidget {
  final String text;

  const MyBioBox({super.key, required this.text});

  // build Ui
  @override
  Widget build(BuildContext context) {

    // container
    return Container(
      decoration: BoxDecoration(
        // color
        color: Theme.of(context).colorScheme.secondary,

        // curve corners
        borderRadius: BorderRadius.circular(8),

      ),

      // padding inside 
      padding: const EdgeInsets.all(25),

      // text
      child: Text(
        text.isNotEmpty ? text : "Empty Bio..",
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}

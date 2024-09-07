import 'package:flutter/material.dart';

/*  
  Button 

  - text
  - function
*/

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTab;

  const MyButton({
    super.key,
    required this.text,
    required this.onTab,
  });

  // Build UI
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        padding: const EdgeInsets.all(25),

        decoration: BoxDecoration(
          // color of btton
          color: Theme.of(context).colorScheme.secondary,

          // Coverd coners
          borderRadius: BorderRadius.circular(12),

        ),
        child: Center(
          child: Text(text,
           style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            ),
           )
          ),
      ),
    );
  }
}

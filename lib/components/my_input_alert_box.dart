import 'package:flutter/material.dart';

/*
  Input Alert box

  - Text controller
  - hint text
  - function
  - text for button
*/

class MyInputAlertBox extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hinttext;
  final void Function()? onPressed;
  final String onPressedText;

  const MyInputAlertBox({
    super.key,
    required this.textEditingController,
    required this.hinttext,
    required this.onPressed,
    required this.onPressedText,
  });

  // buid ui
  @override
  Widget build(BuildContext context) {
    // Alert Dialog
    return AlertDialog(
      // Curve corners
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),

      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,

      // TextField user type here
      content: TextField(
        controller: textEditingController,

        // limit the max characters
        maxLength: 140,
        maxLines: 3,

        decoration: InputDecoration(
          // border when Textfield is unselected
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),

          // border when textfield is selected
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),

          // hint text
          hintText: hinttext,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),

          // color inside of textfield
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,

          // counter style
          counterStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),

      // buttons
      actions: [
        // cancel button
        TextButton(
            onPressed: () {
              // close button
              Navigator.pop(context);

              // clear controller
              textEditingController.clear();
            },
            child: const Text("Cancel")),

        // yes button
        TextButton(
            onPressed: () {
              Navigator.pop(context);

              // execute function
              onPressed!();

              // clear controller
              textEditingController.clear();
            },
            child: Text(onPressedText)),
      ],
    );
  }
}

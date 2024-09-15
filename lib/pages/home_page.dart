import 'package:flutter/material.dart';
import 'package:mytwitter/components/my_drawer.dart';
import 'package:mytwitter/components/my_input_alert_box.dart';
import 'package:mytwitter/services/database/database_provider.dart';
import 'package:provider/provider.dart';

/*
    Home Page

    - list Posts
*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // provider
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // text controller
  final _messageController = TextEditingController();

  // show post message dialog box
  void _openPostMessageBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textEditingController: _messageController,
        hinttext: "What's on Your Mind?",
        onPressed: () async {
          // post in db
          await postMessage(_messageController.text);
        },
        onPressedText: "Post",
      ),
    );
  }

  // user wants to post message
  Future<void> postMessage(String message) async {
    await databaseProvider.postMessage(message);
  }

  // build ui
  @override
  Widget build(BuildContext context) {
    // scaffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),

      // App bar
      appBar: AppBar(
        title: const Text("H O M E"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: _openPostMessageBox,
        child: const Icon(Icons.add),
      ),
    );
  }
}

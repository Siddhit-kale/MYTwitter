/*

  blocked users page

*/

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mytwitter/services/database/database_provider.dart';
import 'package:provider/provider.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  // providers
  late final listenableProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // on startup
  @override
  void initState() {
    super.initState();

    // load all blocked users
    loadBlockedUsers();
  }

  // load blocked user
  Future<void> loadBlockedUsers() async {
    await databaseProvider.loadBlockedUsers();
  }

  // show dialog of unblock
  void _showUnblockConfirmationBox(String userId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Unblock User"),
              content: const Text("Are you sure you want to Unblock this User??"),
              actions: [
                // canecl
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),

                TextButton(
                  onPressed: () async {
                    await databaseProvider.unblockUser(userId);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User Unblocked")));
                  },
                  child: const Text("Unblock"),
                )
              ],
            ));
  }

  // build ui
  @override
  Widget build(BuildContext context) {
    // listen to blocked users
    final blockedUsers = listenableProvider.blockedUsers;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // app bar
      appBar: AppBar(
        title: Text("Blocked Users"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // body
      body: blockedUsers.isEmpty
          ? Center(
              child: Text("No Blocked users.."),
            )
          : ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                final user = blockedUsers[index];

                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('@' + user.username),
                  trailing: IconButton(
                    icon: const Icon(Icons.block),
                    onPressed: () => _showUnblockConfirmationBox(user.uid),
                  ),
                );
              },
            ),
    );
  }
}

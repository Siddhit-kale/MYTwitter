/*
comment title

*/

import 'package:flutter/material.dart';
import 'package:mytwitter/models/comment.dart';
import 'package:mytwitter/services/auth/auth_service.dart';
import 'package:mytwitter/services/database/database_provider.dart';
import 'package:provider/provider.dart';

class MyCommentTitle extends StatelessWidget {
  final Comment comment;
  final void Function()? onUserTap;

  const MyCommentTitle({
    super.key,
    required this.comment,
    required this.onUserTap,
  });

  // show options for the post
  void _showOptions(BuildContext context) {
    // Check if the post is owned by the current user
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnComment = comment.uid == currentUid;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (isOwnComment) ...[
                // Delete comment option
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete"),
                  onTap: () async {
                    Navigator.pop(context); // pop option box
                    await Provider.of<DatabaseProvider>(context, listen: false)
                        .deleteComment(comment.id, comment.postId);
                  },
                ),
              ] else ...[
                // Report post option
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text("Report"),
                  onTap: () {
                    Navigator.pop(context); // pop option box
                    // handle report actions here
                  },
                ),
                // Block user option
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text("Block User"),
                  onTap: () {
                    Navigator.pop(context); // pop option box
                    // handle block actions here
                  },
                ),
              ],
              // Cancel button
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section: profile pic / name / username
          GestureDetector(
            onTap: onUserTap,
            child: Row(
              children: [


                // Profile pic (placeholder icon)
                Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),


                // Name
                Text(
                  comment.name,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),


                // Username handle
                Text(
                  '@${comment.username}',
                  style: const TextStyle(
                    color: Colors.blue,
                  ),
                ),
                const Spacer(),


                // More options button
                GestureDetector(
                  onTap: () => _showOptions(context),
                  child: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Message
          Text(
            comment.message,
            style:
                TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ],
      ),
    );
  }
}

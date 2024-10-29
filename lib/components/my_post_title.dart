import 'package:flutter/material.dart';
import 'package:mytwitter/models/post.dart';
import 'package:mytwitter/services/auth/auth_service.dart';
import 'package:mytwitter/services/database/database_provider.dart';
import 'package:provider/provider.dart';

class MyPostTitle extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;

  const MyPostTitle({
    super.key,
    required this.post,
    required this.onUserTap,
    required this.onPostTap,
  });

  @override
  State<MyPostTitle> createState() => _MyPostTitleState();
}

class _MyPostTitleState extends State<MyPostTitle> {
  // providers
  late final DatabaseProvider databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  late final DatabaseProvider listeningProvider =
      Provider.of<DatabaseProvider>(context); // Use listen: true for listening

  // user tapped like or unlike
  void _toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  // show options for the post
  void _showOptions() {
    // Check if the post is owned by the current user
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnPost = widget.post.uid == currentUid;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (isOwnPost) ...[
                // Delete message option
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text("Delete"),
                  onTap: () async {
                    Navigator.pop(context); // pop option box
                    await databaseProvider.deletePost(widget.post.id);
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

  // build UI
  @override
  Widget build(BuildContext context) {
    // Does the current user like this post?
    bool likedByCurrentUser =
        listeningProvider.isPostLikedByCurrentUser(widget.post.id);

    // listen to like count
    int likeCount = listeningProvider.getLikeCount(widget.post.id);

    // return container
    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: profile pic / name / username
            GestureDetector(
              onTap: widget.onUserTap,
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
                    widget.post.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  // Username handle
                  Text(
                    '@${widget.post.username}',
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  // More options button
                  GestureDetector(
                    onTap: _showOptions,
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
              widget.post.message,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            const SizedBox(height: 20),
            // Buttons: like + comment
            Row(
              children: [
                // Like button
                GestureDetector(
                  onTap: _toggleLikePost,
                  child: likedByCurrentUser
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                ),

                // like count
                Text(likeCount.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

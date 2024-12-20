import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:mytwitter/components/my_input_alert_box.dart';
import 'package:mytwitter/helper/time_formatter.dart';
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

  // on startup,
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // load comment for this post
    _loadComments();
  }

  // user tapped like or unlike
  void _toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  // comment text controller
  final _commentController = TextEditingController();

  // open comment box -> user want to type new comment
  void _opencommentBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textEditingController: _commentController,
        hinttext: "type a Comment",
        onPressed: () async {
          // add post in db
          await _addComment();
        },
        onPressedText: "Post",
      ),
    );
  }

  // user tapped post to add comment
  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    // attempt to post comment
    try {
      await databaseProvider.addComment(
          widget.post.id, _commentController.text.trim());
    } catch (e) {
      print(e);
    }
  }

  // load comment
  Future<void> _loadComments() async {
    await databaseProvider.loadComments(widget.post.id);
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
                    // pop option box
                    Navigator.pop(context);

                    // handle report actions here
                    _reportPostConfirmationBox();
                  },
                ),
                // Block user option
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text("Block User"),
                  onTap: () {
                    // pop option box
                    Navigator.pop(context);

                    // handle block actions here
                    _blockUserConfirmationBox();
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

  // report post confirmation
  void _reportPostConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Report Message"),
              content:
                  const Text("Are you sure you want to report this message"),
              actions: [
                // canecl
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),

                TextButton(
                  onPressed: () async {
                    await databaseProvider.reportUser(
                        widget.post.id, widget.post.uid);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Message reported")));
                  },
                  child: const Text("Report"),
                )
              ],
            ));
  }

  // block user confirmation
  void _blockUserConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Block User"),
              content: const Text("Are you sure you want to Block this User"),
              actions: [
                // canecl
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),

                TextButton(
                  onPressed: () async {
                    await databaseProvider.blockUser(widget.post.uid);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User Blocked")));
                  },
                  child: const Text("Block"),
                )
              ],
            ));
  }

  // build UI
  @override
  Widget build(BuildContext context) {
    // Does the current user like this post?
    bool likedByCurrentUser =
        listeningProvider.isPostLikedByCurrentUser(widget.post.id);
    print(likedByCurrentUser);

    // listen to like count
    int likeCount = listeningProvider.getLikeCount(widget.post.id);

    // listen to comment count
    int commentCount = listeningProvider.getComments(widget.post.id).length;

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
                SizedBox(
                  width: 60,
                  child: Row(
                    children: [
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

                      const SizedBox(width: 5),

                      // like count
                      Text(likeCount != 0 ? likeCount.toString() : '',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary)),
                    ],
                  ),
                ),

                // Comment Section
                Row(
                  children: [
                    GestureDetector(
                      onTap: _opencommentBox,
                      child: Icon(
                        Icons.comment,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    // Comment count
                    Text(commentCount != 0 ? commentCount.toString() : '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary)),
                  ],
                ),

                const Spacer(),

                // timestamp
                Text(formatTimeStamp(widget.post.timestamp),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

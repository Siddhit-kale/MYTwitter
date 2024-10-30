/*
  post oage

  -individual page
  - comments on this post

*/

import 'package:flutter/material.dart';
import 'package:mytwitter/components/my_comment_title.dart';
import 'package:mytwitter/components/my_post_title.dart';
import 'package:mytwitter/helper/navigate_pages.dart';
import 'package:mytwitter/models/post.dart';
import 'package:mytwitter/services/database/database_provider.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // provider
  late final listenableProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    // listen to all comments for this post
    final allComments = listenableProvider.getComments(widget.post.id);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // app bar
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // body
      body: ListView(
        children: [
          // post
          MyPostTitle(
            post: widget.post,
            onUserTap: () => goUserPage(context, widget.post.uid),
            onPostTap: () {},
          ),

          // comments on this post
          allComments.isEmpty
              ?
              // no comments yet..Widget
              const Center(
                  child: Text("No Comments yet.."),
                )
              :

              // comments exits
              ListView.builder(
                  itemCount: allComments.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // get each comment
                    final comment = allComments[index];

                    // return as comment title ui'
                    return MyCommentTitle(
                      comment: comment, 
                      onUserTap: () => goUserPage(context, comment.uid),
                      );
                  },
                )
        ],
      ),
    );
  }
}

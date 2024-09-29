/*
  post oage

  -individual page
  - comments on this post

*/

import 'package:flutter/material.dart';
import 'package:mytwitter/components/my_post_title.dart';
import 'package:mytwitter/helper/navigate_pages.dart';
import 'package:mytwitter/models/post.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({
    super.key,
    required this.post
    }
  );

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}

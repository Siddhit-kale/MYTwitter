import 'package:flutter/material.dart';
import 'package:mytwitter/models/post.dart';
import 'package:mytwitter/pages/post_page.dart';
import 'package:mytwitter/pages/profile_page.dart';

// go to user page
void goUserPage(BuildContext context, String uid) {
  // navigate to the page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(uid: uid),
    ),
  );
}

// go to post page
void goPostpage(BuildContext context, Post post) {
  // navigate to the post page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostPage(post: post),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:mytwitter/models/post.dart';
import 'package:mytwitter/pages/account_settings_page.dart';
import 'package:mytwitter/pages/blocked_users_page.dart';
import 'package:mytwitter/pages/home_page.dart';
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

// go to blocked user page
void goToBlockedUserPage(BuildContext context) {
  // navigate to page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlockedUsersPage(),
    ),
  );
}

// go to user Account page
void goAccountSettingsPage(BuildContext context) {
  // navigate to page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AccountSettingsPage(),
    ),
  );
}

// go home page (but remove all pervious routes, this is good for reload)
void goHomePage(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),

    // keep the dirst route (auth gate)
    (route) => route.isFirst,
  );
}

/*

  User list tile

*/

import 'package:flutter/material.dart';
import 'package:mytwitter/models/user.dart';
import 'package:mytwitter/pages/profile_page.dart';

class MyUserTile extends StatelessWidget {
  final UserProfile user;

  const MyUserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),

      padding: const EdgeInsets.all(5),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,

        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(user.name),
        titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),

        subtitle: Text('@${user.username}',),
        subtitleTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        leading: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ),

        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: 
          (context) => ProfilePage(uid: user.uid),
          ),
        ),

        trailing: Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.primary,),
      ),
    );
  }
}

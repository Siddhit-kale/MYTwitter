/*

    Profile States

*/

import 'package:flutter/material.dart';

class MyProfileState extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;

  const MyProfileState({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.onTap,
  });

  // Build UI
  @override
  Widget build(BuildContext context) {
    // textstyle for count
    var textStyleforcount = TextStyle(
        fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary);

    // textstylr for text
    var textStyleforText =
        TextStyle(color: Theme.of(context).colorScheme.primary);

    
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // posts
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(postCount.toString(), style: textStyleforcount,),
                Text("Posts", style: textStyleforText,),
              ],
            ),
          ),
      
          // followers
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followerCount.toString(), style: textStyleforcount,),
                Text("Followers", style: textStyleforText,),
              ],
            ),
          ),
      
          // following
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followingCount.toString(), style: textStyleforcount,),
                Text("Following", style: textStyleforText,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

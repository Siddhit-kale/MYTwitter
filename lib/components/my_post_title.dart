/*
  Post title

  - the post widget

  - a function for onPosttap ( go to the individual post to see it's comments)
  - a function for onUserTap ( go to User's Profile page)

*/

import 'package:flutter/material.dart';
import 'package:mytwitter/models/post.dart';

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
  // build Ui
  @override
  Widget build(BuildContext context) {
    
    // return container
    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        // padding outside
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      
        // padding inside
        padding: const EdgeInsets.all(20),
      
        decoration: BoxDecoration(
          // color of post title
          color: Theme.of(context).colorScheme.secondary,
      
          // curve corners
          borderRadius: BorderRadius.circular(8),
        ),
      
        // column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // top section profile pic/ name/ username
            GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  // profile pic
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
      
                  const SizedBox(width: 10),
      
                  // name
                  Text(
                    widget.post.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
      
                  const SizedBox(width: 5),
      
                  // username handle
                  Text(
                    '@${widget.post.username}',
                    style: const TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 20),
            // message
            Text(
              widget.post.message,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ],
        ),
      ),
    );
  }
}

/*
 Database Service
 
 - User profile
 - Post message
 - Likes
 - Comments
 - Account Stuff
 - follow / unfollow
 - search users

 */

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytwitter/models/post.dart';
import 'package:mytwitter/models/user.dart';
import 'package:mytwitter/services/auth/auth_service.dart';

class DatabaseService {
  // get instance of firestore db and auth
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /*
      user profile

  */
  // save user profile
  Future<void> saveUserInfoInFirebase(
      {required String name, required String email}) async {
    // get current uid
    String uid = _auth.currentUser!.uid;

    // extract username from email
    String username = email.split('@')[0];

    // create a user profile
    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );

    // convert user info a mao so that we can store in firebase
    final userMap = user.toMap();

    // save user info in firebase
    await _db.collection("Users").doc(uid).set(userMap);
  }

  // get user info
  Future<UserProfile?> getUserfromFirebase(String uid) async {
    try {
      // retrieve user info from firebase
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();

      // convert doc to user profile
      return UserProfile.fromDocumnet(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // update user bio
  Future<void> updateUserBioinFirebase(String bio) async {
    // get current info
    String uid = AuthService().getCurrentUid();

    // attempts to update in firebase
    try {
      await _db.collection("Users").doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  /*
      Post Message
  */

  // post a message
  Future<void> postMessageInFirebase(String message) async {
    try {
      // get current user id
      String uid = _auth.currentUser!.uid;

      // use this uid to get the user's profile'
      UserProfile? user = await getUserfromFirebase(uid);

      // create a new post
      Post newPost = Post(
        id: '',
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        lineCount: 0,
        likeBy: [],
      );

      // convert post object -> map
      Map<String, dynamic> newPostMap = newPost.toMap();

      // add to firebase
      await _db.collection("Posts").add(newPostMap);
    }

    // catch any errors..
    catch (e) {
      print(e);
    }
  }

  // delete a message

  // Get all posts true firebase

  // get individual post

  /*
      Likes
  */

  /*
      Comments
  */

  /*
      Account stuff
  */

  /*
      Follow
  */

  /*
      Search user
  */
}

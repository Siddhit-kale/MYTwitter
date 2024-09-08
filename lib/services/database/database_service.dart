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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
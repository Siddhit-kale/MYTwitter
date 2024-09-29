/*
  Databse Provider
  - the database service class handles data to and from firebase
  - the database provider class process the data to dispay in our app

  - Also, if one day, we decide to change out backend then it's much easier to manage and swith out database.
*/

import 'package:flutter/material.dart';
import 'package:mytwitter/models/post.dart';
import 'package:mytwitter/models/user.dart';
import 'package:mytwitter/services/database/database_service.dart';

class DatabaseProvider extends ChangeNotifier {
  /*
  Services
  */

  // get db and auth services
  final _db = DatabaseService();

  /*
  User Profile
  */

  // get user profile given uid
  Future<UserProfile?> userProfile(String uid) => _db.getUserfromFirebase(uid);

  // update user bio
  Future<void> updateBio(String bio) => _db.updateUserBioinFirebase(bio);

  /*
    POSTS
  */

  // local list of posts
  List<Post> _allPosts = [];

  // get posts
  List<Post> get allPosts => _allPosts;

  // post message
  Future<void> postMessage(String message) async {
    // post message in firebase
    await _db.postMessageInFirebase(message);

    // reload data from firebase
    await loadAllPosts();
  }

  // fecth all posts
  Future<void> loadAllPosts() async {
    // get all posts from firebase
    final allPosts = await _db.getAllPostsFronFirebase();

    // update local data
    _allPosts = allPosts;

    // update Ui
    notifyListeners();
  }
}

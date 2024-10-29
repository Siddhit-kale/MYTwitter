/*
  Database Provider
  - the database service class handles data to and from firebase
  - the database provider class processes the data to display in our app

  - Also, if one day we decide to change our backend, then it's much easier to manage and switch out the database.
*/

import 'package:flutter/material.dart';
import 'package:mytwitter/models/post.dart';
import 'package:mytwitter/models/user.dart';
import 'package:mytwitter/services/auth/auth_service.dart';
import 'package:mytwitter/services/database/database_service.dart';

class DatabaseProvider extends ChangeNotifier {
  /*
  Services
  */

  // get db and auth services
  final _db = DatabaseService();
  final _auth = AuthService();

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

  // fetch all posts
  Future<void> loadAllPosts() async {
    // Corrected method name
    final allPosts = await _db.getAllPostsFromFirebase();
    _allPosts = allPosts;

    // Initialize local like data
    initializeLikeMap();

    // Update UI
    notifyListeners();
  }

  // filter and return posts
  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  // delete post
  Future<void> deletePost(String postId) async {
    // delete from firebase
    await _db.deletePostFromFirebase(postId);

    // reload the data
    await loadAllPosts();
  }

  /*
      likes
  */

  // local map to track like count for each post
  Map<String, int> _likeCounts = {
    // for each post id: like count
  };

  // local list to track posts liked by current user
  List<String> _likedPosts = [];

  // does current user liked the post?
  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

  // get like count of the post
  int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

  // initialize like map locally
  void initializeLikeMap() {
    // get current user id
    final currentUserID = _auth.getCurrentUser();

    // for each post, get like data
    for (var post in _allPosts) {
      _likeCounts[post.id] = post.likeCount; // Corrected assignment

      if (post.likeBy.contains(currentUserID)) { // Ensure this uses likeBy
        // add this post id to local list of liked posts
        _likedPosts.add(post.id);
      }
    }
  }

  // toggle like
  Future<void> toggleLike(String postID) async {
    /*

      this first part will update the local values first so that the ui feels immediate and responsive.
      we will update the ui optimistically and restart back if anything goes wrong while writing to the database.

    */

    // store original values in case it fails
    final likedPostOriginal = _likedPosts.toList(); // Use toList() to create a copy
    final likedCountOriginal = Map<String, int>.from(_likeCounts); // Create a copy of like counts

    // perform like/unlike
    if (_likedPosts.contains(postID)) {
      _likedPosts.remove(postID);
      _likeCounts[postID] = (_likeCounts[postID] ?? 0) - 1;
    } else {
      _likedPosts.add(postID);
      _likeCounts[postID] = (_likeCounts[postID] ?? 0) + 1;
    }

    // update UI locally
    notifyListeners();

    /*

    update to the database

    */

    // attempt the like in the database
    try {
      await _db.toggleLikeInFirebase(postID);
    }

    // revert back to initial state if update fails
    catch (e) {
      _likedPosts = likedPostOriginal;
      _likeCounts = likedCountOriginal;

      // update UI again
      notifyListeners();
    }
  }
}

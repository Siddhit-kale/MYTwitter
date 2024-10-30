/*
  Database Provider
  - the database service class handles data to and from firebase
  - the database provider class processes the data to display in our app

  - Also, if one day we decide to change our backend, then it's much easier to manage and switch out the database.
*/

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mytwitter/models/comment.dart';
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

    // clear liked posts for when the new user signs in, clear local data
    _likedPosts.clear();

    // for each post, get like data
    for (var post in _allPosts) {
      _likeCounts[post.id] = post.likeCount; // Corrected assignment

      if (post.likeBy.contains(currentUserID)) {
        // Ensure this uses likeBy
        // add this post id to local list of liked posts
        _likedPosts.add(post.id);
      }
    }
  }

  // toggle like
  // toggle like
  Future<bool> toggleLike(String postID) async {
    // Store original values to revert in case of failure
    final likedPostOriginal = _likedPosts.toList();
    final likedCountOriginal = Map<String, int>.from(_likeCounts);

    // Determine and update like/unlike status locally
    bool isLiked;
    if (_likedPosts.contains(postID)) {
      _likedPosts.remove(postID);
      _likeCounts[postID] = (_likeCounts[postID] ?? 0) - 1;
      isLiked = false; // Post is now unliked
    } else {
      _likedPosts.add(postID);
      _likeCounts[postID] = (_likeCounts[postID] ?? 0) + 1;
      isLiked = true; // Post is now liked
    }

    // Update UI locally
    notifyListeners();

    // Attempt to write the like status to the database
    try {
      await _db.toggleLikeInFirebase(postID);
    } catch (e) {
      // Revert back to the initial state if update fails
      _likedPosts
        ..clear()
        ..addAll(likedPostOriginal);
      _likeCounts
        ..clear()
        ..addAll(likedCountOriginal);

      // Update UI again
      notifyListeners();
      print("Error updating like status in database: $e");
      rethrow;
    }

    return isLiked; // Return the updated like status for the UI
  }

  /*

  comment

  */

  // local list to comments
  final Map<String, List<Comment>> _Comments = {};

  // get comments locally
  List<Comment> getComments(String postId) => _Comments[postId] ?? [];

  // fetch comments from database for a post
  Future<void> loadComments(String postId) async {
    final allComments = await _db.getCommentsFromFirebase(postId);

    _Comments[postId] = allComments;

    notifyListeners();
  }

  // add a comment
  Future<void> addComment(String postId, message) async {
    await _db.addCommentInFirebase(postId, message);

    await loadComments(postId);
  }

  // delete a comment
  Future<void> deleteComment(String CommentId, postId) async {

    await _db.deleteCommentInFirebase(CommentId);

    await loadComments(postId);
  }
}

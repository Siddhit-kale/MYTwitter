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

  // Retrieve all posts
  final allPosts = await _db.getAllPostsFromFirebase();

  // Fetch blocked user IDs
  final blockUserIds = await _db.getBlockedUidsFromFirebase();

  // Check for null or empty posts
  _allPosts = allPosts
      .where((post) {
        if (post == null) {
          print('Skipping null or non-existent post');
          return false;
        }
        // Check if post's uid matches any blocked user IDs
        return !blockUserIds.contains(post.uid);
      })
      .toList();

  // Initialize local like data
  initializeLikeMap();
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
      _likeCounts[post.id] = post.likeCount; 

      if (post.likeBy.contains(currentUserID)) {
        // Ensure this uses likeByed posts
        _likedPosts.add(post.id);
      }
    }
  }

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

  /*

  Account Stuff

  */

  // local list of blocked users
  List<UserProfile> _blockedUsers = [];

  // get list of blocked users
  List<UserProfile> get blockedUsers => _blockedUsers;

  // fetch blocked Users
  Future<void> loadBlockedUsers() async {
    final blockedUserIds = await _db.getBlockedUidsFromFirebase();

    final blockedUserData = await Future.wait(
        blockedUserIds.map((id) => _db.getUserfromFirebase(id)));

    _blockedUsers = blockedUserData.whereType<UserProfile>().toList();

    notifyListeners();
  }

  // block user
  Future<void> blockUser(String userId) async {
    await _db.blockUserInFirebase(userId);

    await loadBlockedUsers();

    await loadAllPosts();

    notifyListeners();
  }

  // unblock user
  Future<void> unblockUser(String blockedUserId) async {
    await _db.unblockUserInFirebase(blockedUserId);

    await loadAllPosts();

    await loadBlockedUsers();

    notifyListeners();
  }

  // report user and post
  Future<void> reportUser(String postId, userId) async {
    await _db.reportUserInFirebase(postId, userId);
  }
}

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
import 'package:mytwitter/models/comment.dart';
import 'package:mytwitter/models/post.dart';
import 'package:mytwitter/models/user.dart';
import 'package:mytwitter/services/auth/auth_service.dart';

class DatabaseService {
  // get instance of firestore db and auth
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /*
      User Profile
  */

  // Save user profile
  Future<void> saveUserInfoInFirebase(
      {required String name, required String email}) async {
    String uid = _auth.currentUser!.uid;
    String username = email.split('@')[0];
    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );

    final userMap = user.toMap();
    await _db.collection("Users").doc(uid).set(userMap);
  }

  // Get user info
  Future<UserProfile?> getUserfromFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();
      return UserProfile.fromDocumnet(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Update user bio
  Future<void> updateUserBioinFirebase(String bio) async {
    String uid = AuthService().getCurrentUid();
    try {
      await _db.collection("Users").doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  // Delete user info
  Future<void> deleteUserInfoFromFirebase(String uid) async {
    WriteBatch batch = _db.batch();

    // delete user doc
    DocumentReference userDoc = _db.collection("Users").doc(uid);
    batch.delete(userDoc);

    // delete user posts
    QuerySnapshot userPosts =
        await _db.collection("Posts").where('uid', isEqualTo: uid).get();

    for (var post in userPosts.docs) {
      batch.delete(post.reference);
    }

    // delete users comments
    QuerySnapshot usercomment =
        await _db.collection("Comments").where('uid', isEqualTo: uid).get();

    for (var comment in usercomment.docs) {
      batch.delete(comment.reference);
    }

    // delete likes done by this user
    QuerySnapshot allPosts = await _db.collection("Posts").get();
    for (QueryDocumentSnapshot post in allPosts.docs) {
      Map<String, dynamic> postData = post.data() as Map<String, dynamic>;
      var likedBy = postData['likedBy'] as List<dynamic>? ?? [];

      if (likedBy.contains(uid)) {
        batch.update(post.reference, {
          'likedBy': FieldValue.arrayRemove([uid]),
          'likes': FieldValue.increment(-1),
        });
      }
    }

    // update followers and following

    // commit batch
    await batch.commit();
  }

  /*
      Post Message
  */

  // Post a message
  Future<void> postMessageInFirebase(String message) async {
    try {
      // Get current user id
      String uid = _auth.currentUser!.uid;

      // Use this uid to get the user's profile
      UserProfile? user = await getUserfromFirebase(uid);

      // Create a new post
      Post newPost = Post(
        id: '', // Assign a unique ID if necessary or let Firestore handle it
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        likeCount: 0,
        likeBy: [], // Ensure this matches the field name in your Post model
      );

      // Convert post object to map
      Map<String, dynamic> newPostMap = newPost.toMap();

      // Add to Firebase
      await _db.collection("Posts").add(newPostMap);
    } catch (e) {
      print(e);
    }
  }

  // Get all posts from Firebase
  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Posts")
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Delete a message
  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection("Posts").doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  // Fetch all posts and initialize likes
  Future<List<Post>> fetchPostsAndInitializeLikes() async {
    try {
      QuerySnapshot snapshot = await _db.collection("Posts").get();
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching posts: $e");
      return [];
    }
  }

  /*
      Likes
  */

  // Toggle like for a post
  Future<void> toggleLikeInFirebase(String postId) async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentReference postdoc = _db.collection("Posts").doc(postId);

      await _db.runTransaction((transaction) async {
        DocumentSnapshot postSnapshot = await transaction.get(postdoc);

        if (postSnapshot.exists && postSnapshot.data() != null) {
          Map<String, dynamic> postData =
              postSnapshot.data() as Map<String, dynamic>;

          List<String> likedBy = List<String>.from(postData['likedBy'] ?? []);
          int currentLikeCount = postData['likes'] ?? 0;

          if (!likedBy.contains(uid)) {
            likedBy.add(uid);
            currentLikeCount++;
          } else {
            likedBy.remove(uid);
            currentLikeCount--;
          }

          transaction.update(postdoc, {
            'likes': currentLikeCount,
            'likedBy': likedBy, // Ensure you are using likedBy
          });
        } else {
          throw Exception("Post not found.");
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  /*
      Comments
  */

  // Add a comment to a post
  Future<void> addCommentInFirebase(String postId, message) async {
    try {
      // get current user
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserfromFirebase(uid);

      // create a new comment
      Comment newComment = Comment(
        id: '',
        postId: postId,
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
      );

      // convert comment into map
      Map<String, dynamic> newCommentMap = newComment.toMap();

      // to store in firebase
      await _db.collection("Comments").add(newCommentMap);
    } catch (e) {
      print(e);
    }
  }

  // delete a comment from a post
  Future<void> deleteCommentInFirebase(String commentId) async {
    try {
      await _db.collection("Comments").doc(commentId).delete();
    } catch (e) {
      print(e);
    }
  }

  // fetch comment for a post
  Future<List<Comment>> getCommentsFromFirebase(String postId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Comments")
          .where("postId", isEqualTo: postId)
          .get();

      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  /*
      Account stuff
  */

  // report user
  Future<void> reportUserInFirebase(String postId, String userId) async {
    final currentUserId = _auth.currentUser?.uid;

    // Check if the currentUserId is null
    if (currentUserId == null) {
      print('User not authenticated');
      return;
    }

    // create a report
    final report = {
      'reportedBy': currentUserId,
      'messageId': postId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    // Save report to Firestore under a new "reports" collection
    await FirebaseFirestore.instance.collection('reports').add(report);
  }

// Block user
  Future<void> blockUserInFirebase(String userId) async {
    final currentUserId = _auth.currentUser?.uid;

    try {
      // Store the blocked user's uid directly
      await _db
          .collection("Users")
          .doc(currentUserId)
          .collection("BlockedUsers")
          .doc(userId)
          .set({});
    } catch (e) {
      print(e);
    }
  }

// Unblock user
  Future<void> unblockUserInFirebase(String blockedUserId) async {
    final currentUserId = _auth.currentUser?.uid;

    try {
      await _db
          .collection("Users")
          .doc(currentUserId)
          .collection("BlockedUsers")
          .doc(blockedUserId)
          .delete();
    } catch (e) {
      print(e);
    }
  }

// Get list of blocked user ids
  Future<List<String>> getBlockedUidsFromFirebase() async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return [];

    try {
      final snapshot = await _db
          .collection("Users")
          .doc(currentUserId)
          .collection("BlockedUsers")
          .get();

      final blockedIds = snapshot.docs.map((doc) => doc.id).toList();
      print('Blocked user IDs: $blockedIds'); // Debug blocked IDs

      return blockedIds;
    } catch (e) {
      print('Error fetching blocked user IDs: $e');
      return [];
    }
  }

  /*
      Follow
  */

  /*
      Search user
  */
}

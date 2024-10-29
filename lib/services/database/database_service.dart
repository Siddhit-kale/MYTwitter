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
          Map<String, dynamic> postData = postSnapshot.data() as Map<String, dynamic>;

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

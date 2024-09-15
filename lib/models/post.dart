/*
  post model

*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String uid;
  final String name;
  final String username;
  final String message;
  final Timestamp timestamp;
  int lineCount;
  final List<String> likeBy;

  Post({
    required this.id,
    required this.uid,
    required this.name,
    required this.username,
    required this.message,
    required this.timestamp,
    required this.lineCount,
    required this.likeBy,
  });

  // couvert a firestore document to a post object
  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      id: doc.id,
      uid: doc['uid'],
      name: doc['name'],
      username: doc['username'],
      message: doc['message'],
      timestamp: doc['timestamp'],
      lineCount: doc['likes'],
      likeBy: List<String>.from(doc['likedBy'] ?? []),
    );
  }

  // convert a post to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': timestamp,
      'likes': lineCount,
      'likeBy': likeBy,
    };
  }
}

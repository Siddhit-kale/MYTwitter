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
  final int likeCount;
  final List<String> likeBy;

  Post({
    required this.id,
    required this.uid,
    required this.name,
    required this.username,
    required this.message,
    required this.timestamp,
    required this.likeCount,
    required this.likeBy,
  });

  // couvert a firestore document to a post object
factory Post.fromDocument(DocumentSnapshot doc) {
  // Convert the document to a map of field data
  final data = doc.data() as Map<String, dynamic>;

  return Post(
    id: doc.id,
    uid: data['uid'] ?? '',
    name: data['name'] ?? '',
    username: data['username'] ?? '',
    message: data['message'] ?? '',
    timestamp: data['timestamp'] ?? Timestamp.now(),
    likeCount: data['likes'] ?? 0,
    likeBy: data.containsKey('likedBy') ? List<String>.from(data['likedBy']) : [],
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
      'likes': likeCount,
      'likeBy': likeBy,
    };
  }
}

/*
  Databse Provider
  - the database service class handles data to and from firebase
  - the database provider class process the data to dispay in our app

  - Also, if one day, we decide to change out backend then it's much easier to manage and swith out database.
*/

import 'package:flutter/material.dart';
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
}

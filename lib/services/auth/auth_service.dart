import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytwitter/services/database/database_service.dart';

/*
  Authatication Service

  - Login
  - Register
  - Logout
  - Delete accout
 */

class AuthService {
  final _auth = FirebaseAuth.instance;

  // get current user and uid
  User? getCurrentUser() => _auth.currentUser;
  String getCurrentUid() => _auth.currentUser!.uid;

  // Login => email & pw
  Future<UserCredential> loginEmailPassword(String email, password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // register => email & pw
  Future<UserCredential> registerEmailPassword(String email, password) async {
    // attempt to register new user
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // delete account
  Future<void> deleteAccount() async {
    // get current uid
    User? user = getCurrentUser();

    if (user != null) {
      // delete user's data from fileStore
      await DatabaseService().deleteUserInfoFromFirebase(user.uid);

      // delete user's auth record
      await user.delete();
    }
  }
}

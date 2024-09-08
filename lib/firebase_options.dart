// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1zv5jZws0lK6stNQGeuWIlJFX_MC1saw',
    appId: '1:405054585203:android:7500868e3a1a849fd42d06',
    messagingSenderId: '405054585203',
    projectId: 'mytwitter-605c1',
    storageBucket: 'mytwitter-605c1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3NCNTQfDNMRF1Ta99a0Ug3W51KPkiDTw',
    appId: '1:405054585203:ios:a08ad77cfb66dc50d42d06',
    messagingSenderId: '405054585203',
    projectId: 'mytwitter-605c1',
    storageBucket: 'mytwitter-605c1.appspot.com',
    iosBundleId: 'com.MYTwitter.siddhit.mytwitter',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCZP0VTMXIUvKeic2XSJ3lbT97Y9Q0MC74',
    appId: '1:405054585203:web:0d5a062f2b79d1c2d42d06',
    messagingSenderId: '405054585203',
    projectId: 'mytwitter-605c1',
    authDomain: 'mytwitter-605c1.firebaseapp.com',
    storageBucket: 'mytwitter-605c1.appspot.com',
    measurementId: 'G-N9LHDJ12MV',
  );

}
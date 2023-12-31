// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCnv5nXevgmYCKFbtt-OG6lBzwJeRPLm70',
    appId: '1:782519850257:web:221a6d664c73393bd168b0',
    messagingSenderId: '782519850257',
    projectId: 'flutter-crud-4a348',
    authDomain: 'flutter-crud-4a348.firebaseapp.com',
    storageBucket: 'flutter-crud-4a348.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtA-H1FhQP1wKhymuqyH2IaCSGw3L0KUE',
    appId: '1:782519850257:android:2aadb114e619559ad168b0',
    messagingSenderId: '782519850257',
    projectId: 'flutter-crud-4a348',
    storageBucket: 'flutter-crud-4a348.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDjtUPTVZwhV0P93JaHzWijno6kkxpsxi8',
    appId: '1:782519850257:ios:1b6b86ccbf2c3a55d168b0',
    messagingSenderId: '782519850257',
    projectId: 'flutter-crud-4a348',
    storageBucket: 'flutter-crud-4a348.appspot.com',
    iosClientId: '782519850257-cr0nk55dnjpqorlbiijg1p0ml38n64a5.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterCrud',
  );
}

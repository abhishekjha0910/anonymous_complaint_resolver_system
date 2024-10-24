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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAonmcjRzxeoWUEmIzmJtl6ryqS122jiKQ',
    appId: '1:557927807979:web:1a1747cba6ddaeeb1377ae',
    messagingSenderId: '557927807979',
    projectId: 'annonymous-complaint--system',
    authDomain: 'annonymous-complaint--system.firebaseapp.com',
    storageBucket: 'annonymous-complaint--system.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTDX1DI-z63bTzM0cWNbtBpoQ3hpkNrtQ',
    appId: '1:557927807979:android:d414624f447d4e851377ae',
    messagingSenderId: '557927807979',
    projectId: 'annonymous-complaint--system',
    storageBucket: 'annonymous-complaint--system.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbxSPmQQeGqSILeXpwjy8HDoB0eT06QBs',
    appId: '1:557927807979:ios:13480b8fa08d430b1377ae',
    messagingSenderId: '557927807979',
    projectId: 'annonymous-complaint--system',
    storageBucket: 'annonymous-complaint--system.appspot.com',
    iosBundleId: 'com.example.anonymousComplaintResolverSystem',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbxSPmQQeGqSILeXpwjy8HDoB0eT06QBs',
    appId: '1:557927807979:ios:13480b8fa08d430b1377ae',
    messagingSenderId: '557927807979',
    projectId: 'annonymous-complaint--system',
    storageBucket: 'annonymous-complaint--system.appspot.com',
    iosBundleId: 'com.example.anonymousComplaintResolverSystem',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAonmcjRzxeoWUEmIzmJtl6ryqS122jiKQ',
    appId: '1:557927807979:web:aa6cb88ca99918dc1377ae',
    messagingSenderId: '557927807979',
    projectId: 'annonymous-complaint--system',
    authDomain: 'annonymous-complaint--system.firebaseapp.com',
    storageBucket: 'annonymous-complaint--system.appspot.com',
  );
}

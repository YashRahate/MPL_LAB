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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD96XZFMwkmnGl83g-aJ5zyuZXpmbHSku8',
    appId: '1:513404948876:web:575ee6167cb2f8b846c6a9',
    messagingSenderId: '513404948876',
    projectId: 'seniorcitizenassistant',
    authDomain: 'seniorcitizenassistant.firebaseapp.com',
    storageBucket: 'seniorcitizenassistant.firebasestorage.app',
    measurementId: 'G-852F2G8Z99',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_UGUGTVJCrccurRvXrWJBWFST_Mbiz80',
    appId: '1:513404948876:android:9b5864965d3cbb6d46c6a9',
    messagingSenderId: '513404948876',
    projectId: 'seniorcitizenassistant',
    storageBucket: 'seniorcitizenassistant.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_2xnhKVJQsxHEfk111CpL6CnC_mlsEsw',
    appId: '1:513404948876:ios:1d0539b21de5e85f46c6a9',
    messagingSenderId: '513404948876',
    projectId: 'seniorcitizenassistant',
    storageBucket: 'seniorcitizenassistant.firebasestorage.app',
    iosBundleId: 'com.example.sca',
  );
}

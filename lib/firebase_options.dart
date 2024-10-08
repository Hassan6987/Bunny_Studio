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
    apiKey: 'AIzaSyD_AMX64bUz5-tMz-w4kwVIKSn08Mn9Kzw',
    appId: '1:871223590607:web:545cb8e83226f9c20341ba',
    messagingSenderId: '871223590607',
    projectId: 'spotify-0101',
    authDomain: 'spotify-0101.firebaseapp.com',
    storageBucket: 'spotify-0101.appspot.com',
    measurementId: 'G-C8DPHE4746',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgk-Ajwg1ZkE9DwIKIby9cEPfAY7HKzqM',
    appId: '1:871223590607:android:fa4a09addbc17c290341ba',
    messagingSenderId: '871223590607',
    projectId: 'spotify-0101',
    storageBucket: 'spotify-0101.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDY9vYHEN0S8nPcaybVLGixzlD5CkJwN7E',
    appId: '1:871223590607:ios:9350bfd9ea7999cc0341ba',
    messagingSenderId: '871223590607',
    projectId: 'spotify-0101',
    storageBucket: 'spotify-0101.appspot.com',
    iosBundleId: 'com.example.spotify',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDY9vYHEN0S8nPcaybVLGixzlD5CkJwN7E',
    appId: '1:871223590607:ios:9350bfd9ea7999cc0341ba',
    messagingSenderId: '871223590607',
    projectId: 'spotify-0101',
    storageBucket: 'spotify-0101.appspot.com',
    iosBundleId: 'com.example.spotify',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD_AMX64bUz5-tMz-w4kwVIKSn08Mn9Kzw',
    appId: '1:871223590607:web:b4dd1d6d0c3eedc50341ba',
    messagingSenderId: '871223590607',
    projectId: 'spotify-0101',
    authDomain: 'spotify-0101.firebaseapp.com',
    storageBucket: 'spotify-0101.appspot.com',
    measurementId: 'G-EP9WKQG829',
  );
}

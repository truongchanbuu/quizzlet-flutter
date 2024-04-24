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
        return macos;
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
    apiKey: 'AIzaSyAkAsT2KpbPvZDEWZy0GRP9WXOD08WgOjI',
    appId: '1:636054365584:web:6de08b09eb05649b97ff15',
    messagingSenderId: '636054365584',
    projectId: 'quizzlet-flutter-458c5',
    authDomain: 'quizzlet-flutter-458c5.firebaseapp.com',
    storageBucket: 'quizzlet-flutter-458c5.appspot.com',
    measurementId: 'G-29P5Q3801C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrmVltZCeT1mo5TuGUrcg2-asZ7eceAXI',
    appId: '1:636054365584:android:71191743eea58e0c97ff15',
    messagingSenderId: '636054365584',
    projectId: 'quizzlet-flutter-458c5',
    storageBucket: 'quizzlet-flutter-458c5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4Mex__pSebhfO13BJpol5CyZQaJ3ybZU',
    appId: '1:636054365584:ios:9beba5950de2e13e97ff15',
    messagingSenderId: '636054365584',
    projectId: 'quizzlet-flutter-458c5',
    storageBucket: 'quizzlet-flutter-458c5.appspot.com',
    androidClientId: '636054365584-6tslttgmhekar89419mjeu404lp9t92k.apps.googleusercontent.com',
    iosClientId: '636054365584-cmen51oh9pg9rmicish2tiqsfrg8715j.apps.googleusercontent.com',
    iosBundleId: 'com.example.quizzletFluttter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD4Mex__pSebhfO13BJpol5CyZQaJ3ybZU',
    appId: '1:636054365584:ios:2ae242ae302cc8dd97ff15',
    messagingSenderId: '636054365584',
    projectId: 'quizzlet-flutter-458c5',
    storageBucket: 'quizzlet-flutter-458c5.appspot.com',
    androidClientId: '636054365584-6tslttgmhekar89419mjeu404lp9t92k.apps.googleusercontent.com',
    iosClientId: '636054365584-mrbephsb4eoip5k405us0tk1lkbr1b82.apps.googleusercontent.com',
    iosBundleId: 'com.example.quizzletFluttter.RunnerTests',
  );
}

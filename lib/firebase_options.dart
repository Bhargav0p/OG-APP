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
    apiKey: 'AIzaSyDkfjSK5te6NwVyM7JksZGGiFlhuCd0Rjo',
    appId: '1:1060603960568:web:a525a610ca6781db102f0d',
    messagingSenderId: '1060603960568',
    projectId: 'apogee-2023',
    authDomain: 'apogee-2023.firebaseapp.com',
    storageBucket: 'apogee-2023.appspot.com',
    measurementId: 'G-BV5X6GER0S',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACcnUBkwA9EAiokzSmhfchej0I4MM57c0',
    appId: '1:1060603960568:android:9ccc021382a230df102f0d',
    messagingSenderId: '1060603960568',
    projectId: 'apogee-2023',
    storageBucket: 'apogee-2023.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCdlsnROCZpBgFdNJ3UAFwlJDnOgIHX8W0',
    appId: '1:1060603960568:ios:701afd60e409fb88102f0d',
    messagingSenderId: '1060603960568',
    projectId: 'apogee-2023',
    storageBucket: 'apogee-2023.appspot.com',
    iosClientId:
        '1060603960568-k87pu4isjliojmm03v74lqp9sqmkmjup.apps.googleusercontent.com',
    iosBundleId: 'com.dvm.apogee2022',
  );
}

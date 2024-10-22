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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
    apiKey: 'AIzaSyAYGifYHG7-wIKR2PoDAfVPhaKNllmunTk',
    appId: '1:399414095535:android:1c143e03eeffa2667c2e5a',
    messagingSenderId: '399414095535',
    projectId: 'chatflutter-4ff25',
    databaseURL: 'https://chatflutter-4ff25.firebaseio.com',
    storageBucket: 'chatflutter-4ff25.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB099o31KVLzl3V1G3W_H--YJ4yf19ZrZE',
    appId: '1:399414095535:ios:6204aa51e71f4dd37c2e5a',
    messagingSenderId: '399414095535',
    projectId: 'chatflutter-4ff25',
    databaseURL: 'https://chatflutter-4ff25.firebaseio.com',
    storageBucket: 'chatflutter-4ff25.appspot.com',
    androidClientId: '399414095535-arho5k70h5hqofu6ius44khc8q94ahuv.apps.googleusercontent.com',
    iosClientId: '399414095535-hma9llvooddp0cmkjbivi2sujqq5frgo.apps.googleusercontent.com',
    iosBundleId: 'felipecastrosales.chat',
  );
}

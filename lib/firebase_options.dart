import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCGa69RV3KtftCJLjFwbSi1abxMEw3At_M',
    appId: '1:105784175004:web:446e6e4febefcd12c14059',
    messagingSenderId: '105784175004',
    projectId: 'coupon-rswm',
    authDomain: 'coupon-rswm.firebaseapp.com',
    storageBucket: 'coupon-rswm.appspot.com',
    measurementId: 'G-H353R6NPG1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAknviX1Ip5gZMba5gTjUSBW8Yv1UCAPl0',
    appId: '1:105784175004:android:04e98f65df9ddb4bc14059',
    messagingSenderId: '105784175004',
    projectId: 'coupon-rswm',
    storageBucket: 'coupon-rswm.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBo0r8U439mToYNuB3FBIha17ipuD0-MbM',
    appId: '1:105784175004:ios:79c85b67242d9c58c14059',
    messagingSenderId: '105784175004',
    projectId: 'coupon-rswm',
    storageBucket: 'coupon-rswm.appspot.com',
    iosBundleId: 'in.rswm.coupon',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBo0r8U439mToYNuB3FBIha17ipuD0-MbM',
    appId: '1:105784175004:ios:79c85b67242d9c58c14059',
    messagingSenderId: '105784175004',
    projectId: 'coupon-rswm',
    storageBucket: 'coupon-rswm.appspot.com',
    iosBundleId: 'in.rswm.coupon',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCGa69RV3KtftCJLjFwbSi1abxMEw3At_M',
    appId: '1:105784175004:web:4d21f31b816dfe4ac14059',
    messagingSenderId: '105784175004',
    projectId: 'coupon-rswm',
    authDomain: 'coupon-rswm.firebaseapp.com',
    storageBucket: 'coupon-rswm.appspot.com',
    measurementId: 'G-TRDJLSNVW4',
  );

}
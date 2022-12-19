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
    apiKey: 'AIzaSyDXXWZG9cEZmkDA_d2YqenSArcPDSF-pNg',
    appId: '1:959943491661:web:176a6883d30b922cb55c04',
    messagingSenderId: '959943491661',
    projectId: 'smarthome-6f50e',
    authDomain: 'smarthome-6f50e.firebaseapp.com',
    databaseURL: 'https://smarthome-6f50e-default-rtdb.firebaseio.com',
    storageBucket: 'smarthome-6f50e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtQ0uTWLkNVuK7e_ZGQ9UHxebQnD1WZLs',
    appId: '1:959943491661:android:861ac1564c98a071b55c04',
    messagingSenderId: '959943491661',
    projectId: 'smarthome-6f50e',
    databaseURL: 'https://smarthome-6f50e-default-rtdb.firebaseio.com',
    storageBucket: 'smarthome-6f50e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD2uUU0jhg2KTSHZC3BmPicLO4MVdq0hQc',
    appId: '1:959943491661:ios:d240d93aa4a54db2b55c04',
    messagingSenderId: '959943491661',
    projectId: 'smarthome-6f50e',
    databaseURL: 'https://smarthome-6f50e-default-rtdb.firebaseio.com',
    storageBucket: 'smarthome-6f50e.appspot.com',
    iosClientId: '959943491661-vjvst7t73d0sqd3aaqk01gopj0p4utd0.apps.googleusercontent.com',
    iosBundleId: 'com.example.mySmartHome',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD2uUU0jhg2KTSHZC3BmPicLO4MVdq0hQc',
    appId: '1:959943491661:ios:d240d93aa4a54db2b55c04',
    messagingSenderId: '959943491661',
    projectId: 'smarthome-6f50e',
    databaseURL: 'https://smarthome-6f50e-default-rtdb.firebaseio.com',
    storageBucket: 'smarthome-6f50e.appspot.com',
    iosClientId: '959943491661-vjvst7t73d0sqd3aaqk01gopj0p4utd0.apps.googleusercontent.com',
    iosBundleId: 'com.example.mySmartHome',
  );
}

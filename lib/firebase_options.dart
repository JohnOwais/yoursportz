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
    apiKey: 'AIzaSyDkbbKthTdzkZyWtMDHwP35X0OJ51ddz9k',
    appId: '1:621634067913:web:6066de0429447a99cd9c18',
    messagingSenderId: '621634067913',
    projectId: 'yoursportzapp',
    authDomain: 'yoursportzapp.firebaseapp.com',
    storageBucket: 'yoursportzapp.appspot.com',
    measurementId: 'G-4RYTZ0RRSB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCPjROznDovFzXCZpOu1WGdJ7pDUfqKj6A',
    appId: '1:621634067913:android:7f0d1eec341cc66bcd9c18',
    messagingSenderId: '621634067913',
    projectId: 'yoursportzapp',
    storageBucket: 'yoursportzapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCBQwLnnXjFAHQkcmYdwBVSSMmR0lwk_h8',
    appId: '1:621634067913:ios:25ebf4b84895a10fcd9c18',
    messagingSenderId: '621634067913',
    projectId: 'yoursportzapp',
    storageBucket: 'yoursportzapp.appspot.com',
    androidClientId:
        '621634067913-2vccpm0sch4cenr5drcnn0f2dr53tc39.apps.googleusercontent.com',
    iosClientId:
        '621634067913-sk1bh65nm15kh92ehh1o48vlo2pf28vm.apps.googleusercontent.com',
    iosBundleId: 'com.example.yoursportz',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCBQwLnnXjFAHQkcmYdwBVSSMmR0lwk_h8',
    appId: '1:621634067913:ios:25ebf4b84895a10fcd9c18',
    messagingSenderId: '621634067913',
    projectId: 'yoursportzapp',
    storageBucket: 'yoursportzapp.appspot.com',
    androidClientId:
        '621634067913-2vccpm0sch4cenr5drcnn0f2dr53tc39.apps.googleusercontent.com',
    iosClientId:
        '621634067913-sk1bh65nm15kh92ehh1o48vlo2pf28vm.apps.googleusercontent.com',
    iosBundleId: 'com.example.yoursportz',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDkbbKthTdzkZyWtMDHwP35X0OJ51ddz9k',
    appId: '1:621634067913:web:4f176e0767ee63bccd9c18',
    messagingSenderId: '621634067913',
    projectId: 'yoursportzapp',
    authDomain: 'yoursportzapp.firebaseapp.com',
    storageBucket: 'yoursportzapp.appspot.com',
    measurementId: 'G-6W5T9LBPDQ',
  );
}

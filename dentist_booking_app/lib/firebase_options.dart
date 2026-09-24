// File generated manually from android/app/google-services.json (Android-only for now).
// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Firebase is not configured for web.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'Firebase iOS is not configured yet. Push is Android-only.',
        );
      default:
        throw UnsupportedError(
          'Firebase is not supported on this platform yet.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgtfL58dZrG5Mb9QaR8YxR5xBgAcks9IQ',
    appId: '1:1025947806531:android:82efc9ac31d07d9acf9df6',
    messagingSenderId: '1025947806531',
    projectId: 'dentist-booking-admin',
    storageBucket: 'dentist-booking-admin.firebasestorage.app',
  );
}

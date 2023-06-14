import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get preference => SharedPreferences.getInstance();

  @preResolve
  @lazySingleton
  Future<FirebaseApp> get firebaseApp async {
    if (!kIsWeb) {
      return Firebase.initializeApp();
    } else {
      final firebaseConfig = FirebaseOptions(
          apiKey: "AIzaSyDFW3QHHMRloneDG6WhXTcwFPfaPljl2HE",
          authDomain: "flutter-webrtc-f9952.firebaseapp.com",
          databaseURL:
              "https://flutter-webrtc-f9952-default-rtdb.europe-west1.firebasedatabase.app",
          projectId: "flutter-webrtc-f9952",
          storageBucket: "flutter-webrtc-f9952.appspot.com",
          messagingSenderId: "783571257509",
          appId: "1:783571257509:web:b095b40a5c845f3a35654c");

      return Firebase.initializeApp(options: firebaseConfig);
    }
  }

  @singleton
  FirebaseDatabase get firebaseDatabase => FirebaseDatabase.instance;
}

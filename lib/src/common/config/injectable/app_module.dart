import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get preference => SharedPreferences.getInstance();

  @preResolve
  @lazySingleton
  Future<FirebaseApp> get firebaseApp => Firebase.initializeApp();

  @singleton
  FirebaseDatabase get firebaseDatabase => FirebaseDatabase.instance;
}

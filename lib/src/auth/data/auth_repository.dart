import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webrtc_example/src/auth/data/models/user.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRepository {
  final FirebaseDatabase _database;

  AuthRepository(this._database);

  StreamSubscription<DatabaseEvent>? userChangeSubscription;

  Future<void> register({
    required String accountID,
    required String name,
    required bool isOnline,
  }) async {
    final ref = _database.ref();
    await ref.child(accountID).set(
      {
        'account_id': accountID,
        'name': name,
        'is_online': isOnline,
      },
    );
  }

  Future<User?> isRegistered(String accountID) async {
    final ref = _database.ref();
    final res = await ref.child(accountID).get();

    return res.exists ? User.fromFirebase(res) : null;
  }

  Future<void> changeName(String id, String name) async {
    final ref = _database.ref(id + '/name');
    await ref.set(name);
  }

  Future<void> changeIsOnline(String id, bool isOnline) async {
    final ref = _database.ref(id + '/is_online');
    await ref.set(isOnline);
  }

  Future<void> subscribeToUserChanges(
    String id,
    void Function(DatabaseEvent) onData,
  ) async {
    final ref = _database.ref(id);
    final userChangeSubscription = await ref.onChildChanged.listen(onData);
  }

  Future<void> unsubscribeToUserChanges() async {
    await userChangeSubscription?.cancel();
  }
}

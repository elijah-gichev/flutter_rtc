import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRepository {
  final FirebaseDatabase _database;

  AuthRepository(this._database);

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

  Future<bool> isRegistered(String accountID) async {
    final ref = _database.ref();
    final res = await ref.child(accountID).get();

    return res.exists;
  }
}

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthRepository {
  final FirebaseDatabase _database;

  AuthRepository(this._database);

  Future<void> register(String accountID) async {
    final ref = _database.ref();
    await ref.child(accountID).set(
      {
        'account_id': accountID,
      },
    );
  }

  Future<bool> isRegistered(String accountID) async {
    final ref = _database.ref();
    final res = await ref.child(accountID).get();

    return res.exists;
  }
}

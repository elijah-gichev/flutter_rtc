import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webrtc_example/src/auth/data/models/user.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FbRealtimeRepository {
  final FirebaseDatabase _database;

  final List<StreamSubscription<DatabaseEvent>> subscriptions = [];
  final List<DatabaseReference> refs = [];

  FbRealtimeRepository(
    this._database,
  );

  void addOnChildAddedSubscription(
    String id,
    void Function(DatabaseEvent) onData,
  ) {
    final refUrl = '$id/peering';

    final ref = _database.ref(refUrl);
    final refSubscription = ref.onChildAdded.listen(onData);

    subscriptions.add(refSubscription);
    refs.add(ref);
  }

  void removeOnChildAddedSubscription() {
    if (subscriptions.isNotEmpty) {
      subscriptions.forEach((sub) {
        sub.cancel();
      });
    }
  }

  Future<void> sendMessage(String senderId, String recipientId, data) async {
    final recipientRef = _database.ref(recipientId);
    await recipientRef.child('peering').push().set(
      {
        'sender': senderId,
        'message': data,
      },
    );
  }

  Future<List<User>> getAllUsers() async {
    final rootRef = _database.ref();
    final res = await rootRef.get();
    return res.children.map((snapshot) {
      return User.fromFirebase(snapshot);
    }).toList();
  }

  Future<User> getUserById(String id) async {
    final ref = _database.ref(id);
    final res = await ref.get();
    return User.fromFirebase(res);
  }

  Future<void> clearAll() async {
    for (final ref in refs) {
      await ref.remove();
    }
  }
}

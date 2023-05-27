import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_webrtc_example/src/common/services/id_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FbRealtimeRepository {
  final FirebaseDatabase _database;
  final IdService _idService;

  final List<StreamSubscription<DatabaseEvent>> subscriptions = [];

  //StreamSubscription<DatabaseEvent>? onChildAddedSubscription;

  late final DatabaseReference ref;

  FbRealtimeRepository(
    this._database,
    this._idService,
  ) {
    ref = _database.ref(_idService.id);
  }

  void addOnChildAddedSubscription(
    String id,
    void Function(DatabaseEvent) onData,
  ) {
    final refSubscription = _database.ref('$id/peering');
    final subs = refSubscription.onChildAdded.listen(onData);
    subscriptions.add(subs);
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
    // await recipientRef.child('peering').set(
    //   {
    //     'sender': senderId,
    //     'message': data,
    //   },
    // );
    //await ref.remove();
  }

  Future<List<String>> getAllUsers() async {
    final rootRef = _database.ref();
    final res = await rootRef.get();
    return res.children
        .map((snapshot) =>
            (snapshot.value as Map<Object?, Object?>)['account_id'].toString())
        .toList();
  }

  Future<void> clearAll() async {
    await ref.remove();
  }
}

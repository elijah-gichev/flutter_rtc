import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class FbRealtimeRepository {
  final FirebaseDatabase _database;

  StreamSubscription<DatabaseEvent>? onChildAddedSubscription;

  FbRealtimeRepository(this._database);

  void addOnChildAddedSubscription(void Function(DatabaseEvent) onData) {
    final ref = _database.ref();
    onChildAddedSubscription = ref.onChildAdded.listen(onData);
  }

  void removeOnChildAddedSubscription() {
    if (onChildAddedSubscription != null) {
      onChildAddedSubscription!.cancel();
    }
  }

  Future<void> sendMessage(senderId, data) async {
    final ref = _database.ref().push();
    await ref.set(
      {
        'sender': senderId,
        'message': data,
      },
    );

    //await ref.remove();
  }

  Future<void> clearAll() async {
    final ref = _database.ref();

    await ref.remove();
  }
}

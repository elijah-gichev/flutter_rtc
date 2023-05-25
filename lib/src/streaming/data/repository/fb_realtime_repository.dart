import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
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

  Future<void> sendMessage(String senderId, data) async {
    final ref = _database.ref().push();
    await ref.set(
      {
        'sender': senderId,
        'message': data,
      },
    );
    //await ref.remove();
  }

  Future<List<String>> getAllUsers() async {
    final ref = _database.ref();

    final res = await ref.get();
    return res.children.map((snapshot) => snapshot.value.toString()).toList();
  }

  Future<void> clearAll() async {
    final ref = _database.ref();
    await ref.remove();
  }
}

import 'dart:math';

class IdService {
  late final int myId;

  IdService() {
    myId = Random().nextInt(1000000000);
  }
}

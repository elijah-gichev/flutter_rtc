import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class IdService {
  final Uuid uuid;
  final SharedPreferences pref;

  late final String id;

  static const _prefIdKey = 'pref_id';

  IdService(this.uuid, this.pref) {
    final savedId = pref.getString(_prefIdKey);

    if (savedId == null) {
      id = uuid.v1();
      pref.setString(_prefIdKey, id);
    } else {
      id = savedId;
    }
  }
}

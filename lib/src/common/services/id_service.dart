import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class IdService {
  final SharedPreferences pref;

  late final String id;

  static const _prefIdKey = 'pref_id';

  IdService(this.pref) {
    final savedId = pref.getString(_prefIdKey);

    if (savedId == null) {
      id = Uuid().v1();
      pref.setString(_prefIdKey, id);
    } else {
      id = savedId;
    }
  }
}

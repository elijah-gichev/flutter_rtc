import 'package:flutter_webrtc_example/src/history/data/models/history.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class HistoryLocalRepository {
  final SharedPreferences pref;

  static const _prefHistoryKey = 'pref_history';

  static const _elementDelimiter = '|';

  const HistoryLocalRepository(this.pref);

  Future<void> setHistory(List<History> history) async {
    final value = history.map((e) => e.toString()).join(_elementDelimiter);
    await pref.setString(_prefHistoryKey, value);
  }

  List<History> getHistory() {
    final value = pref.getString(_prefHistoryKey);

    final history = value
            ?.split(_elementDelimiter)
            .map((rawHistory) => History.fromString(rawHistory))
            .toList() ??
        [];

    return history;
  }

  Future<void> addHistory(History history) async {
    final historyList = List<History>.from(getHistory());
    historyList.add(history);
    await setHistory(historyList);
  }
}

import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc_example/src/history/data/models/history.dart';
import 'package:flutter_webrtc_example/src/history/data/repository/history_local_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'history_state.dart';

@injectable
class HistoryCubit extends Cubit<HistoryState> {
  final HistoryLocalRepository _historyRepository;
  HistoryCubit(this._historyRepository) : super(HistoryInitial());

  Future<void> loadHistory() async {
    try {
      emit(HistoryLoadingInProgress());

      final history = await _historyRepository.getHistory();

      emit(HistoryLoadingComplete(history));
    } catch (e) {
      emit(HistoryLoadingFailure());
    }
  }

  Future<void> addHistory(History history) async {
    try {
      emit(HistoryLoadingInProgress());

      await _historyRepository.addHistory(history);

      final historyList = await _historyRepository.getHistory();

      emit(HistoryLoadingComplete(historyList));
    } catch (e) {
      emit(HistoryLoadingFailure());
    }
  }
}

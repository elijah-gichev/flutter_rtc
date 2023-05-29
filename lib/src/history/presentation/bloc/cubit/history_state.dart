part of 'history_cubit.dart';

@immutable
abstract class HistoryState {
  const HistoryState();
}

class HistoryInitial extends HistoryState {}

class HistoryLoadingInProgress extends HistoryState {}

class HistoryLoadingComplete extends HistoryState {
  final List<History> history;

  const HistoryLoadingComplete(this.history);
}

class HistoryLoadingFailure extends HistoryState {}

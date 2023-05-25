part of 'users_cubit.dart';

@immutable
abstract class UsersState {}

class UsersInProgress extends UsersState {}

class UsersCompleted extends UsersState {
  final List<String> ids;

  UsersCompleted(this.ids);
}

class UsersFailure extends UsersState {}

part of 'users_cubit.dart';

@immutable
abstract class UsersState {}

class UsersInProgress extends UsersState {}

class UsersCompleted extends UsersState {
  final List<User> users;

  UsersCompleted(this.users);
}

class UsersFailure extends UsersState {}

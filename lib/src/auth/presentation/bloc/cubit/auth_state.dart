part of 'auth_cubit.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthInProgress extends AuthState {}

class AuthCompleted extends AuthState {
  final User user;
  const AuthCompleted(this.user);
}

class AuthFailure extends AuthState {}

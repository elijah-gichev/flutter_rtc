part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInProgress extends AuthState {}

class AuthCompleted extends AuthState {}

class AuthFailure extends AuthState {}

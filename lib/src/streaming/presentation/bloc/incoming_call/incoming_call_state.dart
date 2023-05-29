part of 'incoming_call_cubit.dart';

@immutable
abstract class IncomingCallState {
  const IncomingCallState();
}

class IncomingCallInitial extends IncomingCallState {
  const IncomingCallInitial();
}

class IncomingCallAdmission extends IncomingCallState {
  final User callerUser;

  const IncomingCallAdmission(this.callerUser);
}

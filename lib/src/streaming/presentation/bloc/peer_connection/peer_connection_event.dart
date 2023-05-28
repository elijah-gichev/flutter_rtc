part of 'peer_connection_bloc.dart';

@immutable
abstract class PeerConnectionEvent {}

class PeerConnectionInitiated extends PeerConnectionEvent {
  final String recipientId;

  PeerConnectionInitiated(this.recipientId);
}

class PeerConnectionCallStarted extends PeerConnectionEvent {}

class PeerConnectionCallCanceled extends PeerConnectionEvent {}

class PeerConnectionReady extends PeerConnectionEvent {}

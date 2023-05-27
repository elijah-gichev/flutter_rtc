part of 'peer_connection_bloc.dart';

@immutable
abstract class PeerConnectionEvent {}

class PeerConnectionInit extends PeerConnectionEvent {
  final String recipientId;

  PeerConnectionInit(this.recipientId);
}

class PeerConnectionLaunchCall extends PeerConnectionEvent {}

class PeerConnectionEventFake extends PeerConnectionEvent {}

part of 'peer_connection_bloc.dart';

@immutable
abstract class PeerConnectionEvent {}

class PeerConnectionInit extends PeerConnectionEvent {}

class PeerConnectionLaunchCall extends PeerConnectionEvent {}

class PeerConnectionEventFake extends PeerConnectionEvent {}

part of 'peer_connection_bloc.dart';

@immutable
abstract class PeerConnectionState {}

class PeerConnectionInitLoading extends PeerConnectionState {}

class PeerConnectionInitLoadingDone extends PeerConnectionState {}

class PeerConnectionCallLoading extends PeerConnectionState {}

class PeerConnectionCallLoadingDone extends PeerConnectionState {}

class PeerConnectionCancelCall extends PeerConnectionState {}

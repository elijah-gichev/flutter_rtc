part of 'peer_connection_bloc.dart';

@immutable
abstract class PeerConnectionState {}

class PeerConnectionInitial extends PeerConnectionState {}

class PeerConnectionInitLoading extends PeerConnectionState {}

class PeerConnectionInitLoadingDone extends PeerConnectionState {}

class PeerConnectionCallLoading extends PeerConnectionState {}

class PeerConnectionCallLoadingDone extends PeerConnectionState {}

class PeerConnectionFake extends PeerConnectionState {}

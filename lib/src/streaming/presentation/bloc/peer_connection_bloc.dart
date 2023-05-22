import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_example/src/common/services/id_service.dart';
import 'package:flutter_webrtc_example/src/streaming/data/repository/fb_realtime_repository.dart';
import 'package:flutter_webrtc_example/src/streaming/data/repository/webrtc_repository.dart';
import 'package:meta/meta.dart';

part 'peer_connection_event.dart';
part 'peer_connection_state.dart';

class PeerConnectionBloc
    extends Bloc<PeerConnectionEvent, PeerConnectionState> {
  final FbRealtimeRepository _firebaseRealtimeDB;
  final WebRTCRepository _faceToFaceStreamingService;
  final IdService _idService;

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;

  late final MediaStream _localStream;

  PeerConnectionBloc(
    this._firebaseRealtimeDB,
    this._faceToFaceStreamingService,
    this._idService,
  ) : super(PeerConnectionInitial()) {
    _firebaseRealtimeDB.addOnChildAddedSubscription(
      (event) {
        final data = event.snapshot.value as Map<Object?, Object?>;
        _faceToFaceStreamingService.handleMessage(
          data: data,
          myId: _idService.myId,
          sendMessageAfterOffer: (description) async {
            await _firebaseRealtimeDB.sendMessage(_idService.myId, {
              'sdp': description.toMap(),
            });
          },
        );
      },
    );

    on<PeerConnectionInit>((event, emit) async {
      emit(PeerConnectionInitLoading());
      await _initRenderers();

      final tracks = await _setupLocalRenderer();

      await _initStreamingService(tracks);

      emit(PeerConnectionInitLoadingDone());
    });

    on<PeerConnectionLaunchCall>((event, emit) async {
      emit(PeerConnectionCallLoading());

      await _faceToFaceStreamingService.makeConnection(
        sendMessageAfterOffer: (description) async {
          await _firebaseRealtimeDB.sendMessage(_idService.myId, {
            'sdp': description.toMap(),
          });
        },
      );

      emit(PeerConnectionCallLoadingDone());
    });
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<List<MediaStreamTrack>> _setupLocalRenderer() async {
    _localStream = await _faceToFaceStreamingService.getUserMedia();
    _localRenderer.srcObject = _localStream;

    final tracks = await _localStream.getTracks();
    return tracks;
  }

  Future<void> _initStreamingService(
    List<MediaStreamTrack> tracks,
  ) async {
    await _faceToFaceStreamingService.init(
      onCandidate: _onCandidate,
      onTrack: _onTrack,
      onAddTrack: _onAddTrack,
      onRemoveTrack: _onRemoveTrack,
      tracks: tracks,
      localStream: _localStream,
    );
  }

  @override
  Future<void> close() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();

    _firebaseRealtimeDB.removeOnChildAddedSubscription();

    return super.close();
  }

  // void _hangUp() async {
  //   try {
  //     await _localStream?.dispose();
  //     await _peerConnection?.close();
  //     _peerConnection = null;
  //     _localRenderer.srcObject = null;
  //     _remoteRenderer.srcObject = null;
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   setState(() {
  //     _inCalling = false;
  //   });
  //   // _timer?.cancel();
  // }

  void _onCandidate(RTCIceCandidate candidate) {
    print('onCandidate: ${candidate.candidate}');

    _firebaseRealtimeDB
        .sendMessage(_idService.myId, {'ice': candidate.toMap()});
  }

  void _onTrack(RTCTrackEvent event) {
    print('onTrack');
    if (event.track.kind == 'video') {
      _remoteRenderer.srcObject = event.streams[0];
    }
  }

  void _onAddTrack(MediaStream stream, MediaStreamTrack track) {
    if (track.kind == 'video') {
      _remoteRenderer.srcObject = stream;
    }
  }

  void _onRemoveTrack(MediaStream stream, MediaStreamTrack track) {
    if (track.kind == 'video') {
      _remoteRenderer.srcObject = null;
    }
  }
}

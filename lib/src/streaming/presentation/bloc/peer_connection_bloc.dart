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
  final FbRealtimeRepository _fbRealtimeRepository;
  final WebRTCRepository _webRTCRepository;
  final IdService _idService;

  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;

  late final MediaStream _localStream;

  PeerConnectionBloc(
    this._fbRealtimeRepository,
    this._webRTCRepository,
    this._idService,
  ) : super(PeerConnectionInitial()) {
    _fbRealtimeRepository.addOnChildAddedSubscription(
      (event) {
        final data = event.snapshot.value as Map<Object?, Object?>;
        _webRTCRepository.handleMessage(
          data: data,
          myId: _idService.id,
          sendMessageAfterOffer: (description) async {
            await _fbRealtimeRepository.sendMessage(_idService.id, {
              'sdp': description.toMap(),
            });
          },
        );
      },
    );

    on<PeerConnectionInit>((event, emit) async {
      emit(PeerConnectionInitLoading());

      await _initStreamingConnection();

      emit(PeerConnectionInitLoadingDone());
    });

    on<PeerConnectionLaunchCall>((event, emit) async {
      emit(PeerConnectionCallLoading());

      await _webRTCRepository.makeConnection(
        sendMessageAfterOffer: (description) async {
          await _fbRealtimeRepository.sendMessage(_idService.id, {
            'sdp': description.toMap(),
          });
        },
      );

      emit(PeerConnectionCallLoadingDone());
    });
  }

  Future<void> _initStreamingConnection() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    _localStream = await _webRTCRepository.getUserMedia();
    _localRenderer.srcObject = _localStream;
    final tracks = await _localStream.getTracks();

    await _webRTCRepository.init(
      onCandidate: _onCandidate,
      onTrack: _onTrack,
      onAddTrack: _onAddTrack,
      onRemoveTrack: _onRemoveTrack,
      tracks: tracks,
      localStream: _localStream,
    );
  }

  @override
  Future<void> close() async {
    await _localRenderer.dispose();
    await _remoteRenderer.dispose();
    await _localStream.dispose();

    await _webRTCRepository.closePeerConnection();

    _fbRealtimeRepository.removeOnChildAddedSubscription();

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

    _fbRealtimeRepository
        .sendMessage(_idService.id, {'ice': candidate.toMap()});
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

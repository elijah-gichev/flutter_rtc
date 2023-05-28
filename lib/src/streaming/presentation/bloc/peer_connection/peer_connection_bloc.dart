import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_example/src/common/services/id_service.dart';
import 'package:flutter_webrtc_example/src/streaming/data/repository/fb_realtime_repository.dart';
import 'package:flutter_webrtc_example/src/streaming/data/repository/webrtc_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'peer_connection_event.dart';
part 'peer_connection_state.dart';

@injectable
class PeerConnectionBloc
    extends Bloc<PeerConnectionEvent, PeerConnectionState> {
  final FbRealtimeRepository _fbRealtimeRepository;
  final WebRTCRepository _webRTCRepository;
  final IdService _idService;

  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();

  late final MediaStream _localStream;

  String? recipientId;

  PeerConnectionBloc(
    this._fbRealtimeRepository,
    this._webRTCRepository,
    this._idService,
  ) : super(PeerConnectionInitLoading()) {
    on<PeerConnectionInitiated>((event, emit) async {
      recipientId = event.recipientId;

      await _initStreamingConnection(emit);

      makeSubscriptionYourself();

      emit(PeerConnectionInitLoadingDone());
    });

    on<PeerConnectionCallStarted>((event, emit) async {
      emit(PeerConnectionCallLoading());

      makeSubscriptionSender();

      await _webRTCRepository.makeConnection(
        sendMessageAfterOffer: (description) async {
          await _fbRealtimeRepository.sendMessage(_idService.id, recipientId!, {
            'sdp': description.toMap(),
          });
        },
      );
    });

    on<PeerConnectionCallCanceled>((event, emit) async {
      _cancelCall();
      emit(PeerConnectionCancelCall());
    });

    on<PeerConnectionReady>(
      (event, emit) {
        emit(PeerConnectionCallLoadingDone());
      },
    );
  }

  Future<void> _initStreamingConnection(
      Emitter<PeerConnectionState> emit) async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    _localStream = await _webRTCRepository.getUserMedia();
    localRenderer.srcObject = _localStream;
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

  void makeSubscriptionYourself() {
    _fbRealtimeRepository.addOnChildAddedSubscription(
      _idService.id,
      (event) {
        final data = event.snapshot.value as Map<Object?, Object?>;

        _webRTCRepository.handleMessage(
          data: data,
          myId: _idService.id,
          sendMessageAfterOffer: (description) async {
            await _fbRealtimeRepository
                .sendMessage(_idService.id, recipientId!, {
              'sdp': description.toMap(),
            });
          },
        );
      },
    );
  }

  void makeSubscriptionSender() {
    _fbRealtimeRepository.addOnChildAddedSubscription(
      recipientId!,
      (event) {
        if (event.snapshot.key != 'account_id') {
          final data = event.snapshot.value as Map<Object?, Object?>;

          _webRTCRepository.handleMessage(
            data: data,
            myId: _idService.id,
            sendMessageAfterOffer: (description) async {
              await _fbRealtimeRepository
                  .sendMessage(_idService.id, recipientId!, {
                'sdp': description.toMap(),
              });
            },
          );
        }
      },
    );
  }

  void _cancelCall() async {
    try {
      await _localStream.dispose();
      await _webRTCRepository.closePeerConnection();
      localRenderer.srcObject = null;
      remoteRenderer.srcObject = null;
    } catch (e) {
      print(e.toString());
    }
  }

  void _onCandidate(RTCIceCandidate candidate) {
    print('onCandidate: ${candidate.candidate}');

    _fbRealtimeRepository
        .sendMessage(_idService.id, recipientId!, {'ice': candidate.toMap()});
  }

  void _onTrack(RTCTrackEvent event) {
    if (event.track.kind == 'video') {
      remoteRenderer.srcObject = event.streams[0];
      add(PeerConnectionReady());
    }
  }

  void _onAddTrack(MediaStream stream, MediaStreamTrack track) {
    print('_remoteRenderer onAddTrack');
    if (track.kind == 'video') {
      remoteRenderer.srcObject = stream;
      add(PeerConnectionReady());
    }
  }

  void _onRemoveTrack(MediaStream stream, MediaStreamTrack track) {
    print('_remoteRenderer onRemoveTrack');
    if (track.kind == 'video') {
      remoteRenderer.srcObject = null;
    }
  }

  @override
  Future<void> close() async {
    await localRenderer.dispose();
    await remoteRenderer.dispose();
    await _localStream.dispose();

    await _webRTCRepository.closePeerConnection();

    _fbRealtimeRepository.removeOnChildAddedSubscription();
    await _fbRealtimeRepository.clearAll();

    return super.close();
  }

  @override
  void onChange(Change<PeerConnectionState> change) {
    super.onChange(change);
    print(change.toString());
    print(change.currentState.toString());
    print(change.nextState.toString());
  }
}

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WebRTCRepository {
  late final RTCPeerConnection _peerConnection;

  Future<void> init({
    required void Function(RTCIceCandidate) onCandidate,
    required void Function(RTCTrackEvent) onTrack,
    required void Function(MediaStream, MediaStreamTrack) onAddTrack,
    required void Function(MediaStream, MediaStreamTrack) onRemoveTrack,
    required List<MediaStreamTrack> tracks,
    required MediaStream localStream,
  }) async {
    try {
      _peerConnection =
          await createPeerConnection(_configuration, _loopbackConstraints);

      _peerConnection.onSignalingState = _onSignalingState;
      _peerConnection.onIceGatheringState = _onIceGatheringState;
      _peerConnection.onIceConnectionState = _onIceConnectionState;
      _peerConnection.onConnectionState = _onPeerConnectionState;

      _peerConnection.onRenegotiationNeeded = _onRenegotiationNeeded;

      // callbacks which can be installed outside
      _peerConnection.onIceCandidate = onCandidate;
      _peerConnection.onTrack = onTrack;
      _peerConnection.onAddTrack = onAddTrack;
      _peerConnection.onRemoveTrack = onRemoveTrack;

      await _addTracksToPeer(tracks, localStream);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> closePeerConnection() async {
    await _peerConnection.close();
  }

  Future<void> makeConnection({
    required Future<void> Function(RTCSessionDescription) sendMessageAfterOffer,
  }) async {
    try {
      // Create, Add, Set Offer
      final description = await _peerConnection.createOffer();

      await _peerConnection.setLocalDescription(description);

      final localDescription = await _peerConnection.getLocalDescription();
      await sendMessageAfterOffer(localDescription!);

      //await _firebaseRealtimeDB.sendMessage(yourId, {'sdp': localDescription!.toMap()});
    } catch (e) {
      print(e.toString());
    }
  }

  void handleMessage({
    required Map<Object?, Object?> data,
    required String myId,
    required Future<void> Function(RTCSessionDescription) sendMessageAfterOffer,
  }) async {
    final msg = data['message'] as Map<Object?, Object?>;
    final senderId = data['sender'] as String;

    if (senderId != myId) {
      if (msg['ice'] != null) {
        final iceData = msg['ice'] as Map<Object?, Object?>;

        final candidate = iceData['candidate'] as String;
        final sdpMLineIndex = iceData['sdpMLineIndex'] as int;
        final sdpMid = iceData['sdpMid'] as String;

        _peerConnection
            .addCandidate(RTCIceCandidate(candidate, sdpMid, sdpMLineIndex));
      } else {
        final sdpMap = msg['sdp'] as Map<Object?, Object?>;
        final String type = sdpMap['type'] as String;
        final String sdp = sdpMap['sdp'] as String;
        if (type == 'offer') {
          await _peerConnection
              .setRemoteDescription(RTCSessionDescription(sdp, type));

          final answer =
              await _peerConnection.createAnswer({'offerToReceiveVideo': 1});

          await _peerConnection.setLocalDescription(answer);

          final localDescription = await _peerConnection.getLocalDescription();

          await sendMessageAfterOffer(localDescription!);
          // _firebaseRealtimeDB.sendMessage(yourId, {'sdp': localDescription!.toMap()});
        } else if (type == 'answer') {
          _peerConnection
              .setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
        }
      }
    }
  }

  /// Calling this method will prompts the user to select and grant permission
  /// to capture the contents of a display or portion thereof (such as a window) as a MediaStream.
  ///  The resulting stream can then be recorded using
  /// the MediaStream Recording API or transmitted as part of a WebRTC session.
  Future<MediaStream> getUserMedia() {
    return navigator.mediaDevices.getUserMedia(_mediaConstraints);
  }

  Future<void> _addTracksToPeer(
      List<MediaStreamTrack> tracks, MediaStream localStream) async {
    tracks.forEach((track) async {
      await _peerConnection.addTrack(track, localStream);
    });
    // _localStream!.getTracks().forEach((track) {
    //   _peerConnection.addTrack(track, _localStream!);
    // });
  }

  void _onSignalingState(RTCSignalingState state) {
    print(state);
  }

  void _onIceGatheringState(RTCIceGatheringState state) {
    print(state);
  }

  void _onIceConnectionState(RTCIceConnectionState state) {
    print(state);
  }

  void _onPeerConnectionState(RTCPeerConnectionState state) {
    print("state: $state");
  }

  void _onRenegotiationNeeded() {
    print('RenegotiationNeeded');
  }

  static const _sdpSemantics = 'unified-plan';

  final _mediaConstraints = <String, dynamic>{
    'audio': true,
    'video': {
      'mandatory': {
        'minWidth': '640', // Provide your own width, height and frame rate here
        'minHeight': '480',
        'minFrameRate': '30',
      },
      'facingMode': 'user',
      'optional': [],
    }
  };

  final _configuration = <String, dynamic>{
    'iceServers': [
      {'urls': 'stun:stun.services.mozilla.com'},
      {'urls': 'stun:stun.l.google.com:19302'},
      {
        'urls': 'turn:numb.viagenie.ca',
        'credential': '10irarog',
        'username': 'elijah.gichev@gmail.com'
      }
    ],
    'sdpSemantics': _sdpSemantics
  };

  final _loopbackConstraints = <String, dynamic>{
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': false},
    ],
  };
}

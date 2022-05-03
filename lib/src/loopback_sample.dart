import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_example/src/services/firebase_realtime_db.dart';

class LoopBackSample extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LoopBackSample> {
  MediaStream? _localStream;
  RTCPeerConnection? _peerConnection;

  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();

  bool _inCalling = false;

  String get sdpSemantics => 'unified-plan';

  //String get sdpSemantics => 'plan-b'

  final FirebaseRealtimeDB _firebaseRealtimeDB = FirebaseRealtimeDB(FirebaseDatabase.instance);

  final int yourId = Random().nextInt(1000000000);

  bool haveOffer = false;

  @override
  void initState() {
    super.initState();
    initRenderers();

    _firebaseRealtimeDB.addOnChildAddedSubscription(readMessage);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await initCall();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (_inCalling) {
      _hangUp();
    }
    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  void initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
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

  void _onAddStream(MediaStream stream) {
    print('New stream: ' + stream.id);
    _remoteRenderer.srcObject = stream;
  }

  void _onRemoveStream(MediaStream stream) {
    _remoteRenderer.srcObject = null;
  }

  void _onCandidate(RTCIceCandidate candidate) {
    //(event => event.candidate?sendMessage(yourId, JSON.stringify({'ice': event.candidate})):console.log("Sent All Ice") );
    print('onCandidate: ${candidate.candidate}');

    _firebaseRealtimeDB.sendMessage(yourId, {'ice': candidate.toMap()});

    //_peerConnection?.addCandidate(candidate);
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

  void _onRenegotiationNeeded() {
    print('RenegotiationNeeded');
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _makeCall() async {
    try {
      // Create, Add, Set Offer
      final description = await _peerConnection!.createOffer();

      await _peerConnection!.setLocalDescription(description);

      final localDescription = await _peerConnection!.getLocalDescription();
      await _firebaseRealtimeDB.sendMessage(yourId, {'sdp': localDescription!.toMap()});
    } catch (e) {
      print(e.toString());
    }
    if (!mounted) return;

    setState(() {
      _inCalling = true;
    });
  }

  Future<void> initCall() async {
    final mediaConstraints = <String, dynamic>{
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

    var configuration = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.services.mozilla.com'},
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'turn:numb.viagenie.ca', 'credential': '10irarog', 'username': 'elijah.gichev@gmail.com'}
      ],
      'sdpSemantics': sdpSemantics
    };

    final offerSdpConstraints = <String, dynamic>{
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional': [],
    };

    final loopbackConstraints = <String, dynamic>{
      'mandatory': {},
      'optional': [
        {'DtlsSrtpKeyAgreement': false},
      ],
    };
    try {
      _peerConnection = await createPeerConnection(configuration, loopbackConstraints);

      _peerConnection!.onSignalingState = _onSignalingState;
      _peerConnection!.onIceGatheringState = _onIceGatheringState;
      _peerConnection!.onIceConnectionState = _onIceConnectionState;
      _peerConnection!.onConnectionState = _onPeerConnectionState;
      _peerConnection!.onIceCandidate = _onCandidate;
      _peerConnection!.onRenegotiationNeeded = _onRenegotiationNeeded;

      _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localRenderer.srcObject = _localStream;

      switch (sdpSemantics) {
        case 'plan-b':
          _peerConnection!.onAddStream = _onAddStream;
          _peerConnection!.onRemoveStream = _onRemoveStream;
          await _peerConnection!.addStream(_localStream!);
          break;
        case 'unified-plan':
          _peerConnection!.onTrack = _onTrack;
          _peerConnection!.onAddTrack = _onAddTrack;
          _peerConnection!.onRemoveTrack = _onRemoveTrack;
          _localStream!.getTracks().forEach((track) {
            _peerConnection!.addTrack(track, _localStream!);
          });
          break;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void readMessage(DatabaseEvent event) async {
    final data = event.snapshot.value as Map<Object?, Object?>;

    final msg = data['message'] as Map<Object?, Object?>;
    final sender = data['sender'] as int;

    if (sender != yourId) {
      if (msg['ice'] != null) {
        final iceData = msg['ice'] as Map<Object?, Object?>;

        final candidate = iceData['candidate'] as String;
        final sdpMLineIndex = iceData['sdpMLineIndex'] as int;
        final sdpMid = iceData['sdpMid'] as String;

        _peerConnection!.addCandidate(RTCIceCandidate(candidate, sdpMid, sdpMLineIndex));
      } else {
        final sdpMap = msg['sdp'] as Map<Object?, Object?>;
        final String type = sdpMap['type'] as String;
        final String sdp = sdpMap['sdp'] as String;
        if (type == 'offer') {
          //print("sdp: $sdp");
          await _peerConnection!.setRemoteDescription(RTCSessionDescription(sdp, type));

          final answer = await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});

          await _peerConnection!.setLocalDescription(answer);

          final localDescription = await _peerConnection!.getLocalDescription();

          _firebaseRealtimeDB.sendMessage(yourId, {'sdp': localDescription!.toMap()});
        } else if (type == 'answer') {
          _peerConnection!.setRemoteDescription(RTCSessionDescription(sdp, 'answer'));
        }
      }
    }
  }

  void _hangUp() async {
    try {
      await _localStream?.dispose();
      await _peerConnection?.close();
      _peerConnection = null;
      _localRenderer.srcObject = null;
      _remoteRenderer.srcObject = null;
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      _inCalling = false;
    });
    // _timer?.cancel();
  }

  void _sendDtmf() async {
    var dtmfSender = _peerConnection?.createDtmfSender(_localStream!.getAudioTracks()[0]);
    await dtmfSender?.insertDTMF('123#');
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[
      Expanded(
        child: RTCVideoView(_localRenderer, mirror: true),
      ),
      Expanded(
        child: RTCVideoView(_remoteRenderer),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('LoopBack example'),
        actions: _inCalling
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.keyboard),
                  onPressed: _sendDtmf,
                ),
              ]
            : null,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: Container(
              decoration: BoxDecoration(color: Colors.black54),
              child: orientation == Orientation.portrait
                  ? Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: widgets)
                  : Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: widgets),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _inCalling ? _hangUp : _makeCall,
        tooltip: _inCalling ? 'Hangup' : 'Call',
        child: Icon(_inCalling ? Icons.call_end : Icons.phone),
      ),
    );
  }
}

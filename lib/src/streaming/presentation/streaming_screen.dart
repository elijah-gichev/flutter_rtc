import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_example/src/common/services/id_service.dart';
import 'package:flutter_webrtc_example/src/streaming/data/repository/fb_realtime_repository.dart';
import 'package:flutter_webrtc_example/src/streaming/data/repository/webrtc_repository.dart';
import 'package:flutter_webrtc_example/src/streaming/presentation/bloc/peer_connection_bloc.dart';

class StreamingScreen extends StatelessWidget {
  const StreamingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PeerConnectionBloc(
        FbRealtimeRepository(FirebaseDatabase.instance),
        WebRTCRepository(),
        IdService(),
      ),
      child: FaceToFaceStreamingView(),
    );
  }
}

class FaceToFaceStreamingView extends StatefulWidget {
  @override
  _FaceToFaceStreamingViewState createState() =>
      _FaceToFaceStreamingViewState();
}

class _FaceToFaceStreamingViewState extends State<FaceToFaceStreamingView> {
  @override
  void initState() {
    super.initState();
    context.read<PeerConnectionBloc>().add(PeerConnectionInit());
  }

  // void _sendDtmf() async {
  //   var dtmfSender = _peerConnection?.createDtmfSender(_localStream!.getAudioTracks()[0]);
  //   await dtmfSender?.insertDTMF('123#');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face to face streaming'),
        // actions: _inCalling
        //     ? <Widget>[
        //         IconButton(
        //           icon: Icon(Icons.keyboard),
        //           onPressed: _sendDtmf,
        //         ),
        //       ]
        //     : null,
      ),
      body: BlocBuilder<PeerConnectionBloc, PeerConnectionState>(
        builder: (context, state) {
          return Center(
            child: Container(
              decoration: BoxDecoration(color: Colors.black54),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: RTCVideoView(
                        context.watch<PeerConnectionBloc>().localRenderer,
                        mirror: true),
                  ),
                  Expanded(
                    child: RTCVideoView(
                      context.watch<PeerConnectionBloc>().remoteRenderer,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PeerConnectionBloc>().add(PeerConnectionLaunchCall());
        },
        tooltip: 'Call',
        child: Icon(Icons.phone),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _inCalling ? _hangUp : _makeCall,
      //   tooltip: _inCalling ? 'Hangup' : 'Call',
      //   child: Icon(_inCalling ? Icons.call_end : Icons.phone),
      // ),
    );
  }
}

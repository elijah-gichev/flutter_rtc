import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_example/src/streaming/presentation/bloc/peer_connection/peer_connection_bloc.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class StreamingScreen extends StatelessWidget {
  final String id;
  final String name;
  const StreamingScreen(this.id, this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<PeerConnectionBloc>(),
      child: FaceToFaceStreamingView(id),
    );
  }
}

class FaceToFaceStreamingView extends StatefulWidget {
  final String id;

  FaceToFaceStreamingView(this.id);
  @override
  _FaceToFaceStreamingViewState createState() =>
      _FaceToFaceStreamingViewState();
}

class _FaceToFaceStreamingViewState extends State<FaceToFaceStreamingView> {
  @override
  void initState() {
    super.initState();
    context.read<PeerConnectionBloc>().add(PeerConnectionInitiated(widget.id));
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
                    child: state is PeerConnectionCallLoadingDone
                        ? RTCVideoView(
                            context.watch<PeerConnectionBloc>().remoteRenderer,
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton:
          BlocBuilder<PeerConnectionBloc, PeerConnectionState>(
        builder: (context, state) {
          return state is PeerConnectionCallLoadingDone
              ? FloatingActionButton(
                  onPressed: () {
                    context
                        .read<PeerConnectionBloc>()
                        .add(PeerConnectionCallCanceled());
                  },
                  child: Icon(Icons.call_end),
                )
              : FloatingActionButton(
                  onPressed: () {
                    context
                        .read<PeerConnectionBloc>()
                        .add(PeerConnectionCallStarted());
                  },
                  child: Icon(Icons.phone),
                );
        },
      ),
    );
  }
}

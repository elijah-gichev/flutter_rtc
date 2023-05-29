import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';
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
      child: FaceToFaceStreamingView(id, name),
    );
  }
}

class FaceToFaceStreamingView extends StatefulWidget {
  final String id;
  final String name;

  FaceToFaceStreamingView(this.id, this.name);
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
      // actions: _inCalling
      //     ? <Widget>[
      //         IconButton(
      //           icon: Icon(Icons.keyboard),
      //           onPressed: _sendDtmf,
      //         ),
      //       ]
      //     : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        height: 70,
        backgroundColor: CustomColors.primary,
        icons: [Icons.chat, Icons.more_vert],
        iconSize: 30,
        inactiveColor: Colors.white,
        activeColor: Colors.white,
        activeIndex: 0,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,

        onTap: (index) {},
        //other params
      ),
      body: BlocBuilder<PeerConnectionBloc, PeerConnectionState>(
        builder: (context, state) {
          return Center(
            child: Stack(
              children: [
                Center(
                  child: Expanded(
                    child: RTCVideoView(
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      context.watch<PeerConnectionBloc>().localRenderer,
                      mirror: true,
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: CustomColors.background,
                        ),
                      ),
                      Text(
                        widget.id.substring(0, 20),
                        //overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: CustomColors.secondary,
                        ),
                      ),
                      SizedBox(height: 10),
                      _CallDuration(),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 25, top: 50),
                  alignment: Alignment.topRight,
                  child: _AnotherPeer(),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      context.router.pop();
                    },
                    child: Container(
                      height: 48,
                      width: 48,
                      margin: EdgeInsets.only(left: 25, top: 50),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton:
          BlocBuilder<PeerConnectionBloc, PeerConnectionState>(
        builder: (context, state) {
          return FloatingActionButton(
            backgroundColor: state is PeerConnectionCallLoadingDone
                ? CustomColors.cancelCallColor
                : CustomColors.primary,
            onPressed: state is PeerConnectionCallLoadingDone
                ? () {
                    context
                        .read<PeerConnectionBloc>()
                        .add(PeerConnectionCallCanceled());
                  }
                : () {
                    context
                        .read<PeerConnectionBloc>()
                        .add(PeerConnectionCallStarted());
                  },
            child: state is PeerConnectionCallLoadingDone
                ? Icon(
                    Icons.call_end,
                    size: 30,
                  )
                : Icon(
                    Icons.phone,
                    size: 30,
                  ),
          );
        },
      ),
    );
  }
}

class _AnotherPeer extends StatelessWidget {
  const _AnotherPeer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeerConnectionBloc, PeerConnectionState>(
      builder: (context, state) {
        return state is PeerConnectionCallLoadingDone
            ? Container(
                height: 200,
                width: 150,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: RTCVideoView(
                  context.watch<PeerConnectionBloc>().remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}

class _CallDuration extends StatefulWidget {
  @override
  _CallDurationState createState() => _CallDurationState();
}

class _CallDurationState extends State<_CallDuration> {
  late final Timer _timer;
  Duration currentCallDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        currentCallDuration = currentCallDuration + Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String minutes = (duration.inMinutes).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.2),
      ),
      padding: EdgeInsets.all(5),
      child: Text(
        _formatDuration(
          currentCallDuration,
        ),
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

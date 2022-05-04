import 'dart:core';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc_example/src/services/firebase_realtime_db.dart';

import 'src/face_to_face_streaming/face_to_face_streaming.dart';
import 'src/route_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<RouteItem> items = <RouteItem>[
    RouteItem(
        title: 'LoopBack Sample',
        push: (BuildContext context) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FaceToFaceStreaming()));
        }),
    // RouteItem(
    //     title: 'LoopBack Sample',
    //     push: (BuildContext context) {
    //       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoopBackSample()));
    //     }),
    RouteItem(
      title: 'clear all',
      push: (BuildContext context) {
        final db = FirebaseRealtimeDB(FirebaseDatabase.instance);
        db.clearAll();
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter-WebRTC example'),
        ),
        body: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0.0),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final item = items[i];
            return ListBody(
              children: <Widget>[
                ListTile(
                  title: Text(item.title),
                  onTap: () => item.push(context),
                  trailing: Icon(Icons.arrow_right),
                ),
                Divider()
              ],
            );
          },
        ),
      ),
    );
  }
}

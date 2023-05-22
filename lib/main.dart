import 'dart:core';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc_example/src/common/services/id_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'src/route_item.dart';
import 'src/streaming/data/repository/fb_realtime_repository.dart';
import 'src/streaming/presentation/streaming_screen.dart';

late GetIt getIt;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  final prefs = await SharedPreferences.getInstance();
  getIt = GetIt.instance;
  getIt.registerSingleton(
    IdService(Uuid(), prefs),
  );

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamingScreen(),
          ),
        );
      },
    ),
    // RouteItem(
    //     title: 'LoopBack Sample',
    //     push: (BuildContext context) {
    //       Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LoopBackSample()));
    //     }),
    RouteItem(
      title: 'clear all',
      push: (BuildContext context) {
        final db = FbRealtimeRepository(FirebaseDatabase.instance);
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

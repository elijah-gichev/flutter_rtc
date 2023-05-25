import 'dart:core';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_example/src/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'src/common/config/injectable/injectable_config.dart';
import 'src/route_item.dart';
import 'src/streaming/data/repository/fb_realtime_repository.dart';
import 'src/streaming/presentation/streaming_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(Environment.prod);

  runApp(Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<AuthCubit>()..logIn(),
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      }, //makeNewAccount
    ),
    RouteItem(
      title: 'add',
      push: (_) {
        final db = FbRealtimeRepository(FirebaseDatabase.instance);
        db.makeNewAccount('123');
      }, //makeNewAccount
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter-WebRTC example'),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is AuthCompleted) {
              return ListView.builder(
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
              );
            } else {
              // Todo add alert
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_example/src/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:flutter_webrtc_example/src/auth/presentation/ui/login_screen.dart';
import 'package:flutter_webrtc_example/src/common/widgets/incoming_call_alert.dart';
import 'package:flutter_webrtc_example/src/streaming/presentation/bloc/users/users_cubit.dart';
import 'package:flutter_webrtc_example/src/streaming/presentation/ui/streaming_screen.dart';
import 'package:flutter_webrtc_example/src/streaming/presentation/ui/users_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:injectable/injectable.dart';
import 'src/common/config/injectable/injectable_config.dart';
import 'src/common/services/id_service.dart';
import 'src/route_item.dart';
import 'src/streaming/presentation/bloc/incoming_call/incoming_call_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies(Environment.prod);

  runApp(Application());
}

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.I<AuthCubit>()..logIn(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<IncomingCallCubit>(),
        ),
      ],
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
      title: 'Users',
      push: (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => GetIt.I<UsersCubit>()..load(),
              child: UsersScreen(),
            ),
          ),
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: Text('User: ${GetIt.I<IdService>().id}'),
      //   ),
      //   body: BlocListener<IncomingCallCubit, IncomingCallState>(
      //     listener: (context, state) {
      //       if (state is IncomingCallAdmission) {
      //         showIncomingCallAlert(
      //           context,
      //           state.callerId,
      //           onRejectCall: () async {
      //             await context.read<IncomingCallCubit>().rejectIncomingCall();
      //             //Navigator.of(context).pop();
      //           },
      //           onTakeCall: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (_) => StreamingScreen(state.callerId),
      //               ),
      //             );
      //           },
      //         );
      //       }
      //     },
      //     child: BlocBuilder<AuthCubit, AuthState>(
      //       builder: (context, state) {
      //         if (state is AuthInProgress) {
      //           return Center(
      //             child: CircularProgressIndicator(),
      //           );
      //         }

      //         if (state is AuthCompleted) {
      //           return ListView.builder(
      //             shrinkWrap: true,
      //             padding: const EdgeInsets.all(0.0),
      //             itemCount: items.length,
      //             itemBuilder: (context, i) {
      //               final item = items[i];
      //               return ListBody(
      //                 children: <Widget>[
      //                   ListTile(
      //                     title: Text(item.title),
      //                     onTap: () => item.push(context),
      //                     trailing: Icon(Icons.arrow_right),
      //                   ),
      //                   Divider()
      //                 ],
      //               );
      //             },
      //           );
      //         } else {
      //           // Todo add alert
      //           return SizedBox();
      //         }
      //       },
      //     ),
      //   ),
      // ),
    );
  }
}

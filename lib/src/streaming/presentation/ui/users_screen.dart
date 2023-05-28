import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_example/src/common/services/id_service.dart';
import 'package:flutter_webrtc_example/src/streaming/presentation/bloc/users/users_cubit.dart';
import 'package:flutter_webrtc_example/src/streaming/presentation/ui/streaming_screen.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class UsersScreen extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<UsersCubit>()..load(),
      child: this,
    );
  }

  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('User: ${GetIt.I<IdService>().id}'),
        ),
        body: BlocBuilder<UsersCubit, UsersState>(
          builder: (context, state) {
            if (state is UsersInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UsersCompleted) {
              return ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                itemCount: state.ids.length,
                itemBuilder: (context, i) {
                  final id = state.ids[i];
                  return ListBody(
                    children: <Widget>[
                      ListTile(
                        title: Text(id),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StreamingScreen(id),
                            ),
                          );
                        },
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

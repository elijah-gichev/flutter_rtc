import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_example/src/streaming/presentation/bloc/users/users_cubit.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter-WebRTC example'),
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
                  final item = state.ids[i];
                  return ListBody(
                    children: <Widget>[
                      ListTile(
                        title: Text(item),
                        //onTap: () => item.push(context),
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

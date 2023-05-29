import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_example/src/auth/data/models/user.dart';
import 'package:flutter_webrtc_example/src/common/config/router/app_router.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';
import 'package:flutter_webrtc_example/src/history/data/models/history.dart';
import 'package:flutter_webrtc_example/src/history/presentation/bloc/cubit/history_cubit.dart';
import 'package:flutter_webrtc_example/src/streaming/presentation/bloc/users/users_cubit.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class UsersScreen extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.I<UsersCubit>()..load(),
        ),
        BlocProvider(
          create: (_) => GetIt.I<HistoryCubit>(),
        ),
      ],
      child: this,
    );
  }

  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Доступные пользователи',
            style: TextStyle(
              color: CustomColors.primary,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: CustomColors.primary,
            ),
            onPressed: () {
              context.router.pop();
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: BlocBuilder<UsersCubit, UsersState>(
          builder: (context, state) {
            if (state is UsersInProgress) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UsersCompleted) {
              return Container(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0.0),
                  itemCount: state.users.length,
                  itemBuilder: (context, i) {
                    final user = state.users[i];
                    return _UserItem(user);
                  },
                ),
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

class _UserItem extends StatelessWidget {
  final User user;

  const _UserItem(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.primary,
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, top: 20),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: TextStyle(
                    color: CustomColors.background,
                    fontWeight: FontWeight.w600,
                    fontSize: 23,
                  ),
                ),
                SizedBox(height: 10),
                MaterialButton(
                  onPressed: () {
                    context.read<HistoryCubit>().addHistory(
                          History.fromUser(
                            user,
                            isIncomingCall: true,
                          ),
                        );

                    context.router.push(
                      StreamingRoute(
                        id: user.id,
                        name: user.name,
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  color: CustomColors.background,
                  textColor: CustomColors.primary,
                  child: Text('Call'),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10, bottom: 10),
            alignment: Alignment.bottomRight,
            child: Text(
              'ID: ' + user.id,
              style: TextStyle(
                color: CustomColors.secondary,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}

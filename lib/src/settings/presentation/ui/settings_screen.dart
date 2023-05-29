import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_example/src/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:flutter_webrtc_example/src/common/config/router/app_router.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';
import 'package:flutter_webrtc_example/src/settings/presentation/ui/widgets/change_name_dialog.dart';
import 'package:flutter_webrtc_example/src/settings/presentation/ui/widgets/change_status_dialog.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Image.asset(
            'assets/avatar.png',
            height: 170,
            width: 170,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (previous, current) {
              return current is AuthCompleted;
            },
            builder: (context, state) {
              if (state is AuthCompleted) {
                final user = state.user;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showChangeNameDialog(context, user.name);
                        },
                        child: Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                            color: CustomColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'ID: ' + user.id,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: CustomColors.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          showChangeStatusDialog(context, user.isOnline);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Status: ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: CustomColors.secondary,
                            ),
                            children: [
                              TextSpan(
                                text: user.isOnline ? 'ONLINE' : 'OFFLINE',
                                style: TextStyle(
                                  color: user.isOnline
                                      ? Colors.green
                                      : CustomColors.cancelCallColor,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(
                        color: CustomColors.primary,
                        thickness: 2,
                      ),
                    ],
                  ),
                );
              }

              return Container();
            },
          ),
          SizedBox(height: 40),
          _SettingsTile(
            title: 'Logout',
            icon: Icons.logout,
            onTap: () {
              context.read<AuthCubit>().logOut();
              context.router.replace(const LoginRoute());
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;

  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: ListTile(
        leading: Icon(
          icon,
          color: CustomColors.background,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: CustomColors.background,
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
        ),
        tileColor: CustomColors.primary,
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: CustomColors.background,
          size: 17,
        ),
        onTap: onTap,
      ),
    );
  }
}

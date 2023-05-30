import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_example/src/auth/presentation/bloc/cubit/auth_cubit.dart';
import 'package:flutter_webrtc_example/src/common/config/constants.dart';
import 'package:flutter_webrtc_example/src/common/config/router/app_router.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';
import 'package:flutter_webrtc_example/src/common/widgets/action_button.dart';
import 'package:flutter_webrtc_example/src/home/presentation/ui/home_screen.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: CustomColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(56),
                  bottomRight: Radius.circular(56),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    spreadRadius: 4.0,
                    color: Color.fromARGB((0.25 * 255).toInt(), 0, 0, 0),
                  )
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Constants.appName,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 70,
                        color: CustomColors.background,
                      ),
                    ),
                    Text(
                      'Platform of online calling',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: CustomColors.background,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 35),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthInProgress) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: CustomColors.primary,
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ActionButton(
                          title: 'Login',
                          onPressed: () async {
                            await context.read<AuthCubit>().logIn();
                            context.router.replace(const HomeRootRoute());
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: ActionButton(
                          title: 'Sign up',
                          filled: false,
                          onPressed: () {
                            context.router.replace(const HomeRootRoute());
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

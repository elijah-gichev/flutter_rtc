import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc_example/src/common/config/constants.dart';
import 'package:flutter_webrtc_example/src/common/config/router/app_router.dart';
import 'package:flutter_webrtc_example/src/common/theme/palette.dart';
import 'package:flutter_webrtc_example/src/common/widgets/action_button.dart';
import 'package:flutter_webrtc_example/src/common/widgets/custom_bottom_navbar.dart';
import 'package:flutter_webrtc_example/src/common/widgets/incoming_call_alert.dart';
import 'package:flutter_webrtc_example/src/streaming/presentation/bloc/incoming_call/incoming_call_cubit.dart';

@RoutePage()
class HomeRootScreen extends StatelessWidget {
  const HomeRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<IncomingCallCubit, IncomingCallState>(
      listener: (context, state) {
        final topRoute = context.router.topRoute;

        if (state is IncomingCallAdmission &&
            topRoute.name != StreamingRoute.name) {
          showIncomingCallAlert(
            context,
            state.callerId,
            onRejectCall: () async {
              await context.read<IncomingCallCubit>().rejectIncomingCall();
            },
            onTakeCall: () {
              context.read<IncomingCallCubit>().acceptIncomingCall();
              context.router.push(StreamingRoute(
                id: state.callerId,
                name: 'fixed',
              ));
            },
          );
        }
      },
      child: AutoTabsRouter(
        routes: [
          HomeRoute(),
          HistoryRoute(),
          SettingsRoute(),
        ],
        transitionBuilder: (context, child, animation) => FadeTransition(
          opacity: animation,
          // the passed child is technically our animated selected-tab page
          child: child,
        ),
        builder: (context, child) {
          final tabsRouter = AutoTabsRouter.of(context);
          return Scaffold(
              body: child,
              bottomNavigationBar: CustomBottomNavbar(
                currentIndex: tabsRouter.activeIndex,
                onTap: (index) {
                  // here we switch between tabs
                  tabsRouter.setActiveIndex(index);
                },
                selectedItemColor: CustomColors.background,
                unselectedItemColor: CustomColors.secondary,
                items: [
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(Icons.house, color: CustomColors.secondary),
                    activeIcon:
                        Icon(Icons.house, color: CustomColors.background),
                  ),
                  BottomNavigationBarItem(
                    label: 'History',
                    icon: Icon(Icons.history, color: CustomColors.secondary),
                    activeIcon:
                        Icon(Icons.history, color: CustomColors.background),
                  ),
                  BottomNavigationBarItem(
                    label: 'Settings',
                    icon: Icon(Icons.settings, color: CustomColors.secondary),
                    activeIcon:
                        Icon(Icons.settings, color: CustomColors.background),
                  ),
                ],
              ));
        },
      ),
    );
  }
}

@RoutePage()
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 100),
            RichText(
              text: TextSpan(
                text: 'Let us, ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: CustomColors.primary,
                ),
                children: [
                  TextSpan(
                    text: Constants.appName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/logo.png',
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(children: [
                ActionButton(
                  title: 'New Meeting',
                  onPressed: () {
                    context.router.push(UsersRoute());
                  },
                ),
                SizedBox(height: 35),
                ActionButton(
                  filled: false,
                  onPressed: () {
                    context.router.push(UsersRoute());
                  },
                  title: 'Join a meeting',
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

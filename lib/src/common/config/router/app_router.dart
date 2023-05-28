import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc_example/src/auth/presentation/ui/login_screen.dart';
import 'package:flutter_webrtc_example/src/history/presentation/ui/history_screen.dart';
import 'package:flutter_webrtc_example/src/home/presentation/ui/home_screen.dart';
import 'package:flutter_webrtc_example/src/settings/presentation/ui/settings_screen.dart';
import 'package:flutter_webrtc_example/src/streaming/presentation/ui/streaming_screen.dart';
import 'package:flutter_webrtc_example/src/streaming/presentation/ui/users_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          //initial: true,
        ),
        AutoRoute(
          page: StreamingRoute.page,
        ),
        AutoRoute(
          page: UsersRoute.page,
        ),
        AutoRoute(
          page: HomeRootRoute.page,
          initial: true,
          children: [
            AutoRoute(
              page: HomeRoute.page,
            ),
            AutoRoute(
              page: HistoryRoute.page,
            ),
            AutoRoute(
              page: SettingsRoute.page,
              initial: true,
            ),
          ],
        ),
      ];
}

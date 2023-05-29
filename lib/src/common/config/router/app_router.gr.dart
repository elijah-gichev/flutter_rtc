// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    SettingsRoute.name: (routeData) {
      final args = routeData.argsAs<SettingsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SettingsScreen(
          user: args.user,
          key: args.key,
        ),
      );
    },
    HomeRootRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeRootScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginScreen(),
      );
    },
    UsersRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: const UsersScreen()),
      );
    },
    StreamingRoute.name: (routeData) {
      final args = routeData.argsAs<StreamingRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: StreamingScreen(
          args.id,
          args.name,
          key: args.key,
        ),
      );
    },
    HistoryRoute.name: (routeData) {
      final args = routeData.argsAs<HistoryRouteArgs>(
          orElse: () => const HistoryRouteArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(child: HistoryScreen(key: args.key)),
      );
    },
  };
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({
    required User user,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          SettingsRoute.name,
          args: SettingsRouteArgs(
            user: user,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'SettingsRoute';

  static const PageInfo<SettingsRouteArgs> page =
      PageInfo<SettingsRouteArgs>(name);
}

class SettingsRouteArgs {
  const SettingsRouteArgs({
    required this.user,
    this.key,
  });

  final User user;

  final Key? key;

  @override
  String toString() {
    return 'SettingsRouteArgs{user: $user, key: $key}';
  }
}

/// generated route for
/// [HomeRootScreen]
class HomeRootRoute extends PageRouteInfo<void> {
  const HomeRootRoute({List<PageRouteInfo>? children})
      : super(
          HomeRootRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRootRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UsersScreen]
class UsersRoute extends PageRouteInfo<void> {
  const UsersRoute({List<PageRouteInfo>? children})
      : super(
          UsersRoute.name,
          initialChildren: children,
        );

  static const String name = 'UsersRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [StreamingScreen]
class StreamingRoute extends PageRouteInfo<StreamingRouteArgs> {
  StreamingRoute({
    required String id,
    required String name,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          StreamingRoute.name,
          args: StreamingRouteArgs(
            id: id,
            name: name,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'StreamingRoute';

  static const PageInfo<StreamingRouteArgs> page =
      PageInfo<StreamingRouteArgs>(name);
}

class StreamingRouteArgs {
  const StreamingRouteArgs({
    required this.id,
    required this.name,
    this.key,
  });

  final String id;

  final String name;

  final Key? key;

  @override
  String toString() {
    return 'StreamingRouteArgs{id: $id, name: $name, key: $key}';
  }
}

/// generated route for
/// [HistoryScreen]
class HistoryRoute extends PageRouteInfo<HistoryRouteArgs> {
  HistoryRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          HistoryRoute.name,
          args: HistoryRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'HistoryRoute';

  static const PageInfo<HistoryRouteArgs> page =
      PageInfo<HistoryRouteArgs>(name);
}

class HistoryRouteArgs {
  const HistoryRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'HistoryRouteArgs{key: $key}';
  }
}

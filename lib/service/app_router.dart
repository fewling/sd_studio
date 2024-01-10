import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/base/base_screen.dart';
import '../screens/error/route_not_found_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/setting/setting_screen.dart';

enum Location {
  home('/home'),
  setting('/setting'),
  ;

  const Location(this.path);

  final String path;
}

final routerProvider = Provider(
  (ref) {
    final rootKey = GlobalKey<NavigatorState>();
    final shellKey = GlobalKey<NavigatorState>();

    return GoRouter(
      navigatorKey: rootKey,
      initialLocation: Location.home.path,
      errorBuilder: (context, state) => const RouteNotFoundScreen(),
      routes: [
        ShellRoute(
          navigatorKey: shellKey,
          builder: (context, state, child) => BaseScreen(child: child),
          routes: [
            GoRoute(
              parentNavigatorKey: shellKey,
              path: Location.home.path,
              name: Location.home.name,
              pageBuilder: (context, state) =>
                  const MaterialPage(child: HomeScreen()),
            ),
            GoRoute(
              parentNavigatorKey: shellKey,
              path: Location.setting.path,
              name: Location.setting.name,
              pageBuilder: (context, state) =>
                  const MaterialPage(child: SettingScreen()),
            ),
          ],
        ),
      ],
    );
  },
);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

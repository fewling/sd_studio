import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../service/app_router.dart';
import '../../service/global_controller_providers.dart';
import 'base_screen.dart';

class BaseMobile extends ConsumerWidget {
  const BaseMobile({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = ref.watch(baseScaffoldKeyProvider);

    final loc = GoRouterState.of(context).matchedLocation;
    final index = kBaseDrawerLocations.indexWhere((e) => e.pathName == loc);

    return Scaffold(
      key: key,
      drawer: NavigationDrawer(
        selectedIndex: index == -1 ? 0 : index,
        onDestinationSelected: (i) {
          final location = Location.values[i];
          context.goNamed(location.name);

          Future.delayed(const Duration(milliseconds: 250))
              .then((value) => key.currentState?.closeDrawer());
        },
        children: [
          for (final loc in kBaseDrawerLocations)
            NavigationDrawerDestination(
              icon: Tooltip(
                message: loc.label,
                child: Icon(loc.icon),
              ),
              selectedIcon: Tooltip(
                message: loc.label,
                child: Icon(loc.selectedIcon),
              ),
              label: Text(loc.label),
            ),
        ],
      ),
      body: child,
    );
  }
}

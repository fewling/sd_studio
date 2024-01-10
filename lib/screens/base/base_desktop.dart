import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'base_screen.dart';

class BaseDesktop extends ConsumerWidget {
  const BaseDesktop({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = GoRouterState.of(context).matchedLocation;
    final index = kBaseDrawerLocations.indexWhere((e) => e.pathName == loc);

    return Row(
      children: [
        Material(
          elevation: 5,
          child: NavigationRail(
            selectedIndex: index < 0 ? 0 : index,
            onDestinationSelected: (index) {
              final location = kBaseDrawerLocations[index];
              context.go(location.pathName);
            },
            labelType: NavigationRailLabelType.all,
            destinations: [
              for (final loc in kBaseDrawerLocations)
                NavigationRailDestination(
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
        ),
        Expanded(child: child),
      ],
    );
  }
}

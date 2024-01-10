import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../service/app_router.dart';
import '../../utils/convenient_extensions.dart';
import 'base_desktop.dart';
import 'base_mobile.dart';

const kBaseDrawerLocations = [
  DrawerLocation(
    Location.txt2img,
    Icons.home_outlined,
    Icons.home,
  ),
  DrawerLocation(
    Location.setting,
    Icons.settings_outlined,
    Icons.settings,
  ),
];

class DrawerLocation {
  const DrawerLocation(
    this.location,
    this.icon,
    this.selectedIcon,
  );

  final Location location;
  final IconData icon;
  final IconData selectedIcon;

  String get pathName => location.path;
  String get label => location.name.capFirst();
}

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => BaseMobile(child: child),
      tablet: (context) => BaseDesktop(child: child),
      desktop: (context) => BaseDesktop(child: child),
    );
  }
}

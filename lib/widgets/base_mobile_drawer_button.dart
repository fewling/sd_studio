import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/global_controller_providers.dart';

class BaseMobileDrawerButton extends ConsumerWidget {
  const BaseMobileDrawerButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: ref.read(baseScaffoldKeyProvider).currentState?.openDrawer,
      icon: const Icon(Icons.menu),
    );
  }
}

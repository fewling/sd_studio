import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/preference_provider.dart';

class ColorPickerSheet extends ConsumerWidget {
  const ColorPickerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final pref = ref.watch(appPreferenceControllerProvider);
    final prefNotifier = ref.watch(appPreferenceControllerProvider.notifier);

    final colorSeed = pref.colorSchemeSeed;

    // TODO: make bottom sheet scrollable

    return Column(
      children: [
        // Handle
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Opacity(
            opacity: 0.4,
            child: Container(
              color: colorScheme.onSurfaceVariant,
              width: 32,
              height: 4,
            ),
          ),
        ),

        // Color Grids
        Expanded(
          child: GridView.builder(
            itemCount: Colors.primaries.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100),
            itemBuilder: (_, index) {
              final c = Colors.primaries[index % Colors.primaries.length];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Material(
                      color: c,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: () => prefNotifier.setColorSchemeSeed(c.value),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    if (colorSeed == c.value)
                      const Positioned.fill(child: Icon(Icons.check))
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../service/app_info_provider.dart';
import '../../service/preference_provider.dart';
import '../../widgets/base_mobile_drawer_button.dart';
import '../../widgets/color_picker_sheet.dart';
import '../../widgets/error_info.dart';
import '../../widgets/loading_widget.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;

    final appInfoAsync = ref.watch(appInfoProvider);

    return Scaffold(
      appBar: getValueForScreenType(
        context: context,
        mobile: AppBar(
          leading: const BaseMobileDrawerButton(),
          title: const Text('Settings'),
        ),
        tablet: AppBar(title: const Text('Settings')),
        desktop: AppBar(title: const Text('Settings')),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.brightness_2_outlined, color: primary),
            title: const Text('Use Dark Mode'),
            onTap: () => _toggleBrightness(ref),
            trailing: Switch(
              value: ref.watch(appPreferenceControllerProvider).isDarkMode,
              onChanged: (_) => _toggleBrightness(ref),
            ),
          ),
          ListTile(
            leading: Icon(Icons.color_lens_outlined, color: primary),
            title: const Text('Color Scheme'),
            trailing: Icon(Icons.square, color: colorScheme.primary),
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (_) => const ColorPickerSheet(),
            ),
          ),
          ButtonBar(
            children: [
              // Chip(label: Text(commitHash.first7())),
              appInfoAsync.when(
                data: (info) => Chip(
                  label: Text(info.version),
                ),
                error: (e, s) => ErrorInfo(e: e, s: s),
                loading: () => const LoadingWidget(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleBrightness(WidgetRef ref) {
    ref.read(appPreferenceControllerProvider.notifier).toggleBrightness();
  }
}

class RoundChip extends StatelessWidget {
  const RoundChip({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

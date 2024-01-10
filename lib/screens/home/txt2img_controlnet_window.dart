import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../service/sd_service_provider.dart';
import '../../widgets/error_info.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/slider_tile.dart';
import 'txt2img_controlnet_notifier.dart';

class Txt2ImgControlnetWindow extends StatelessWidget {
  const Txt2ImgControlnetWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ControlnetSelectionSegments(),
        SizedBox(height: 8),
        ControlnetConfigWindow(),
        SizedBox(height: 8),
      ],
    );
  }
}

class ControlnetSelectionSegments extends ConsumerWidget {
  const ControlnetSelectionSegments({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlnetAsync = ref.watch(txt2imgControlnetControllerProvider);

    return controlnetAsync.when(
      data: (state) {
        final units = state.controlnetUnits;
        if (units.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Controlnet Units'),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: SegmentedButton(
                emptySelectionAllowed: true,
                segments: List.generate(
                  units.length,
                  (index) => ButtonSegment(
                    value: index,
                    label: Text('Unit ${index + 1}'),
                  ),
                ),
                selected: state.selectedIndexes,
                onSelectionChanged: ref
                    .read(txt2imgControlnetControllerProvider.notifier)
                    .selectControlnetUnit,
              ),
            ),
          ],
        );
      },
      error: (e, s) => ErrorInfo(e: e, s: s),
      loading: () => const LoadingWidget(),
    );
  }
}

class ControlnetConfigWindow extends ConsumerWidget {
  const ControlnetConfigWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indexes = ref.watch(
      txt2imgControlnetControllerProvider.select(
        (value) => value.value?.selectedIndexes,
      ),
    );

    if (indexes == null || indexes.isEmpty) return const SizedBox();

    return const Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ControlnetEnableTile(),
            Expanded(child: ControlnetImage()),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ControlnetModelsMenu(),
                  SizedBox(height: 8),
                  ControlnetModuleMenu(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ControlnetModuleSliders(),
            ),
          ],
        ),
      ),
    );
  }
}

class ControlnetEnableTile extends ConsumerWidget {
  const ControlnetEnableTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabledIndexes = ref.watch(txt2imgControlnetControllerProvider
        .select((value) => value.value?.enabledIndexes));

    final index = ref.watch(txt2imgControlnetControllerProvider
        .select((value) => value.value?.selectedIndexes.first));

    return SwitchListTile(
      value: enabledIndexes?.contains(index) ?? false,
      onChanged: ref
          .read(txt2imgControlnetControllerProvider.notifier)
          .toggleCurrentControlnetUnit,
      title: const Text('Enable'),
    );
  }
}

class ControlnetImage extends ConsumerWidget {
  const ControlnetImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(txt2imgControlnetControllerProvider
        .select((value) => value.value?.selectedIndexes.first));
    if (index == null) return const SizedBox();

    final inputImg = ref.watch(txt2imgControlnetControllerProvider
        .select((value) => value.value?.controlnetUnits[index].inputImage));

    final processedImg = ref.watch(txt2imgControlnetControllerProvider
        .select((value) => value.value?.processedImages[index]));

    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: ref
                .read(txt2imgControlnetControllerProvider.notifier)
                .uploadControlnetImage,
            child: SizedBox.expand(
              child: inputImg == null
                  ? const Icon(Icons.upload_file_outlined)
                  : Image.memory(base64Decode(inputImg)),
            ),
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: processedImg == null
              ? const Icon(Icons.image_search_outlined)
              : Image.memory(base64Decode(processedImg)),
        ),
      ],
    );
  }
}

class ControlnetModelsMenu extends ConsumerWidget {
  const ControlnetModelsMenu({
    super.key,
    this.title = 'Controlnet Models',
  });

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentModel = ref.watch(
      txt2imgControlnetControllerProvider.select((value) {
        final currentIndex = value.value?.selectedIndexes.first ?? 0;
        return value.value?.controlnetUnits[currentIndex].model;
      }),
    );

    return ref.watch(controlnetModelsProvider).when(
          data: (models) => DropdownMenu(
            label: Text(title),
            initialSelection: currentModel ?? models.first,
            onSelected: ref
                .read(txt2imgControlnetControllerProvider.notifier)
                .selectControlnetModel,
            dropdownMenuEntries: [
              for (final model in models)
                DropdownMenuEntry(
                  value: model,
                  label: model,
                ),
            ],
          ),
          error: (e, s) => const Text('Failed to load models'),
          loading: () => const Text('...'),
        );
  }
}

class ControlnetModuleMenu extends ConsumerWidget {
  const ControlnetModuleMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentModule = ref.watch(
      txt2imgControlnetControllerProvider.select((value) {
        final state = value.value;
        final currentIndex = state?.selectedIndexes.first ?? 0;
        return state?.controlnetUnits[currentIndex].module;
      }),
    );

    final moduleAsync = ref.watch(controlnetModuleProvider);
    return moduleAsync.when(
      data: (module) => Row(
        children: [
          DropdownMenu(
            onSelected: ref
                .read(txt2imgControlnetControllerProvider.notifier)
                .selectControlnetModule,
            label: const Text('Controlnet Modules'),
            initialSelection: currentModule ?? module.moduleList.first,
            dropdownMenuEntries: [
              for (final module in module.moduleList)
                DropdownMenuEntry(
                  value: module,
                  label: module,
                ),
            ],
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => ref
                .read(txt2imgControlnetControllerProvider.notifier)
                .processControlnet()
                .then((value) {
              if (value == null) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(value)));
            }),
            child: const Icon(Icons.reset_tv_rounded),
          ),
        ],
      ),
      error: (e, s) => Text('Failed to load modules, $e'),
      loading: () => const Text('...'),
    );
  }
}

class ControlnetModuleSliders extends ConsumerWidget {
  const ControlnetModuleSliders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(txt2imgControlnetControllerProvider
        .select((value) => value.value?.selectedIndexes.first));

    if (selectedIndex == null) return const SizedBox();

    final unit = ref.watch(txt2imgControlnetControllerProvider
        .select((value) => value.value?.controlnetUnits[selectedIndex]));
    if (unit == null) return const SizedBox();

    final module = ref.watch(txt2imgControlnetControllerProvider
        .select((value) => value.value?.controlnetUnits[selectedIndex].module));
    if (module == null) return const SizedBox();

    return Column(
      children: [
        SliderTile(
          title: 'Preprocessor ${unit.processorRes}',
          tooltip: 'Preprocessor resolution',
          label: unit.processorRes.toString(),
          min: 64,
          max: 2048,
          divisions: (2048 - 64) ~/ 8,
          value: unit.processorRes.toDouble(),
          onChanged: ref
              .read(txt2imgControlnetControllerProvider.notifier)
              .updateProcessorRes,
        ),
        SliderTile(
          title: 'Threshold A ${unit.thresholdA}',
          tooltip: 'Threshold A',
          label: unit.thresholdA.toString(),
          min: 64,
          max: 2048,
          divisions: (2048 - 64) ~/ 8,
          value: unit.thresholdA.toDouble(),
          onChanged: ref
              .read(txt2imgControlnetControllerProvider.notifier)
              .updateThresholdA,
        ),
        SliderTile(
          title: 'Threshold B ${unit.thresholdB}',
          tooltip: 'Threshold B',
          label: unit.thresholdB.toString(),
          min: 64,
          max: 2048,
          divisions: (2048 - 64) ~/ 8,
          value: unit.thresholdB.toDouble(),
          onChanged: ref
              .read(txt2imgControlnetControllerProvider.notifier)
              .updateThresholdB,
        ),
      ],
    );
  }
}

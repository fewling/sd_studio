import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oktoast/oktoast.dart';

import '../../service/global_controller_providers.dart';
import '../../service/sd_response_provider.dart';
import '../../service/sd_service_provider.dart';
import '../../widgets/base_mobile_drawer_button.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/prompt_weight_drawer.dart';
import '../../widgets/txt2img_form.dart';
import 'txt2img_controlnet_window.dart';
import 'txt2img_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(txt2ImgStateControllerProvider.notifier);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const BaseMobileDrawerButton(),
          title: const Text('Home'),
          actions: const [
            ModelsPopupButton(),
            RefreshModelsButton(),
            EditHostIconButton(),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Text to Image',
                icon: Icon(Icons.text_fields_outlined),
              ),
              Tab(
                text: 'Image to Image',
                icon: Icon(Icons.image_outlined),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Txt2ImgView(),
            ),
            Text('Image to Image'),
          ],
        ),
        endDrawer: PromptWeightDrawer(
          prompt: ref
              .watch(promptStreamProvider)
              .maybeWhen(data: (prompt) => prompt, orElse: () => ''),
          negativePrompt: ref
              .watch(negPromptStreamProvider)
              .maybeWhen(data: (prompt) => prompt, orElse: () => ''),
          onPromptIncrease: notifier.increasePromptWeight,
          onPromptDecrease: notifier.decreasePromptWeight,
          onPromptDelete: notifier.deletePromptWeight,
          onNegativePromptIncrease: notifier.increaseNegPromptWeight,
          onNegativePromptDecrease: notifier.decreaseNegPromptWeight,
          onNegativePromptDelete: notifier.deleteNegPromptWeight,
        ),
        floatingActionButton: InferenceFAB(
          onPressed: notifier.inference,
        ),
      ),
    );
  }
}

class Txt2ImgView extends ConsumerWidget {
  const Txt2ImgView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(txt2ImgStateControllerProvider);
    final notifier = ref.watch(txt2ImgStateControllerProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        children: [
          Txt2ImgForm(
            onSortPrompt: Scaffold.of(context).openEndDrawer,
            onSortNegativePrompt: Scaffold.of(context).openEndDrawer,
            cfgScale: state.cfgScale,
            onCfgScaleChanged: notifier.updateGuidanceScale,
            steps: state.steps,
            onStepsChanged: notifier.updateNumInferenceSteps,
            batchSize: state.batchSize,
            onBatchSizeChanged: notifier.updateBatchSize,
            width: state.width,
            onWidthChanged: notifier.updateWidth,
            height: state.height,
            onHeightChanged: notifier.updateHeight,
          ),
          const SizedBox(height: 8),
          const Txt2ImgControlnetWindow(),
          const ResponseWindow(),
        ],
      ),
    );
  }
}

class ModelsPopupButton extends ConsumerWidget {
  const ModelsPopupButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modelsAsync = ref.watch(modelsProvider);

    return modelsAsync.when(
      data: (models) {
        final selectedModel = ref.watch(
          txt2ImgStateControllerProvider.select(
            (value) => value.selectedModel,
          ),
        );

        return PopupMenuButton(
          tooltip: 'Select model',
          icon: const Icon(Icons.design_services_outlined),
          itemBuilder: (context) => [
            for (final model in models)
              PopupMenuItem(
                value: model,
                enabled: model != selectedModel,
                child: Text(model.modelName),
                onTap: () => ref
                    .read(txt2ImgStateControllerProvider.notifier)
                    .selectModel(model),
              ),
          ],
        );
      },
      error: (e, s) => IconButton(
        onPressed: () => showToast('Failed to get models: $e',
            position: ToastPosition.bottom),
        icon: const Icon(Icons.error_outline),
      ),
      loading: () => const LoadingWidget(),
    );
  }
}

class RefreshModelsButton extends ConsumerWidget {
  const RefreshModelsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: 'Reconnect to server',
      onPressed: () {
        ref.invalidate(modelsProvider);
        ref.invalidate(controlnetUnitCountProvider);
      },
      icon: const Icon(Icons.refresh),
    );
  }
}

class EditHostIconButton extends ConsumerWidget {
  const EditHostIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: 'Edit Endpoint',
      onPressed: () => _editHostDialog(context, ref),
      icon: const Icon(Icons.language_outlined),
    );
  }

  void _editHostDialog(BuildContext context, WidgetRef ref) {
    var host = ref.read(txt2ImgStateControllerProvider).host;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.language_outlined),
        title: const Text('Update Endpoint'),
        content: EndpointField(
          onChanged: (v) => host = v,
          onSubmitted: (v) => _saveHost(context, ref, v),
        ),
        actions: [
          TextButton(
            onPressed: () => _saveHost(context, ref, host),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _saveHost(BuildContext context, WidgetRef ref, String host) {
    final notifier = ref.read(txt2ImgStateControllerProvider.notifier);
    notifier.updateHost(host).then((_) => context.pop());
  }
}

// TODO(@fewling): validation of the host url
class EndpointField extends ConsumerWidget {
  const EndpointField({
    super.key,
    this.onChanged,
    this.onSubmitted,
  });

  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final host =
        ref.watch(txt2ImgStateControllerProvider.select((value) => value.host));

    return TextFormField(
      initialValue: host,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      decoration: const InputDecoration(
        hintText: 'http://127.0.0.1:7860',
      ),
    );
  }
}

class ResponseWindow extends ConsumerWidget {
  const ResponseWindow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images =
        ref.watch(txt2ImgResponseControllerProvider.select((s) => s.images));

    if (images.isEmpty) return const SizedBox();

    return SizedBox(
      width: double.infinity,
      height: 512,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.memory(base64Decode(images[index])),
        ),
      ),
    );
  }
}

class InferenceFAB extends ConsumerWidget {
  const InferenceFAB({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInferring = ref.watch(
        txt2ImgStateControllerProvider.select((value) => value.isInferring));

    return FloatingActionButton(
      onPressed: isInferring ? null : onPressed,
      child: isInferring
          ? const CircularProgressIndicator()
          : const Icon(Icons.draw_rounded),
    );
  }
}

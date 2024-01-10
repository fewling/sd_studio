import 'package:oktoast/oktoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/sd/sd_model.dart';
import '../../models/sd/txt2img_request.dart';
import '../../models/sd/weighted_prompt.dart';
import '../../service/global_controller_providers.dart';
import '../../service/preference_provider.dart';
import '../../service/sd_response_provider.dart';
import '../../service/sd_service_provider.dart';
import '../../utils/app_logger.dart';
import 'txt2img_controlnet_notifier.dart';
import 'txt2img_state.dart';

part 'txt2img_notifier.g.dart';

@Riverpod(keepAlive: true)
class Txt2ImgStateController extends _$Txt2ImgStateController {
  @override
  Txt2ImgState build() {
    return Txt2ImgState(
      host: ref.watch(appPreferenceControllerProvider.select((s) => s.sdHost)),
    );
  }

  Future<void> updateHost(String host) async {
    await ref.read(appPreferenceControllerProvider.notifier).setSdHost(host);
  }

  void selectModel(SdModel? selectedModel) {
    state = state.copyWith(isInferring: true);
    ref
        .read(sdServiceProvider)
        .setModel(selectedModel)
        .then((value) => state = state.copyWith(
              isInferring: false,
              selectedModel: selectedModel,
            ));
  }

  void updateWidth(double size) {
    state = state.copyWith(width: size.toInt());
  }

  void updateHeight(double size) {
    state = state.copyWith(height: size.toInt());
  }

  void updateGuidanceScale(double value) {
    state = state.copyWith(cfgScale: value.toInt());
  }

  void updateNumInferenceSteps(double value) {
    state = state.copyWith(steps: value.toInt());
  }

  void updateBatchSize(double value) {
    state = state.copyWith(batchSize: value.toInt());
  }

  void increasePromptWeight(String prompt) {
    logger.d('increasePromptWeight: $prompt');
    final originalPrompt = ref.read(promptControllerProvider).text;

    final weightedPrompts = rawPromptToList(originalPrompt);

    final updatedPrompts = updatePromptWeight(weightedPrompts, prompt, 0.1);

    final newPrompt = updatedPrompts.map((e) {
      return e.weight == 1 ? e.prompt : '(${e.prompt.trim()}:${e.weight})';
    }).join(',');

    ref.read(promptControllerProvider).text = newPrompt;
  }

  void decreasePromptWeight(String prompt) {
    logger.d('decreasePromptWeight: $prompt');
    final originalPrompt = ref.read(promptControllerProvider).text;

    final weightedPrompts = rawPromptToList(originalPrompt);

    final updatedPrompts = updatePromptWeight(weightedPrompts, prompt, -0.1);

    final newPrompt = updatedPrompts.map((e) {
      return e.weight == 1 ? e.prompt : '(${e.prompt.trim()}:${e.weight})';
    }).join(',');

    ref.read(promptControllerProvider).text = newPrompt;
  }

  void deletePromptWeight(String prompt) {
    logger.d('deletePromptWeight: $prompt');
    final originalPrompt = ref.read(promptControllerProvider).text;

    final weightedPrompts = rawPromptToList(originalPrompt);

    final updatedPrompts = weightedPrompts.where((e) => e.prompt != prompt);

    final newPrompt = updatedPrompts.map((e) {
      return e.weight == 1 ? e.prompt : '(${e.prompt.trim()}:${e.weight})';
    }).join(',');

    ref.read(promptControllerProvider).text = newPrompt;
  }

  void increaseNegPromptWeight(String prompt) {
    logger.d('increaseNegPromptWeight: $prompt');
    final originalPrompt = ref.read(negPromptControllerProvider).text;

    final weightedPrompts = rawPromptToList(originalPrompt);

    final updatedPrompts = updatePromptWeight(weightedPrompts, prompt, 0.1);

    final newPrompt = updatedPrompts.map((e) {
      return e.weight == 1 ? e.prompt : '(${e.prompt.trim()}:${e.weight})';
    }).join(',');

    ref.read(negPromptControllerProvider).text = newPrompt;
  }

  void decreaseNegPromptWeight(String prompt) {
    logger.d('decreaseNegPromptWeight: $prompt');
    final originalPrompt = ref.read(negPromptControllerProvider).text;

    final weightedPrompts = rawPromptToList(originalPrompt);

    final updatedPrompts = updatePromptWeight(weightedPrompts, prompt, -0.1);

    final newPrompt = updatedPrompts.map((e) {
      return e.weight == 1 ? e.prompt : '(${e.prompt.trim()}:${e.weight})';
    }).join(',');

    ref.read(negPromptControllerProvider).text = newPrompt;
  }

  void deleteNegPromptWeight(String prompt) {
    logger.d('deleteNegPromptWeight: $prompt');
    final originalPrompt = ref.read(negPromptControllerProvider).text;

    final weightedPrompts = rawPromptToList(originalPrompt);

    final updatedPrompts = weightedPrompts.where((e) => e.prompt != prompt);

    final newPrompt = updatedPrompts.map((e) {
      return e.weight == 1 ? e.prompt : '(${e.prompt.trim()}:${e.weight})';
    }).join(',');

    ref.read(negPromptControllerProvider).text = newPrompt;
  }

  List<WeightedPrompt> rawPromptToList(String prompt) {
    final splicedPrompt = prompt.split(',');

    /// Convert each prompt to [WeightedPrompt]
    final weightedPrompts = splicedPrompt.map((e) {
      if (!e.contains(':')) {
        return WeightedPrompt(prompt: e, weight: 1);
      }

      final parts = e.split(':');
      return WeightedPrompt(
        prompt: parts[0].replaceFirst('(', ''),
        weight: double.tryParse(parts[1].replaceFirst(')', '')) ?? 1,
      );
    }).toList();

    return weightedPrompts;
  }

  List<WeightedPrompt> updatePromptWeight(
    List<WeightedPrompt> weightedPrompts,
    String prompt,
    double change,
  ) {
    final idx = weightedPrompts.indexWhere((e) => e.prompt == prompt);
    if (idx == -1) {
      final p = WeightedPrompt(prompt: prompt, weight: 1);
      weightedPrompts.add(p);
    } else {
      final wStr = (weightedPrompts[idx].weight + change).toStringAsFixed(2);
      final weight = double.parse(wStr);
      weightedPrompts[idx] = weightedPrompts[idx].copyWith(weight: weight);
    }

    // weightedPrompts.sort((a, b) => b.weight.compareTo(a.weight));
    return weightedPrompts;
  }

  Future<void> inference() async {
    final prompt = ref.read(promptControllerProvider).text;
    final negPrompt = ref.read(negPromptControllerProvider).text;
    final model = state.selectedModel;

    if (model == null) {
      logger.e('No model selected');
      showToast('No model selected', position: ToastPosition.bottom);
      return;
    }

    // Check if any controlnet is enabled
    final controlnetRequest = ref
        .read(txt2imgControlnetControllerProvider.notifier)
        .controlnetRequest();

    // TODO(@fewling): use override_settings to set the model
    // TODO(@fewling): Show menu to select sampler
    final request = Txt2ImgRequest(
      prompt: prompt,
      negativePrompt: negPrompt,
      samplerName: 'DPM++ 2S a Karras',
      batchSize: state.batchSize,
      cfgScale: state.cfgScale,
      height: state.height,
      width: state.width,
      steps: state.steps,
      alwaysOnScripts: controlnetRequest == null
          ? null
          : AlwaysOnScripts(controlnet: controlnetRequest),
    );

    state = state.copyWith(isInferring: true);

    try {
      await ref
          .read(txt2ImgResponseControllerProvider.notifier)
          .inference(request);
      state = state.copyWith(isInferring: false);
    } catch (e) {
      logger.e(e);
      state = state.copyWith(isInferring: false);
      showToast('Error: $e', position: ToastPosition.bottom);
    }
  }
}

import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/sd/controlnet_detect_request.dart';
import '../../models/sd/controlnet_request.dart';
import '../../service/sd_service_provider.dart';
import '../../utils/app_logger.dart';
import 'txt2img_controlnet_state.dart';

part 'txt2img_controlnet_notifier.g.dart';

@Riverpod(keepAlive: true)
class Txt2imgControlnetController extends _$Txt2imgControlnetController {
  @override
  Future<Txt2imgControlnetState> build() async {
    final units = await getControlnetUnitCount();
    final processedImages = List.generate(units?.length ?? 0, (_) => null);

    return Txt2imgControlnetState(
      controlnetUnits: units ?? <ControlNetUnit>[],
      processedImages: processedImages,
    );
  }

  Future<List<ControlNetUnit>?> getControlnetUnitCount() async {
    logger.d('getControlnetUnitCount');
    final count = await ref.read(controlnetUnitCountProvider.future);

    final controlnetUnits = List.generate(
      count,
      (index) => const ControlNetUnit(),
    );

    return controlnetUnits;
  }

  void selectControlnetUnit(Set<int> unitIndex) {
    logger.d('selectControlnetUnit: $unitIndex');

    final prevState = state.valueOrNull;
    if (prevState == null) return;

    state = AsyncData(prevState.copyWith(selectedIndexes: unitIndex));
  }

  void selectControlnetModel(String? value) {
    logger.d('selectControlnetModel: $value');

    final prevState = state.valueOrNull;
    if (prevState == null) return;

    final currentIdx = prevState.selectedIndexes.first;
    final currentUnit = prevState.controlnetUnits[currentIdx];
    final newUnits = [...prevState.controlnetUnits];
    newUnits[currentIdx] = currentUnit.copyWith(model: value);

    state = AsyncData(prevState.copyWith(controlnetUnits: newUnits));
  }

  void toggleCurrentControlnetUnit(bool value) {
    logger.d('toggleCurrentControlnetUnit: $value');

    final prevState = state.valueOrNull;
    if (prevState == null) return;

    final currentIdx = prevState.selectedIndexes.first;
    final enabledIndexes = {...prevState.enabledIndexes};
    enabledIndexes.contains(currentIdx)
        ? enabledIndexes.remove(currentIdx)
        : enabledIndexes.add(currentIdx);
    state = AsyncData(prevState.copyWith(enabledIndexes: enabledIndexes));
  }

  Future<void> uploadControlnetImage() async {
    logger.d('uploadControlnetImage');

    final prevState = state.valueOrNull;
    if (prevState == null) return;

    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img == null) return;

    final bytes = await img.readAsBytes();
    final b64 = base64Encode(bytes);

    final currentIdx = prevState.selectedIndexes.first;
    final currentUnit = prevState.controlnetUnits[currentIdx];
    final newUnits = [...prevState.controlnetUnits];
    newUnits[currentIdx] = currentUnit.copyWith(inputImage: b64);

    state = AsyncData(prevState.copyWith(controlnetUnits: newUnits));
  }

  void selectControlnetModule(String? value) {
    logger.d('selectControlnetModule: $value');

    final prevState = state.valueOrNull;
    if (prevState == null) return;

    final currentIdx = prevState.selectedIndexes.first;
    final currentUnit = prevState.controlnetUnits[currentIdx];
    final newUnits = [...prevState.controlnetUnits];
    newUnits[currentIdx] = currentUnit.copyWith(module: value);

    state = AsyncData(prevState.copyWith(controlnetUnits: newUnits));
  }

  /// Parse the current state to [ControlNetUnitRequest].\
  /// If the current state is not valid, return null.\
  /// If no controlnet unit is enabled, return null.
  ControlNetUnitRequest? controlnetRequest() {
    final value = state.valueOrNull;
    if (value == null) return null;

    final enabledIndexes = value.enabledIndexes;
    if (enabledIndexes.isEmpty) return null;

    final enabledUnits = value.controlnetUnits
        .asMap()
        .entries
        .where((e) => enabledIndexes.contains(e.key))
        .map((e) => e.value)
        .toList();

    return ControlNetUnitRequest(args: enabledUnits);
  }

  Future<String?> processControlnet() async {
    final value = state.valueOrNull;
    if (value == null) return 'Invalid state';

    final index = value.selectedIndexes.first;
    final unit = value.controlnetUnits[index];
    if (unit.inputImage == null) return 'Input image is null';
    if (unit.module == null) return 'Module is null';

    final request = ControlnetDetectRequest(
      controlnetInputImages: [unit.inputImage!],
      controlnetModule: unit.module!,
      controlnetProcessorRes: unit.processorRes,
      controlnetThresholdA: unit.thresholdA,
      controlnetThresholdB: unit.thresholdB,
    );

    final resp = await ref.read(sdServiceProvider).preprocess(request);

    final processedImages = [...value.processedImages];
    processedImages[index] = resp.images.first;

    state = AsyncData(value.copyWith(processedImages: processedImages));
    return null;
  }

  void updateProcessorRes(double value) {
    final prevState = state.valueOrNull;
    if (prevState == null) return;

    final currentIdx = prevState.selectedIndexes.first;
    final currentUnit = prevState.controlnetUnits[currentIdx];
    final newUnits = [...prevState.controlnetUnits];
    newUnits[currentIdx] = currentUnit.copyWith(processorRes: value.toInt());

    state = AsyncData(prevState.copyWith(controlnetUnits: newUnits));
  }

  void updateThresholdA(double value) {
    final prevState = state.valueOrNull;
    if (prevState == null) return;

    final currentIdx = prevState.selectedIndexes.first;
    final currentUnit = prevState.controlnetUnits[currentIdx];
    final newUnits = [...prevState.controlnetUnits];
    newUnits[currentIdx] = currentUnit.copyWith(thresholdA: value.toInt());

    state = AsyncData(prevState.copyWith(controlnetUnits: newUnits));
  }

  void updateThresholdB(double value) {
    final prevState = state.valueOrNull;
    if (prevState == null) return;

    final currentIdx = prevState.selectedIndexes.first;
    final currentUnit = prevState.controlnetUnits[currentIdx];
    final newUnits = [...prevState.controlnetUnits];
    newUnits[currentIdx] = currentUnit.copyWith(thresholdB: value.toInt());

    state = AsyncData(prevState.copyWith(controlnetUnits: newUnits));
  }
}

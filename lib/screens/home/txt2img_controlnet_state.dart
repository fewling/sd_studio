import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/sd/controlnet_request.dart';

part 'txt2img_controlnet_state.freezed.dart';

@freezed
class Txt2imgControlnetState with _$Txt2imgControlnetState {
  const factory Txt2imgControlnetState({
    /// Lists of control net units state for each model
    @Default(<ControlNetUnit>[]) List<ControlNetUnit> controlnetUnits,

    /// Lists of processed input images for each model
    @Default(<String?>[]) List<String?> processedImages,

    /// Selected control net unit index
    @Default({}) Set<int> selectedIndexes,

    /// Enabled control net unit index
    @Default({}) Set<int> enabledIndexes,
  }) = _Txt2imgControlnetState;
}

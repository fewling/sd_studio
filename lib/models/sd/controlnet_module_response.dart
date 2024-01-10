import 'package:freezed_annotation/freezed_annotation.dart';

part 'controlnet_module_response.freezed.dart';
part 'controlnet_module_response.g.dart';

@freezed
class ControlnetModule with _$ControlnetModule {
  const factory ControlnetModule({
    @JsonKey(name: 'module_list') required List<String> moduleList,
    @JsonKey(name: 'module_detail') required ModuleDetail moduleDetail,
  }) = _ControlnetModule;

  factory ControlnetModule.fromJson(Map<String, dynamic> json) =>
      _$ControlnetModuleFromJson(json);
}

@freezed
class ModuleDetail with _$ModuleDetail {
  const factory ModuleDetail({
    ControlnetModuleConfig? none,
    ControlnetModuleConfig? canny,
    ControlnetModuleConfig? depth,
    ControlnetModuleConfig? depthLeres,
    ControlnetModuleConfig? moduleDetailDepthLeres,
    ControlnetModuleConfig? hed,
    ControlnetModuleConfig? hedSafe,
    ControlnetModuleConfig? mediapipeFace,
    ControlnetModuleConfig? mlsd,
    ControlnetModuleConfig? normalMap,
    ControlnetModuleConfig? openpose,
    ControlnetModuleConfig? openposeHand,
    ControlnetModuleConfig? openposeFace,
    ControlnetModuleConfig? openposeFaceonly,
    ControlnetModuleConfig? openposeFull,
    ControlnetModuleConfig? dwOpenposeFull,
    ControlnetModuleConfig? animalOpenpose,
    ControlnetModuleConfig? clipVision,
    ControlnetModuleConfig? revisionClipvision,
    ControlnetModuleConfig? revisionIgnorePrompt,
    ControlnetModuleConfig? ipAdapterClipSd15,
    ControlnetModuleConfig? ipAdapterClipSdxlPlusVith,
    ControlnetModuleConfig? ipAdapterClipSdxl,
    ControlnetModuleConfig? color,
    ControlnetModuleConfig? pidinet,
    ControlnetModuleConfig? pidinetSafe,
    ControlnetModuleConfig? pidinetSketch,
    ControlnetModuleConfig? pidinetScribble,
    ControlnetModuleConfig? scribbleXdog,
    ControlnetModuleConfig? scribbleHed,
    ControlnetModuleConfig? segmentation,
    ControlnetModuleConfig? threshold,
    ControlnetModuleConfig? depthZoe,
    ControlnetModuleConfig? normalBae,
    ControlnetModuleConfig? oneformerCoco,
    ControlnetModuleConfig? oneformerAde20K,
    ControlnetModuleConfig? lineart,
    ControlnetModuleConfig? lineartCoarse,
    ControlnetModuleConfig? lineartAnime,
    ControlnetModuleConfig? lineartStandard,
    ControlnetModuleConfig? shuffle,
    ControlnetModuleConfig? tileResample,
    ControlnetModuleConfig? invert,
    ControlnetModuleConfig? lineartAnimeDenoise,
    ControlnetModuleConfig? referenceOnly,
    ControlnetModuleConfig? referenceAdain,
    ControlnetModuleConfig? referenceAdainAttn,
    ControlnetModuleConfig? inpaint,
    ControlnetModuleConfig? inpaintOnly,
    ControlnetModuleConfig? inpaintOnlyLama,
    ControlnetModuleConfig? tileColorfix,
    ControlnetModuleConfig? tileColorfixSharp,
    ControlnetModuleConfig? recolorLuminance,
    ControlnetModuleConfig? recolorIntensity,
    ControlnetModuleConfig? blurGaussian,
    ControlnetModuleConfig? animeFaceSegment,
  }) = _ModuleDetail;

  factory ModuleDetail.fromJson(Map<String, dynamic> json) =>
      _$ModuleDetailFromJson(json);
}

@freezed
class ControlnetModuleConfig with _$ControlnetModuleConfig {
  const factory ControlnetModuleConfig({
    @JsonKey(name: 'model_free') required bool modelFree,
    @JsonKey(name: 'sliders') required List<ControlnetModuleSlider> sliders,
  }) = _ModuleConfig;

  factory ControlnetModuleConfig.fromJson(Map<String, dynamic> json) =>
      _$ControlnetModuleConfigFromJson(json);
}

@freezed
class ControlnetModuleSlider with _$ControlnetModuleSlider {
  const factory ControlnetModuleSlider({
    required String name,
    required num min,
    required num max,
    required num value,
    double? step,
  }) = _ControlnetModuleSlider;

  factory ControlnetModuleSlider.fromJson(Map<String, dynamic> json) =>
      _$ControlnetModuleSliderFromJson(json);
}

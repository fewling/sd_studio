import 'package:freezed_annotation/freezed_annotation.dart';

part 'controlnet_request.freezed.dart';
part 'controlnet_request.g.dart';

@freezed
class ControlNetUnitRequest with _$ControlNetUnitRequest {
  const factory ControlNetUnitRequest({
    @Default(<ControlNetUnit>[]) List<ControlNetUnit> args,
  }) = _ControlNetUnitRequest;

  factory ControlNetUnitRequest.fromJson(Map<String, dynamic> json) =>
      _$ControlNetUnitRequestFromJson(json);
}

@freezed
class ControlNetUnit with _$ControlNetUnit {
  const factory ControlNetUnit({
    /// image to use in this unit. defaults to null
    /// base64 encoded image
    @JsonKey(name: 'input_image') String? inputImage,

    /// mask pixel_perfect to filter the image. defaults to null
    String? mask,

    /// preprocessor to use on the image passed to this unit
    /// before using it for conditioning.
    /// Accepts values returned by the `/controlnet/module_list` route.
    /// Defaults to "none"
    String? module,

    /// Name of the model to use for conditioning in this unit.
    /// Accepts values returned by the /controlnet/model_list route.
    /// Defaults to "None"
    String? model,

    /// weight of this unit. defaults to 1
    @Default(1.0) num weight,

    /// How to resize the input image so as to fit the output resolution of the generation.
    /// Defaults to "Scale to Fit (Inner Fit)". Accepted values:
    /// 0 or "Just Resize" : simply resize the image to the target width/height
    /// 1 or "Scale to Fit (Inner Fit)" : scale and crop to fit smallest dimension. preserves proportions.
    /// 2 or "Envelope (Outer Fit)" : scale to fit largest dimension. preserves proportions.
    @JsonKey(name: 'resize_mode') @Default(1) int resizeMode,

    /// whether to compensate low GPU memory with processing time.
    /// Defaults to false
    @Default(false) bool lowvram,

    /// Resolution of the preprocessor. defaults to 64
    /// Range from 64 ~ 2048
    @JsonKey(name: 'processor_res') @Default(64) int processorRes,

    /// first parameter of the preprocessor.
    /// Only takes effect when preprocessor accepts arguments.
    /// Defaults to 64
    @JsonKey(name: 'threshold_a') @Default(64) int thresholdA,

    /// Second parameter of the preprocessor, same as above for usage.
    /// Defaults to 64
    @JsonKey(name: 'threshold_b') @Default(64) int thresholdB,

    /// Ratio of generation where this unit starts to have an effect.
    /// Defaults to 0.0
    @JsonKey(name: 'guidance_start') @Default(0.0) double guidanceStart,

    /// Ratio of generation where this unit stops to have an effect.
    /// Defaults to 1.0
    @JsonKey(name: 'guidance_end') @Default(1.0) double guidanceEnd,

    /// See the related issue(https://github.com/Mikubill/sd-webui-controlnet/issues/1011)
    /// for usage. defaults to 0. Accepted values:
    /// 0 or "Balanced" : balanced, no preference between prompt and control model
    /// 1 or "My prompt is more important" : the prompt has more impact than the model
    /// 2 or "ControlNet is more important" : the controlnet model has more impact than the prompt
    @JsonKey(name: 'control_mode') @Default(0) int controlMode,

    /// Enable pixel-perfect preprocessor.
    /// Defaults to false
    @JsonKey(name: 'pixel_perfect') @Default(false) bool pixelPerfect,
  }) = _ControlNetUnit;

  factory ControlNetUnit.fromJson(Map<String, dynamic> json) =>
      _$ControlNetUnitFromJson(json);
}

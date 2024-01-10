// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/sd/sd_model.dart';
import '../../../models/sd/sd_sampler.dart';

part 'txt2img_state.freezed.dart';
part 'txt2img_state.g.dart';

@freezed
class Txt2ImgState with _$Txt2ImgState {
  const factory Txt2ImgState({
    @Default('http://127.0.0.1:7860/') String host,
    @Default(<SdModel>[]) List<SdModel> sdModels,
    @Default(null) SdModel? selectedModel,
    @Default(null) SdSampler? selectedSampler,

    /// How many diffusion steps to take to generate image
    /// (more is better generally, with diminishing returns after 50)
    @Default(50) int steps,

    /// How strong the effect of the prompt is on the generated image
    @JsonKey(name: 'cfg_scale') @Default(7) int cfgScale,

    /// How many images to generate in this run
    @JsonKey(name: 'batch_size') @Default(1) int batchSize,

    /// Width of generated image
    @Default(512) int width,

    /// Height of generated image
    @Default(512) int height,

    /// Whether the model is currently inferring
    @Default(false) bool isInferring,
  }) = _Txt2ImgState;

  factory Txt2ImgState.fromJson(Map<String, dynamic> json) =>
      _$Txt2ImgStateFromJson(json);
}

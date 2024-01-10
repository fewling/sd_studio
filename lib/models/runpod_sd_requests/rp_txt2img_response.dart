// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/constants.dart';
import '../sd/txt2img_request.dart';

part 'rp_txt2img_response.freezed.dart';
part 'rp_txt2img_response.g.dart';

@freezed
class RunpodTxt2ImgResponse with _$RunpodTxt2ImgResponse {
  const factory RunpodTxt2ImgResponse({
    required String id,
    @JsonKey(fromJson: statusFromJson, toJson: statusToJson)
    required RunPodResponseStatus status,
    int? delayTime,
    int? executionTime,
    Txt2ImgOutput? output,
  }) = _RunpodTxt2ImgResponse;

  factory RunpodTxt2ImgResponse.fromJson(Map<String, dynamic> json) =>
      _$RunpodTxt2ImgResponseFromJson(json);
}

@freezed
class Txt2ImgOutput with _$Txt2ImgOutput {
  const factory Txt2ImgOutput({
    /// List of base64 encoded images
    required List<String> images,
    required String info,

    /// Request used to generate this response
    required Txt2ImgRequest parameters,
  }) = _Txt2ImgOutput;

  factory Txt2ImgOutput.fromJson(Map<String, dynamic> json) =>
      _$Txt2ImgOutputFromJson(json);
}

@freezed
class Txt2ImgOutputInfo with _$Txt2ImgOutputInfo {
  const factory Txt2ImgOutputInfo({
    required String prompt,
    @JsonKey(name: 'all_prompts') required List<String> allPrompts,
    @JsonKey(name: 'negative_prompt') required String negativePrompt,
    @JsonKey(name: 'all_negative_prompts')
    required List<String> allNegativePrompts,
    required int seed,
    @JsonKey(name: 'all_seeds') required List<int> allSeeds,
    required int subseed,
    @JsonKey(name: 'all_subseeds') required List<int> allSubseeds,
    @JsonKey(name: 'subseed_strength') required num subseedStrength,
    required int width,
    required int height,
    @JsonKey(name: 'sampler_name') required String samplerName,
    @JsonKey(name: 'cfg_scale') required double cfgScale,
    required int steps,
    @JsonKey(name: 'batch_size') required int batchSize,
    @JsonKey(name: 'sd_model_hash') required String sdModelHash,
    @JsonKey(name: 'job_timestamp') required String jobTimestamp,
    @JsonKey(name: 'restore_faces') @Default(false) bool restoreFaces,
    @JsonKey(name: 'face_restoration_model')
    @Default(null)
    Object? faceRestorationModel,
    @JsonKey(name: 'seed_resize_from_w') @Default(-1) int seedResizeFromW,
    @JsonKey(name: 'seed_resize_from_h') @Default(-1) int seedResizeFromH,
    @JsonKey(name: 'denoising_strength') @Default(0.0) double denoisingStrength,
    @JsonKey(name: 'extra_generation_params')
    @Default({})
    Map<String, dynamic> extraGenerationParams,
    @JsonKey(name: 'index_of_first_image') @Default(0) int indexOfFirstImage,
    @Default(<String>[]) List<String> infotexts,
    @Default(<String>[]) List<String> styles,
    @JsonKey(name: 'clip_skip') @Default(1) int clipSkip,
    @JsonKey(name: 'is_using_inpainting_conditioning')
    @Default(false)
    bool isUsingInpaintingConditioning,
  }) = _Txt2ImgOutputInfo;

  factory Txt2ImgOutputInfo.fromJson(Map<String, dynamic> json) =>
      _$Txt2ImgOutputInfoFromJson(json);
}

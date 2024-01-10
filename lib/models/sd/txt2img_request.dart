// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'controlnet_request.dart';

part 'txt2img_request.freezed.dart';
part 'txt2img_request.g.dart';

@freezed
class Txt2ImgRequest with _$Txt2ImgRequest {
  const factory Txt2ImgRequest({
    /// Desired elements of the image.
    required String prompt,

    /// Undesired elements of the image.
    @JsonKey(name: 'negative_prompt') @Default('') String negativePrompt,

    /// Stored prompts, get names from [SdStyle].
    @Default(<String>[]) List<String> styles,

    /// We can re-use the value to make it repeatable
    @Default(-1) int seed,

    /// Add variation to the existing seed.
    @Default(-1) int subseed,

    /// Strength of the variation.
    @JsonKey(name: 'subseed_strength') @Default(0) int subseedStrength,

    /// generate as if using the seed generating at different resolution
    @JsonKey(name: 'seed_resize_from_h') @Default(-1) int seedResizeFromH,

    /// generate as if using the seed generating at different resolution
    @JsonKey(name: 'seed_resize_from_w') @Default(-1) int seedResizeFromW,

    /// Which sampler model, e.g. DPM++ 2M Karras or UniPC. See [Sampler].
    @JsonKey(name: 'sampler_name') @Default('Euler') String samplerName,

    /// How many images to generate in this run
    @JsonKey(name: 'batch_size') @Default(1) int batchSize,

    /// How many runs to generate images
    @JsonKey(name: 'n_iter') @Default(1) int nIter,

    /// How many diffusion steps to take to generate image
    /// (more is better generally, with diminishing returns after 50)
    @Default(50) int steps,

    /// How strong the effect of the prompt is on the generated image
    @JsonKey(name: 'cfg_scale') @Default(7) int cfgScale,

    /// Width of generated image
    @Default(512) int width,

    /// Height of generated image
    @Default(512) int height,

    /// Use GFPGAN to upscale faces generated
    @JsonKey(name: 'restore_faces') @Default(false) bool restoreFaces,

    /// Create a repeating pattern like a wallpaper
    @Default(false) bool tiling,

    ///
    @JsonKey(name: 'do_not_save_samples') @Default(false) bool doNotSaveSamples,

    ///
    @JsonKey(name: 'do_not_save_grid') @Default(false) bool doNotSaveGrid,

    /// a noise multiplier that affects certain samplers,
    /// changing the setting allows variations of the image
    /// at the same seed according to ClashSAN
    /// https://github.com/AUTOMATIC1111/stable-diffusion-webui/discussions/4079#discussioncomment-4022543
    @Default(0) int eta,

    /// how much noise to add to inputted image before reverse diffusion, only relevant in img2img scenarios
    @JsonKey(name: 'denoising_strength') @Default(0.0) double denoisingStrength,

    /// affects gamma, can make the outputs more or less stochastic by adding noise
    @JsonKey(name: 's_min_uncond') @Default(0) int sMinUncond,

    /// affects gamma
    @JsonKey(name: 's_churn') @Default(0) int sChurn,

    /// affects gamma
    @JsonKey(name: 's_tmax') @Default(0) int sTmax,

    /// affects gamma
    @JsonKey(name: 's_tmin') @Default(0) int sTmin,

    /// affects gamma
    @JsonKey(name: 's_noise') @Default(0) int sNoise,

    /// new default settings
    @JsonKey(name: 'override_settings')
    @Default(OverrideSettings())
    OverrideSettings overrideSettings,

    /// restore settings after running
    @JsonKey(name: 'override_settings_restore_afterwards')
    @Default(true)
    bool overrideSettingsRestoreAfterwards,

    /// disables hypernetworks and loras
    @JsonKey(name: 'disable_extra_networks')
    @Default(false)
    bool disableExtraNetworks,

    /// send output to be received in response
    @JsonKey(name: 'send_images') @Default(true) bool sendImages,

    /// save output to predesignated outputs destination
    @JsonKey(name: 'save_images') @Default(false) bool saveImages,

    /// extension requests (such as controlnet)
    @JsonKey(name: 'alwayson_scripts') AlwaysOnScripts? alwaysOnScripts,
  }) = _Txt2ImgRequest;

  factory Txt2ImgRequest.fromJson(Map<String, dynamic> json) =>
      _$Txt2ImgRequestFromJson(json);
}

@freezed
class OverrideSettings with _$OverrideSettings {
  const factory OverrideSettings({
    @JsonKey(name: 'sd_model_checkpoint') String? sdModelCheckpoint,
    @JsonKey(name: 'CLIP_stop_at_last_layers')
    @Default(2)
    int clipStopAtLastLayers,
  }) = _OverrideSettings;

  factory OverrideSettings.fromJson(Map<String, dynamic> json) =>
      _$OverrideSettingsFromJson(json);
}

@freezed
class AlwaysOnScripts with _$AlwaysOnScripts {
  const factory AlwaysOnScripts({
    ControlNetUnitRequest? controlnet,
  }) = _AlwaysOnScripts;

  factory AlwaysOnScripts.fromJson(Map<String, dynamic> json) =>
      _$AlwaysOnScriptsFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sd_sampler.freezed.dart';
part 'sd_sampler.g.dart';

@freezed
class SdSampler with _$SdSampler {
  const factory SdSampler({
    required String name,
    // @Default(<String>[]) List<String> aliases,
    // @Default(<String, dynamic>{}) Map<String, dynamic> options,
  }) = _SdSampler;

  factory SdSampler.fromJson(Map<String, dynamic> json) =>
      _$SdSamplerFromJson(json);
}

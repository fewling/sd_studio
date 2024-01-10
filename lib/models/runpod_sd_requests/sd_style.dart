import 'package:freezed_annotation/freezed_annotation.dart';

part 'sd_style.freezed.dart';
part 'sd_style.g.dart';

@freezed
class SdStyle with _$SdStyle {
  const factory SdStyle({
    required String name,
    required String prompt,
    required String negativePrompt,
  }) = _SdStyle;

  factory SdStyle.fromJson(Map<String, dynamic> json) =>
      _$SdStyleFromJson(json);
}

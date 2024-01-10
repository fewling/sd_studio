import 'package:freezed_annotation/freezed_annotation.dart';

part 'txt2img_response.freezed.dart';
part 'txt2img_response.g.dart';

@freezed
class Txt2ImgResponse with _$Txt2ImgResponse {
  const factory Txt2ImgResponse({
    @Default(<String>[]) List<String> images,
    @Default(<String, dynamic>{}) Map<String, dynamic> parameters,
    @Default('') String info,
  }) = _Txt2ImgResponse;

  factory Txt2ImgResponse.fromJson(Map<String, dynamic> json) =>
      _$Txt2ImgResponseFromJson(json);
}

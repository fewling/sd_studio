import 'package:freezed_annotation/freezed_annotation.dart';

part 'controlnet_detect_response.freezed.dart';
part 'controlnet_detect_response.g.dart';

@freezed
class ControlnetDetectResponse with _$ControlnetDetectResponse {
  const factory ControlnetDetectResponse({
    @Default(<String>[]) List<String> images,
    @Default('') String info,
  }) = _ControlnetDetectResponse;

  factory ControlnetDetectResponse.fromJson(Map<String, dynamic> json) =>
      _$ControlnetDetectResponseFromJson(json);
}

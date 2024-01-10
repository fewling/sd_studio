// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'controlnet_model_response.freezed.dart';
part 'controlnet_model_response.g.dart';

@freezed
class ControlnetModelResponse with _$ControlnetModelResponse {
  const factory ControlnetModelResponse({
    @JsonKey(name: 'model_list') @Default(<String>[]) List<String> models,
  }) = _ControlnetModelResponse;

  factory ControlnetModelResponse.fromJson(Map<String, dynamic> json) =>
      _$ControlnetModelResponseFromJson(json);
}

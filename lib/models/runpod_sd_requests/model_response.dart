// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/constants.dart';

part 'model_response.freezed.dart';
part 'model_response.g.dart';

@freezed
class ModelResponse with _$ModelResponse {
  const factory ModelResponse({
    required String id,
    @JsonKey(fromJson: statusFromJson, toJson: statusToJson)
    required RunPodResponseStatus status,
    int? delayTime,
    int? executionTime,
    List<ModelOutput>? output,
  }) = _ModelResponse;

  factory ModelResponse.fromJson(Map<String, dynamic> json) =>
      _$ModelResponseFromJson(json);
}

@freezed
class ModelOutput with _$ModelOutput {
  const factory ModelOutput({
    @JsonKey(name: 'model_name') required String modelName,
    required String filename,
    required String title,
  }) = _ModelOutput;

  factory ModelOutput.fromJson(Map<String, dynamic> json) =>
      _$ModelOutputFromJson(json);
}

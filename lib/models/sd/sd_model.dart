// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'sd_model.freezed.dart';
part 'sd_model.g.dart';

@freezed
class SdModel with _$SdModel {
  const factory SdModel({
    @JsonKey(name: 'model_name') required String modelName,
    required String title,
    String? hash,
    String? sha256,
    String? filename,
    Object? config,
  }) = _SdModel;

  factory SdModel.fromJson(Map<String, dynamic> json) =>
      _$SdModelFromJson(json);
}

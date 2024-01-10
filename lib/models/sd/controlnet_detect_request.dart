import 'package:freezed_annotation/freezed_annotation.dart';

part 'controlnet_detect_request.freezed.dart';
part 'controlnet_detect_request.g.dart';

@freezed
class ControlnetDetectRequest with _$ControlnetDetectRequest {
  const factory ControlnetDetectRequest({
    @JsonKey(name: 'controlnet_module')
    @Default('none')
    String controlnetModule,
    @JsonKey(name: 'controlnet_input_images')
    @Default(<String>[])
    List<String> controlnetInputImages,
    @JsonKey(name: 'controlnet_processor_res')
    @Default(512)
    num controlnetProcessorRes,
    @JsonKey(name: 'controlnet_threshold_a')
    @Default(100)
    num controlnetThresholdA,
    @JsonKey(name: 'controlnet_threshold_b')
    @Default(200)
    num controlnetThresholdB,
  }) = _ControlnetDetectRequest;

  factory ControlnetDetectRequest.fromJson(Map<String, dynamic> json) =>
      _$ControlnetDetectRequestFromJson(json);
}

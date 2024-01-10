import 'package:freezed_annotation/freezed_annotation.dart';

part 'weighted_prompt.freezed.dart';

@freezed
class WeightedPrompt with _$WeightedPrompt {
  const factory WeightedPrompt({
    required String prompt,
    required double weight,
  }) = _WeightedPrompt;
}

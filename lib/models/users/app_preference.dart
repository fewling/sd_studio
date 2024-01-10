import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_preference.freezed.dart';

@freezed
class AppPreference with _$AppPreference {
  const factory AppPreference({
    required int colorSchemeSeed,
    required String sdHost,
    @Default(false) bool isDarkMode,
  }) = _AppPreference;
}

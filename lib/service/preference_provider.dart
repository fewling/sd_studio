import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/users/app_preference.dart';

part 'preference_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPref(SharedPrefRef ref) {
  throw UnimplementedError();
}

@Riverpod(keepAlive: true)
class AppPreferenceController extends _$AppPreferenceController {
  static const colorSchemeKey = 'color scheme';
  static const isDarkModeKey = 'dark mode';
  static const sdHostKey = 'local sd host';

  @override
  AppPreference build() {
    final sp = ref.watch(sharedPrefProvider);
    final colorSeed = sp.getInt(colorSchemeKey) ?? Colors.green.value;
    final isDarkMode = sp.getBool(isDarkModeKey) ?? false;
    final host = sp.getString(sdHostKey) ?? 'http://127.0.0.1:7860';

    return AppPreference(
      colorSchemeSeed: colorSeed,
      isDarkMode: isDarkMode,
      sdHost: host,
    );
  }

  void setColorSchemeSeed(int colorValue) {
    final sp = ref.read(sharedPrefProvider);
    sp.setInt(colorSchemeKey, colorValue).then((success) {
      if (success) {
        state = state.copyWith(colorSchemeSeed: colorValue);
      }
    });
  }

  void toggleBrightness() {
    final isDark = state.isDarkMode;

    ref
        .read(sharedPrefProvider)
        .setBool(isDarkModeKey, !isDark)
        .then((value) => state = state.copyWith(isDarkMode: !isDark));
  }

  Future<bool> setSdHost(String host) async {
    final saved = await ref.read(sharedPrefProvider).setString(sdHostKey, host);

    if (saved) {
      state = state.copyWith(sdHost: host);
    }

    return saved;
  }
}

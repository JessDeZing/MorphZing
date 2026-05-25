import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum ThemeModeType {
  system,
  light,
  dark,
}

class ThemeService extends GetxService {
  static final _box = GetStorage();
  static const String _key = 'themeMode';

  static ThemeModeType get themeModeType {
    final value = _box.read(_key);
    if (value == null) return ThemeModeType.system;
    return ThemeModeType.values.firstWhere(
      (e) => e.toString() == value,
      orElse: () => ThemeModeType.system,
    );
  }

  static bool isDarkMode(BuildContext context) {
    switch (themeModeType) {
      case ThemeModeType.light:
        return false;
      case ThemeModeType.dark:
        return true;
      case ThemeModeType.system:
        // Get the actual system brightness
        final brightness = MediaQuery.of(context).platformBrightness;
        return brightness == Brightness.dark;
    }
  }

  static ThemeMode get themeMode {
    switch (themeModeType) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
      case ThemeModeType.system:
        return ThemeMode.system;
    }
  }

  static void setThemeMode(ThemeModeType mode) {
    _box.write(_key, mode.toString());
    Get.changeThemeMode(themeMode);
  }

  static void toggleTheme() {
    final currentMode = themeModeType;
    ThemeModeType newMode;

    switch (currentMode) {
      case ThemeModeType.system:
        newMode = ThemeModeType.light;
        break;
      case ThemeModeType.light:
        newMode = ThemeModeType.dark;
        break;
      case ThemeModeType.dark:
        newMode = ThemeModeType.system;
        break;
    }

    setThemeMode(newMode);
  }

  // Helper method to get the actual theme mode considering system preference
  static ThemeMode getEffectiveThemeMode(BuildContext context) {
    if (themeModeType == ThemeModeType.system) {
      final brightness = MediaQuery.of(context).platformBrightness;
      return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    }
    return themeMode;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// To-Do colors. Follows the phone's light/dark setting.
/// Dark values are the original To-Do colors (unchanged).
class TodoColors {
  TodoColors._();

  static bool get _dark => Get.isDarkMode;

  static const Color accent = Color(0xFF7C4DFF);

  static Color get bg => _dark ? const Color(0xFF0F0F0F) : const Color(0xFFF4F3F8);
  static Color get sheet => _dark ? const Color(0xFF1A1A1A) : const Color(0xFFFFFFFF);
  static Color get card => _dark ? const Color(0xFF1C1C1C) : const Color(0xFFFFFFFF);
  static Color get field => _dark ? const Color(0xFF252525) : const Color(0xFFEFEEF4);
  static Color get chip => _dark ? const Color(0xFF2A2A2A) : const Color(0xFFE6E4EE);
  static Color get noColor => _dark ? const Color(0xFF333333) : const Color(0xFFD9D7E2);
  static Color get text => _dark ? Colors.white : const Color(0xFF050A41);
  static Color get text70 => _dark ? Colors.white70 : const Color(0xFF4A4D6E);
  static Color get text54 => _dark ? Colors.white54 : const Color(0xFF676A8B);
  static Color get hint => _dark ? Colors.white38 : const Color(0xFF9A9CB3);
  static Color get subtle => _dark ? Colors.white30 : const Color(0xFFA3A1B8);
  static Color get faint => _dark ? Colors.white24 : const Color(0xFFB5B3C6);
  static Color get line => _dark ? Colors.white12 : const Color(0xFFD5D4DF);
  static Color get done => _dark ? Colors.greenAccent : const Color(0xFF2E9E5B);

  static ThemeData get pickerTheme => _dark
      ? ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark(primary: accent))
      : ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: accent));
}

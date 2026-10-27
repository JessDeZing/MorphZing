import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Calm Corner colors. Follows the phone's light/dark setting.
class CalmColors {
  CalmColors._();

  static bool get _dark => Get.isDarkMode;

  static Color get bg => _dark ? const Color(0xFF1A1F30) : const Color(0xFFF4F2FA);
  static Color get surface => _dark ? const Color(0xFF141828) : const Color(0xFFFFFFFF);
  static Color get border => _dark ? const Color(0xFF252A3A) : const Color(0xFFE3E0EE);
  static Color get title => _dark ? const Color(0xFFECEAF8) : const Color(0xFF1E1B3A);
  static Color get body => _dark ? const Color(0xFF8A8AAA) : const Color(0xFF5C5A78);
  static Color get muted => _dark ? const Color(0xFF6A6A88) : const Color(0xFF75738F);
  static Color get dim => _dark ? const Color(0xFF4A4A62) : const Color(0xFFA3A1B8);
  static Color get blue => _dark ? const Color(0xFF89B4E8) : const Color(0xFF4A7BC4);
  static Color get lavender => _dark ? const Color(0xFFB8A8D8) : const Color(0xFF7D68B8);
  static Color get rose => _dark ? const Color(0xFFD4A0B8) : const Color(0xFFB5648A);
  static Color get sage => _dark ? const Color(0xFFA8C8A8) : const Color(0xFF5E8C5E);
}

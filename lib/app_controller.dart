import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:morphzing/utils/theme_service.dart';

class AppController extends GetxController {
  final Rx<User?> _user = Rx<User?>(null);
  final RxBool _isVisibleSubscribe = false.obs;
  DateFormat _dateFormat = DateFormat('EEE');
  final RxBool _isDeviceConnected = true.obs;

  User? get user => _user.value;

  set user(value) => _user.value = value;

  bool get isVisibleSubscribe => _isVisibleSubscribe.value;

  set isVisibleSubscribe(value) => _isVisibleSubscribe.value = value;

  DateFormat get dateFormat => _dateFormat;

  set setDateFormatLocale(String locale) =>
      _dateFormat = DateFormat('EEE', locale);

  get isDeviceConnected => _isDeviceConnected.value;

  set isDeviceConnected(value) => _isDeviceConnected.value = value;

  // Theme management
  ThemeModeType get themeModeType => ThemeService.themeModeType;

  bool isDarkMode(BuildContext context) => ThemeService.isDarkMode(context);

  void toggleTheme() {
    ThemeService.toggleTheme();
    update();
  }

  void setThemeMode(ThemeModeType mode) {
    ThemeService.setThemeMode(mode);
    update();
  }
}

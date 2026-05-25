import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/user/change_password_response.dart';
import 'package:morphzing/data/models/user/check_password_provider.dart';
import 'package:morphzing/data/repositories/auth/auth_repository.dart';
import 'package:morphzing/data/repositories/user/user_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/loading_overlay.dart';

class ChangePasswordController extends GetxController {
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final AppController _appController = Get.find<AppController>();

  final RxString _oldPassword = ''.obs;
  final RxString _newPassword = ''.obs;
  final RxString _confirmPassword = ''.obs;

  String get oldPassword => _oldPassword.value;

  String get newPassword => _newPassword.value;

  String get confirmPassword => _confirmPassword.value;

  set oldPassword(value) => _oldPassword.value = value;

  set newPassword(value) => _newPassword.value = value;

  set confirmPassword(value) => _confirmPassword.value = value;

  bool isValidate() {
    if (_oldPassword.value.length >= 8 && _newPassword.value.length >= 8 && _newPassword.value == _confirmPassword.value) {
      return true;
    }
    return false;
  }

  Future<bool> onPressedContinue() async {
    return await _authRepository
        .changePassword(CheckPasswordProvider(
      userId: _appController.user!.id,
      oldPassword: _oldPassword.value,
      newPassword: _newPassword.value,
    ))
        .then((value) async {
      LoadingOverlay.hide();
      return true;
    }).catchError((e) {
      LoadingOverlay.hide();
      return false;
    });
  }
}

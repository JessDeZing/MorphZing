import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/user/reset_password_provider.dart';
import 'package:morphzing/data/repositories/auth/auth_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class ResetPasswordController extends GetxController {
  final String secret = Get.arguments;

  final AuthRepository _authRepository = getIt<AuthRepository>();

  final RxString _newPassword = ''.obs;
  final RxString _confirmPassword = ''.obs;

  String get newPassword => _newPassword.value;

  String get confirmPassword => _confirmPassword.value;

  set newPassword(value) => _newPassword.value = value;

  set confirmPassword(value) => _confirmPassword.value = value;

  void onPressedContinue() {
    _authRepository
        .resetPassword(ResetPasswordProvider(secret: secret, password: newPassword, confirmPassword: confirmPassword))
        .then((value) {
      LoadingOverlay.hide();
      showSuccessDialog();
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  bool isValidate() {
    if (_newPassword.value.length >= 8 && _newPassword.value == _confirmPassword.value) return true;
    return false;
  }

  void showSuccessDialog() {
    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: Center(
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: blueColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              yourPasswordHasBeenSuccessfullyChanged.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: blackTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(color: blackTextColor, height: 1),
          TextButton(
            child: Text(great.tr,
                style: TextStyle(
                  color: blueColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SF Pro Display',
                )),
            style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () => Get.back(),
          )
        ],
      ),
    ).then((value) => Get.offAllNamed(loginRoute));
  }
}

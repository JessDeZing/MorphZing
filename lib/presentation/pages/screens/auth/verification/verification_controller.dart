import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/user/change_phone_provider.dart';
import 'package:morphzing/data/models/user/recovery_password_provider.dart';
import 'package:morphzing/data/models/user/user_verify_provider.dart';
import 'package:morphzing/data/models/verification/phone_verification_provider.dart';
import 'package:morphzing/data/repositories/auth/auth_repository.dart';
import 'package:morphzing/data/repositories/user/user_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/create_password/create_password_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/registration/registration_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/verification/verification_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class VerificationController extends GetxController {
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final UserRepository _userRepository = getIt<UserRepository>();
  final AppController _appController = Get.find<AppController>();

  final VerificationScreenParam _param = Get.arguments;

  final RxString _verificationCode = ''.obs;
  final RxBool _timeIsEnded = false.obs;
  final RxInt _endTime = 120.obs;

  VerificationScreenParam get param => _param;

  String get verificationCode => _verificationCode.value;

  set verificationCode(value) => _verificationCode.value = value;

  bool get timeIsEnded => _timeIsEnded.value;

  int get endTime => _endTime.value;

  @override
  void onReady() {
    _startTimer();
    super.onReady();
  }

  _startTimer() async {
    _timeIsEnded.value = false;
    _endTime.value = 120;
    for (int i = endTime; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      _endTime.value = i;
    }
    _timeIsEnded.value = true;
  }

  void retrySms() {
    if (_param.verificationType == VerificationType.recoveryVerification) {
      _authRepository
          .recoveryPassword(RecoveryPasswordProvider(phone: _param.phone))
          .then((value) {
        LoadingOverlay.hide();
        _startTimer();
      }).catchError((e) {
        LoadingOverlay.hide();
      });
    } else {
      _authRepository
          .auth(PhoneVerificationPost(phone: _param.phone))
          .then((value) {
        LoadingOverlay.hide();
        _startTimer();
      }).catchError((e) {
        LoadingOverlay.hide();
      });
    }
  }

  void onPressedContinue() {
    if (_param.verificationType == VerificationType.updatePhoneVerification) {
      _updatePhone();
    } else {
      _verification();
    }
  }

  void _updatePhone() {
    _authRepository
        .verification(
            UserVerification(phone: _param.phone, code: verificationCode))
        .then((value) => _userRepository.changePhone(
            ChangePhoneProvider(secret: value.secret, phone: _param.phone)))
        .then((value) {
      return _userRepository.getUserInfo();
    }).then((value) {
      LoadingOverlay.hide();
      _appController.user = value;
      showSuccessDialog();
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  void _verification() {
    _authRepository
        .verification(
      UserVerification(phone: _param.phone, code: verificationCode),
    )
        .then((value) {
      LoadingOverlay.hide();
      if (_param.verificationType == VerificationType.recoveryVerification) {
        verificationForRecovery(value.secret);
      } else if (_param.verificationType ==
          VerificationType.signUpVerification) {
        verificationForSignUp(value.secret);
      } else if (_param.verificationType ==
          VerificationType.socialVerification) {
        verificationSocial();
      }
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  void verificationForRecovery(String secretKey) =>
      Get.toNamed(resetPasswordRoute, arguments: secretKey);

  void verificationForSignUp(String secretKey) =>
      Get.toNamed(createPasswordRoute,
          arguments: CreatePasswordScreenParam(
            verificationType: _param.verificationType,
            secretKey: secretKey,
          ));

  void verificationSocial() {
    Get.toNamed(
      registrationRoute,
      arguments: RegistrationScreenParam(
        secretKey: _param.secretKey!,
        isSocial: true,
        phone: _param.phone,
        email: _param.email,
      ),
    );
  }

  void verificationUpdatePhone(String secretKey) {
    Get.toNamed(
      changePhoneNumber,
      arguments: secretKey,
    );
  }

  bool isValidate() {
    if (verificationCode.length == 6) return true;
    return false;
  }

  void showSuccessDialog() {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
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
              yourPhoneHasBeenSuccessfullyChanged.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white : blackTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
          SizedBox(height: 20),
          Divider(
            color: isDark ? Colors.white : blackTextColor,
            height: 1,
          ),
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
    ).then((value) {
      Get.back();
      Get.back();
    });
  }
}

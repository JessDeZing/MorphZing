import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/user/login_provider.dart';
import 'package:morphzing/data/repositories/auth/auth_repository.dart';
import 'package:morphzing/data/repositories/auth/token_repository.dart';
import 'package:morphzing/data/repositories/common/common_repository.dart';
import 'package:morphzing/data/repositories/user/user_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final TokenRepository _tokenRepository = getIt<TokenRepository>();
  final CommonRepository _commonRepository = getIt<CommonRepository>();
  final UserRepository _userRepository = getIt<UserRepository>();

  final AppController _appController = Get.find<AppController>();

  final RxString _login = ''.obs;
  final RxString _password = ''.obs;

  String get login => _login.value;

  set login(value) => _login.value = value;

  String get password => _password.value;

  set password(value) => _password.value = value;

  Future<void> onPressedLogin() async {
    _authRepository
        .login(LoginProvider(phone: login, password: password))
        .then((value) => {
          print('=======valueeeee $value'),
          _tokenRepository.saveToken(value.access, value.refresh!)
        })
        .then((value) => _userRepository.getUserInfo())
        .then((value) => {
          _appController.user = value,
          print('login controller ki valueeeee $value')
          })
        .then((value) => _commonRepository.setAuth(true))
        .then((value) {
      LoadingOverlay.hide();
      Get.offAllNamed(homeRoute);
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  void onPressedSignUp() => Get.toNamed(signUpRoute);

  void onPressedForgot() => Get.toNamed(recoveryPasswordRoute);

  bool isValidate() {
    if (login.length == 11 && password.isNotEmpty && password.length >= 8) return true;
    return false;
  }
}

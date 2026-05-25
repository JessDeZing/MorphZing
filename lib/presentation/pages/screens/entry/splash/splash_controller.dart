import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';

import 'package:morphzing/data/repositories/auth/token_repository.dart';
import 'package:morphzing/data/repositories/common/common_repository.dart';
import 'package:morphzing/data/repositories/user/user_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/locale_enum.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

class SplashController extends GetxController {
  final AppController _appController = Get.find<AppController>();
  final TokenRepository _tokenRepository = getIt<TokenRepository>();
  final UserRepository _userRepository = getIt<UserRepository>();
  final CommonRepository _commonRepository = getIt<CommonRepository>();

  @override
  void onReady() {
    _init();
    super.onReady();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 1));
    bool isAuth = _commonRepository.getIsAuth();
    String? localeKey = _commonRepository.getLocale();
    String? accessToken = _tokenRepository.getAccessToken();
    bool isVisibleSubscribe = _commonRepository.getIsVisibleSubscribeKey();
    _appController.isVisibleSubscribe = isVisibleSubscribe;
    if (localeKey != null) {
      Get.locale = localeKey == LocaleEnum.en.getLocaleKey()
          ? LocaleEnum.en.getLocale()
          : LocaleEnum.es.getLocale();
      _appController.setDateFormatLocale = localeKey;
    }
    if (isAuth && accessToken != null) {
      _userRepository.getUserInfo().then((value) {
        _appController.user = value;
        Get.offAllNamed(homeRoute);
      }).onError((error, stackTrace) {
        Get.offAllNamed(loginRoute);
      });
    } else if (localeKey != null) {
      Get.locale = localeKey == LocaleEnum.en.getLocaleKey()
          ? LocaleEnum.en.getLocale()
          : LocaleEnum.es.getLocale();
      Get.offAllNamed(loginRoute);
    } else {
      Get.offAllNamed(setupLanguageRoute);
    }
  }
}

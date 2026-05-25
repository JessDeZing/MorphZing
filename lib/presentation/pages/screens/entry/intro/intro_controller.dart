import 'package:get/get.dart';
import 'package:morphzing/data/repositories/common/common_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/locale_enum.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

class IntroController extends GetxController {
  final CommonRepository _commonRepository = getIt<CommonRepository>();

  void onPressedGetStarted() {
    _setLanguageKey(
        Get.locale == LocaleEnum.en.getLocale() ? LocaleEnum.en.getLocaleKey() : LocaleEnum.es.getLocaleKey());
  }

  void _setLanguageKey(String languageKey) =>
      _commonRepository.setLocale(languageKey).then((value) => Get.offAllNamed(loginRoute));
}

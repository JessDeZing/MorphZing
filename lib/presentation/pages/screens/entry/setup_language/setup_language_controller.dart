import 'package:get/get.dart';
import 'package:morphzing/localization/locale_enum.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

class SetupLanguageController extends GetxController {
  void changeLanguage(LocaleEnum localeEnum) => Get.updateLocale(localeEnum.getLocale());

  void onPressedNext() => Get.toNamed(firstIntroRoute);
}

import 'package:get/get.dart';
import 'package:morphzing/localization/en.dart';
import 'package:morphzing/localization/es.dart';

class AppLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': En().translations,
        'es_ES': Es().translations,
      };
}

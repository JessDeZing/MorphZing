import 'package:flutter/material.dart';

enum LocaleEnum {
  en,
  es,
}

extension LocaleExtension on LocaleEnum {
  Locale getLocale() {
    if (this == LocaleEnum.en) return const Locale('en', 'EN');
    return const Locale('es', 'ES');
  }

  String getLocaleKey() {
    if (this == LocaleEnum.en) return 'en';
    return 'es';
  }
}

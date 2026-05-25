import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class CommonRepository {
  static String localeKey = 'LOCALE_KEY';
  static String isAuthKey = 'IS_AUTH_KEY';
  static String isVisibleSubscribeKey = 'IS_VISIBLE_SUBSCRIBE_KEY';

  final GetStorage _getStorage;

  CommonRepository(this._getStorage);

  String? getLocale() {
    final locale = _getStorage.read(localeKey);
    return locale;
  }

  Future<void> setLocale(String value) async {
    try {
      await _getStorage.write(localeKey, value);
    } on Object catch (e) {
      log("Could not update tokens, error: ${e.toString()}");
      rethrow;
    }
  }

  bool getIsAuth() => _getStorage.read(isAuthKey) ?? false;

  Future<void> setAuth(bool value) async {
    try {
      await _getStorage.write(isAuthKey, value);
    } on Object catch (e) {
      log("Could not update tokens, error: ${e.toString()}");
      rethrow;
    }
  }

  bool getIsVisibleSubscribeKey() =>
      _getStorage.read(isVisibleSubscribeKey) ?? false;

  Future<void> setIsVisibleSubscribeKey(bool value) async {
    try {
      await _getStorage.write(isVisibleSubscribeKey, value);
    } on Object catch (e) {
      log("Could not update tokens, error: ${e.toString()}");
      rethrow;
    }
  }
}

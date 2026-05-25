import 'dart:developer';

import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

@singleton
class TokenRepository {
  final GetStorage _getStorage;

  TokenRepository(this._getStorage);

  String? getAccessToken() => _getStorage.read('token')?.toString();

  String? getRefreshToken() => _getStorage.read('refresh_token')?.toString();

  Future<void> deleteTokens() async {
    await _getStorage.remove('token');
    await _getStorage.remove('refresh_token');
  }

  Future<void> updateTokens(String accessToken) async {
    try {
      await _getStorage.write('token', accessToken);
    } on Object catch (e) {
      log("Could not update tokens, error: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> saveToken(String accessToken, String refreshToken) async {
    try {
      await _getStorage.write('token', accessToken);
      await _getStorage.write('refresh_token', refreshToken);
    } on Object catch (e) {
      log("Could not update tokens, error: ${e.toString()}");
      rethrow;
    }
  }
}

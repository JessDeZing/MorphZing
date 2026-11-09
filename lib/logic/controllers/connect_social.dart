import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/repositories/auth/token_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart' as translation;

/// Links Google sign-in to the account that is logged in right now
/// (POST /social/connect/), so the Google button opens this account later.
class ConnectSocial {
  ConnectSocial._();

  static bool _busy = false;

  static Future<void> connectGoogle() async {
    if (_busy) return;
    _busy = true;
    try {
      final google = GoogleSignIn();
      final account = await google.signIn();
      if (account == null) return; // cancelled
      final auth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      final result = await FirebaseAuth.instance.signInWithCredential(credential);
      final idToken = await result.user?.getIdToken();
      await google.signOut();
      await FirebaseAuth.instance.signOut();
      if (idToken == null) {
        _message(translation.connectGoogleFailed.tr, false);
        return;
      }
      final access = getIt<TokenRepository>().getAccessToken();
      await Dio(BaseOptions(baseUrl: BASE_URL)).post(
        '/social/connect/',
        data: {'provider': 'google', 'auth_token': idToken},
        options: Options(headers: {'Authorization': 'Bearer $access'}),
      );
      _message(translation.connectGoogleDone.tr, true);
    } on DioException catch (e) {
      _message(_serverMessage(e) ?? translation.connectGoogleFailed.tr, false);
    } catch (_) {
      _message(translation.connectGoogleFailed.tr, false);
    } finally {
      _busy = false;
    }
  }

  static String? _serverMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['errors'] is List && (data['errors'] as List).isNotEmpty) {
      final first = (data['errors'] as List).first;
      if (first is Map && first['message'] is String) return first['message'] as String;
    }
    return null;
  }

  static void _message(String text, bool ok) {
    final context = Get.context;
    if (context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: ok ? const Color(0xFF2E9E5B) : const Color(0xFFFF3B30),
    ));
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/localization/translation_keys.dart' as translation;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Checks the server for a newer app version and shows the update pop-up.
/// Silent on any failure: never blocks startup, never shows an error.
/// Versions are set in Django admin > App versions.
class AppUpdateCheck {
  AppUpdateCheck._();

  static const _androidUrl =
      'https://play.google.com/store/apps/details?id=com.jafton.morphzing';
  static const _iosUrl = 'https://apps.apple.com/app/id1668666088';
  static const _snoozeKey = 'updateSnooze';
  static const _snoozeDays = 3;
  static bool _ran = false;

  /// Call once at startup. Waits 2 seconds so the next screen is showing first.
  static void runAfterStartup() {
    if (_ran) return;
    _ran = true;
    Future.delayed(const Duration(seconds: 2), _check);
  }

  static Future<void> _check() async {
    try {
      if (Platform.isAndroid == false && Platform.isIOS == false) return;
      final platform = Platform.isIOS ? 'ios' : 'android';
      // Plain Dio on purpose: no login token, no error pop-ups.
      final res = await Dio(BaseOptions(baseUrl: BASE_URL)).get('/homepage/app_version');
      final data = res.data;
      if ((data is Map) == false) return;
      final entry = data[platform];
      if ((entry is Map) == false) return;
      final latest = (entry['latest'] ?? '').toString();
      final min = (entry['min'] ?? '').toString();
      final current = (await PackageInfo.fromPlatform()).version;
      final forced = min.isNotEmpty && _compare(current, min) < 0;
      final newer = latest.isNotEmpty && _compare(current, latest) < 0;
      if (forced == false && newer == false) return;
      if (forced == false && _snoozed(latest)) return;
      _show(forced: forced, latest: latest);
    } catch (_) {
      // No internet, server down or bad data: skip quietly.
    }
  }

  /// -1 if a < b, 0 if equal, 1 if a > b (compares 1.0.45 style versions).
  static int _compare(String a, String b) {
    final pa = a.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final pb = b.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final n = pa.length > pb.length ? pa.length : pb.length;
    for (var i = 0; i < n; i++) {
      final x = i < pa.length ? pa[i] : 0;
      final y = i < pb.length ? pb[i] : 0;
      if (x == y) continue;
      return x < y ? -1 : 1;
    }
    return 0;
  }

  static bool _snoozed(String latest) {
    try {
      final s = GetStorage().read(_snoozeKey);
      if ((s is Map) == false) return false;
      final until = s['until'];
      return s['version'] == latest &&
          until is int &&
          DateTime.now().millisecondsSinceEpoch < until;
    } catch (_) {
      return false;
    }
  }

  static void _snooze(String latest) {
    GetStorage().write(_snoozeKey, {
      'version': latest,
      'until': DateTime.now()
          .add(const Duration(days: _snoozeDays))
          .millisecondsSinceEpoch,
    });
  }

  static Future<void> _openStore() async {
    try {
      await launchUrl(Uri.parse(Platform.isIOS ? _iosUrl : _androidUrl),
          mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  static void _show({required bool forced, required String latest}) {
    final context = Get.context;
    if (context == null) return;
    showDialog(
      context: context,
      barrierDismissible: forced == false,
      builder: (ctx) => PopScope(
        canPop: forced == false,
        child: AlertDialog(
          title: Text(forced
              ? translation.updateRequiredTitle.tr
              : translation.updateAvailableTitle.tr),
          content: Text(forced
              ? translation.updateRequiredBody.tr
              : translation.updateAvailableBody.tr),
          actions: [
            if (forced == false)
              TextButton(
                onPressed: () {
                  _snooze(latest);
                  Navigator.of(ctx).pop();
                },
                child: Text(translation.updateLater.tr),
              ),
            TextButton(
              onPressed: () {
                _openStore();
                if (forced == false) Navigator.of(ctx).pop();
              },
              child: Text(translation.updateNow.tr),
            ),
          ],
        ),
      ),
    );
  }
}

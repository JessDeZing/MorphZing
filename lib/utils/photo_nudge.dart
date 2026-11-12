import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

/// One-time "Make MorphZing yours" pop-up for users without a profile photo.
/// Called after a journal save, but never on the same save as the reminder ask.
class PhotoNudge {
  static const String _shownKey = 'photoNudgeShown';

  static bool _hasPhoto() {
    try {
      final url = (Get.find<AppController>().user?.imageUrl ?? '').trim();
      return url.isNotEmpty && url != 'null';
    } catch (_) {
      return true; // unknown: don't nag
    }
  }

  static Future<void> maybeShow() async {
    final box = GetStorage();
    if (box.read(_shownKey) == true) return;
    if (_hasPhoto()) return;
    final ctx = Get.context;
    if (ctx == null) return;
    await box.write(_shownKey, true);
    final yes = await showDialog<bool>(
      context: ctx,
      builder: (c) => AlertDialog(
        title: Text(photoNudgeTitle.tr),
        content: Text(photoNudgeBody.tr),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: Text(photoNudgeNo.tr)),
          TextButton(onPressed: () => Navigator.of(c).pop(true), child: Text(photoNudgeYes.tr)),
        ],
      ),
    );
    if (yes == true) Get.toNamed(profileRoute);
  }
}

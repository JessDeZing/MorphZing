import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';

// All pop-ups use Flutter's own SnackBar through the app's root ScaffoldMessenger.
// GetX snackbars never showed in this app and left GetX broken, which made
// Get.back() crash (LateInitializationError) and could hang server requests.
void _show(String title, String message, Color background) {
  try {
    final context = Get.context;
    if (context == null) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message.isEmpty ? title : message, style: const TextStyle(color: Colors.white)),
        backgroundColor: background,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ));
  } catch (_) {
    // A pop-up must never crash the app or block a request.
  }
}

showInternalError({String? title, String? desc}) =>
    _show(title ?? 'Something went wrong', desc ?? 'Please try again', const Color.fromARGB(255, 241, 78, 67));

showGetSnackBar({String? message}) => _show(success.tr, message ?? '', snackBarBgColor);

showErrorSnackBar({String? message}) => _show(error.tr, message ?? '', const Color(0xFFFF3B30));

showAttentionSnackBar({String? message}) => _show(attention.tr, message ?? '', snackBarBgColor);

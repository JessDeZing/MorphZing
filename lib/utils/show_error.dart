import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';

showInternalError({String? title, String? desc}) {
  Get.showSnackbar(
    GetSnackBar(
      backgroundColor: const Color.fromARGB(255, 241, 78, 67),
      barBlur: 1.0,
      title: title ?? "Something went wrong",
      message: desc ?? "Please try again",
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      borderRadius: 17,
      duration: 3.seconds,
    ),
  );
}

showGetSnackBar({String? message}) {
  Get.snackbar(
    success.tr,
    message ?? '',
    colorText: whiteColor,
    duration: 3.seconds,
    snackPosition: SnackPosition.TOP,
    backgroundColor: snackBarBgColor,
    margin: const EdgeInsets.only(
      left: 16,
      right: 16,
      bottom: 56,
    ),
  );
}

showErrorSnackBar({String? message}) {
  Get.snackbar(
    error.tr,
    message ?? '',
    colorText: whiteColor,
    duration: 3.seconds,
    snackPosition: SnackPosition.TOP,
    backgroundColor: snackBarBgColor,
    margin: const EdgeInsets.only(
      left: 16,
      right: 16,
      top: 56,
    ),
  );
}

showAttentionSnackBar({String? message}) {
  Get.snackbar(
    attention.tr,
    message ?? '',
    colorText: whiteColor,
    duration: 3.seconds,
    snackPosition: SnackPosition.TOP,
    backgroundColor: snackBarBgColor,
    margin: const EdgeInsets.only(
      left: 16,
      right: 16,
      top: 56,
    ),
  );
}

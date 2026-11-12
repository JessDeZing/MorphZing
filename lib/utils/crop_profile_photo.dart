import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:morphzing/localization/translation_keys.dart' as translation;

/// Opens a round crop screen for a profile photo: pinch to zoom, drag to move.
/// Returns the cropped photo, or null if the user cancels.
/// Used by sign-up and Profile, so the crop look is changed here only.
Future<File?> cropProfilePhoto(String sourcePath) async {
  final cropped = await ImageCropper().cropImage(
    sourcePath: sourcePath,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    maxWidth: 1080,
    maxHeight: 1080,
    compressQuality: 85,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: translation.adjustPhoto.tr,
        toolbarColor: const Color(0xFF121212),
        toolbarWidgetColor: Colors.white,
        backgroundColor: Colors.black,
        activeControlsWidgetColor: const Color(0xFF8B6FE8),
        cropStyle: CropStyle.circle,
        lockAspectRatio: true,
        initAspectRatio: CropAspectRatioPreset.square,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      ),
      IOSUiSettings(
        title: translation.adjustPhoto.tr,
        cropStyle: CropStyle.circle,
        aspectRatioLockEnabled: true,
        resetAspectRatioEnabled: false,
        aspectRatioPickerButtonHidden: true,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      ),
    ],
  );
  if (cropped == null) return null;
  return File(cropped.path);
}

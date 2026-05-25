import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/core/constants/const_lists.dart';
import 'package:morphzing/data/api/subscriptionPlan_repositories.dart';
import 'package:morphzing/data/repositories/auth/auth_repository.dart';
import 'package:morphzing/data/repositories/auth/token_repository.dart';
import 'package:morphzing/data/repositories/common/common_repository.dart';
import 'package:morphzing/data/repositories/user/user_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/registration/registration_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class RegistrationController extends GetxController {
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final UserRepository _userRepository = getIt<UserRepository>();
  final TokenRepository _tokenRepository = getIt<TokenRepository>();
  final CommonRepository _commonRepository = getIt<CommonRepository>();

  final AppController _appController = Get.find<AppController>();

  final RegistrationScreenParam _param = Get.arguments;

  RegistrationScreenParam get param => _param;

  final Rx<File?> _currentImage = Rx<File?>(null);
  final RxString _fio = ''.obs;
  final RxString _bio = ''.obs;
  final Rx<DateTime> _birthDate = Rx<DateTime>(DateTime.now());
  final Rx<String> _email = ''.obs;
  final RxInt _currentSex = 0.obs;
  final RxBool _isLoading = false.obs;

  File? get currentImage => _currentImage.value;

  set currentImage(value) => _currentImage.value = currentImage;

  String get fio => _fio.value;

  set fio(value) => _fio.value = value;

  String get bio => _fio.value;

  set bio(value) => _bio.value = value;

  DateTime get birthDate => _birthDate.value;

  set birthDate(value) => _birthDate.value = value;

  String get email => _email.value;

  set email(value) => _email.value = value;

  int get currentSex => _currentSex.value;

  set currentSex(value) => _currentSex.value = value;

  bool get isLoading => _isLoading.value;

  pickImageFromCamera() async {
    _isLoading.value = true;
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    Get.back();
    if (image == null) return;

    final imageTemporary = File(image.path);
    _currentImage.value = imageTemporary;
    _isLoading.value = false;
  }

  pickImageFromGallery() async {
    _isLoading.value = true;
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    Get.back();
    if (image == null) return;

    final imageTemporary = File(image.path);
    _currentImage.value = imageTemporary;
    _isLoading.value = false;
  }

  bool isValidate() {
    if (_fio.value.isNotEmpty &&
        _bio.value.isNotEmpty &&
        _currentSex.value != 0 &&
        _param.isSocial) return true;

    if (_fio.value.isNotEmpty &&
        _bio.value.isNotEmpty &&
        _currentSex.value != 0 &&
        _email.value.isNotEmpty &&
        GetUtils.isEmail(_email.value)) return true;

    return false;
  }

  Future<void> onPressedSignUp() async {
    final box = GetStorage();
    box.write('isSubscriptionShown', false);
    if (_param.isSocial) {
      _registerSocial();
    } else {
      _registerPhone();
    }
  }

  // Future<void> _registerPhone() async {
  //   final timeZone = await FlutterNativeTimezone.getLocalTimezone();
  //   _authRepository
  //       .signUpPhone(
  //           secret: _param.secretKey,
  //           fullName: _fio.value,
  //           bio: _bio.value,
  //           birthDate: DateFormat('yyyy-MM-dd').format(_birthDate.value),
  //           sex: GENDER_LIST_WORD[_currentSex.value - 1],
  //           email: _email.value,
  //           timeZone: timeZone,
  //           password: _param.password,
  //           file: _currentImage.value)
  //       .then((value) => _tokenRepository.saveToken(value.access, value.refresh!))
  //       .then((value) => _userRepository.getUserInfo())
  //       .then((value) => _appController.user = value)
  //       .then((value) => _commonRepository.setAuth(true))
  //       .then((value) => _commonRepository.setIsVisibleSubscribeKey(true))
  //       .then((value) {
  //     LoadingOverlay.hide();
  //     LoadingOverlay.hide();
  //     Get.offAllNamed(homeRoute);
  //   }).catchError((e) {
  //     LoadingOverlay.hide();
  //     LoadingOverlay.hide();
  //   });
  // }
  Future<void> _registerPhone() async {
    // final timeZone = await FlutterNativeTimezone.getLocalTimezone();
    final timeZone = await await FlutterTimezone.getLocalTimezone();
    final box = GetStorage();

    // Calculate the age based on the birth date
    final age = DateTime.now().difference(_birthDate.value).inDays ~/ 365;

    // Check if age is less than 3
    if (age < 3) {
      // Show alert dialog for under age
      showAttentionSnackBar(message: birthdateValidation.tr);
      _isLoading.value = false;
      LoadingOverlay.hide(); // Set isLoading to false here
      return;
    }

    try {
      // Sign up the user with the provided details
      final value = await _authRepository.signUpPhone(
        secret: _param.secretKey,
        fullName: _fio.value,
        bio: _bio.value,
        birthDate: DateFormat('yyyy-MM-dd').format(_birthDate.value),
        sex: GENDER_LIST_WORD[_currentSex.value - 1],
        email: _email.value,
        timeZone: timeZone,
        password: _param.password,
        file: _currentImage.value,
      );

      // Save the token
      await _tokenRepository.saveToken(value.access, value.refresh!);

      // Make the post request with the access token
      final response =
          await SubscriptionRepositories.makePostRequest(token: value.access);
      print("response 170 $response");

      // Get user info and set the user in appController
      final userInfo = await _userRepository.getUserInfo();
      _appController.user = userInfo;
      // Set the free trial popup flag
      print("do the box writing");
      await box.write('showFreeTrialPopup', false);

      // Set authentication and visibility
      await _commonRepository.setAuth(true);
      await _commonRepository.setIsVisibleSubscribeKey(true);

      // Hide loading and navigate to the home route
      LoadingOverlay.hide();
      Get.offAllNamed(homeRoute);
    } catch (e) {
      // Handle errors
      LoadingOverlay.hide();
      showAttentionSnackBar(message: e.toString());
    }
  }

//   Future<void> _registerPhone() async {
//   final timeZone = await FlutterNativeTimezone.getLocalTimezone();

//   // Calculate the age based on the birth date
//   final age = DateTime.now().difference(_birthDate.value).inDays ~/ 365;

//   // Check if age is less than 18
//   if (age < 3) {
//     // Show alert dialog for under age
//     showAttentionSnackBar(message: birthdateValidation.tr);
//     _isLoading.value = false;
//       LoadingOverlay.hide(); // Set isLoading to false here
//     return;
//   }

//   _authRepository
//       .signUpPhone(
//           secret: _param.secretKey,
//           fullName: _fio.value,
//           bio: _bio.value,
//           birthDate: DateFormat('yyyy-MM-dd').format(_birthDate.value),
//           sex: GENDER_LIST_WORD[_currentSex.value - 1],
//           email: _email.value,
//           timeZone: timeZone,
//           password: _param.password,
//           file: _currentImage.value)
//       .then((value) => _tokenRepository.saveToken(value.access, value.refresh!))
//       .then((value) => _userRepository.getUserInfo())
//       .then((value) => _appController.user = value)
//       .then((value) => _commonRepository.setAuth(true))
//       .then((value) => _commonRepository.setIsVisibleSubscribeKey(true))
//       .then((value) {
//     LoadingOverlay.hide();
//     LoadingOverlay.hide();
//     Get.offAllNamed(homeRoute);
//   }).catchError((e) {
//     LoadingOverlay.hide();
//     LoadingOverlay.hide();
//   });
// }

  Future<void> _registerSocial() async {
    // final timeZone = await FlutterNativeTimezone.getLocalTimezone();
    final timeZone = await FlutterTimezone.getLocalTimezone();

    _authRepository
        .signUpSocial(
            secret: _param.secretKey,
            fullName: _fio.value,
            bio: _bio.value,
            birthDate: DateFormat('yyyy-MM-dd').format(_birthDate.value),
            sex: GENDER_LIST_WORD[_currentSex.value - 1],
            timeZone: timeZone,
            phone: _param.phone,
            password: _param.password,
            email: _param.email,
            file: _currentImage.value)
        .then(
            (value) => _tokenRepository.saveToken(value.access, value.refresh!))
        .then((value) => _userRepository.getUserInfo())
        .then((value) => _appController.user = value)
        .then((value) => _commonRepository.setAuth(true))
        .then((value) => _commonRepository.setIsVisibleSubscribeKey(true))
        .then((value) {
      LoadingOverlay.hide();
      Get.offAllNamed(homeRoute);
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  String getCurrentSexLabel() {
    if (_currentSex.value == 1) {
      return male.tr;
    } else if (_currentSex.value == 2) {
      return female.tr;
    } else if (_currentSex.value == 3) {
      return nonBinary.tr;
    }
    return pleaseSelect.tr;
  }

  String getFormatBirthDate() {
    String formattedDate = DateFormat('MM/dd/yyyy').format(_birthDate.value);
    return formattedDate;
  }
}

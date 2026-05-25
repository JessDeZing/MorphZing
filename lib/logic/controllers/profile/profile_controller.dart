import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/error_model.dart';
import 'package:morphzing/data/repositories/common/common_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/locale_enum.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/profile/new_password_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/const_lists.dart';
import 'package:morphzing/data/models/user/user_info.dart';
import 'package:morphzing/data/models/user/user_verify_provider.dart';
import 'package:morphzing/data/models/verification/phone_verification_get_provider.dart';
import 'package:morphzing/data/repositories/home/home_repositories.dart';
import 'package:morphzing/data/repositories/profile/profile_repository.dart';
import 'package:morphzing/data/repositories/registration/send_phone_number.dart';
import 'package:morphzing/presentation/pages/screens/home/home_controller.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  final AppController _appController = Get.find<AppController>();

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPhoneNumberController = TextEditingController();
  TextEditingController verificationController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController forgotPasswordPhoneController = TextEditingController();

  Rx<DateTime> birthDate = DateTime.now().obs;
  RxString birthDateString = ''.obs;

  Rx<DateTime> dateTime = DateTime.now().obs;
  Rx<DateTime> focusedDateTime = DateTime.now().obs;
  final box = GetStorage();
  File? currentImage;
  RxInt currentSex = 0.obs;
  RxString defaultSex = 'Prefer not to Say'.obs;
  RxBool withSocial = false.obs;
  RxBool loading = RxBool(false);
  Rx<UserInfo?> userInfoModel = Rx(null);
  RxInt endTime = 120.obs;
  RxBool timeIsEnded = false.obs;
  RxString secret = RxString("");

  customTimer() async {
    timeIsEnded.value = false;
    for (int i = 120; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      endTime.value = i;
    }
    timeIsEnded.value = true;
  }

  void setLocale(LocaleEnum localeEnum) {
    Get.updateLocale(localeEnum.getLocale());
    getIt<CommonRepository>().setLocale(localeEnum.getLocaleKey());
    _appController.setDateFormatLocale = localeEnum.getLocaleKey();
  }

  pickImageFromCamera() async {
    loading(true);
    final image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (image == null) {
      loading(false);
      return;
    }

    final imageTemporary = File(image.path);
    currentImage = imageTemporary;
    loading(false);
    Get.back();
  }

  pickImageFromGallery() async {
    loading(true);
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) {
      loading(false);
      return;
    }

    final imageTemporary = File(image.path);
    currentImage = imageTemporary;
    loading(false);
    Get.back();
  }

  onForgotPassword() async {
    loading(true);
    try {
      final phone = newPhoneNumberController.text.replaceAll("+", "").replaceAll("(", "").replaceAll(")", "").replaceAll("-", "").replaceAll(" ", "");
      var result = await SendPhoneNumberRepositories.forgotPassword(phone);

      if (result.statusCode == 200 || result.statusCode == 201) {
        //Get.to(VerificationScreen(isForgot: true));
        customTimer();
      }
    } on DioError catch (e) {
      debugPrint('ERROR $e');
      showInternalError(
        title: (e.response?.data["errors"][0]["message"]).toString(),
      );
    }
    loading(false);
  }

  smsVerify() async {
    loading(true);
    var phone = newPhoneNumberController.text.replaceAll("+", "").replaceAll("(", "").replaceAll(")", "").replaceAll("-", "").replaceAll(" ", "");
    if (phone.length == 11) {
      try {
        var result = await SendPhoneNumberRepositories.verifyPhoneNumber(phone);
        PhoneVerificationGet response = PhoneVerificationGet.fromJson(
          jsonDecode(result.toString()),
        );
        if (response.success ?? false) {
          //Get.to(VerificationScreen());
          customTimer();
        }
      } catch (e) {
        debugPrint('ERROR $e');
      }
      loading(false);
    } else {
      Get.snackbar('', 'Phone number length must be 11 characters');
    }
    loading(false);
  }

  smsVerifyCheck() async {
    loading(true);
    try {
      final token = box.read('token').toString();
      var phone = newPhoneNumberController.text.replaceAll("+", "").replaceAll("(", "").replaceAll(")", "").replaceAll("-", "").replaceAll(" ", "");
      var result = await SendPhoneNumberRepositories.verifySmsCode(phone, verificationController.text);
      UserVerifiedSuccess response = UserVerifiedSuccess.fromJson(
        jsonDecode(
          result.toString(),
        ),
      );

      if (response.success) {
        final finalResult = await SendPhoneNumberRepositories.phoneNumberUpdate(phone, response.secret, token);
        if (finalResult.statusCode == 201 || finalResult.statusCode == 200) {
          Get.back();
          Get.back();
        }
      }
    } on DioError catch (e) {
      debugPrint('ERROR $e');

      try {
        showInternalError(
          title: (e.response?.data["errors"][0]["message"]).toString(),
        );
      } catch (e) {
        showInternalError();
      }
    }
    loading(false);
  }

  smsVerifyCheckFromForgot() async {
    loading(true);
    try {
      var phone = newPhoneNumberController.text.replaceAll("+", "").replaceAll("(", "").replaceAll(")", "").replaceAll("-", "").replaceAll(" ", "");
      var result = await SendPhoneNumberRepositories.verifySmsCode(phone, verificationController.text);
      UserVerifiedSuccess response = UserVerifiedSuccess.fromJson(
        jsonDecode(
          result.toString(),
        ),
      );

      if (response.success) {
        secret(response.secret);
        Get.to(const NewPasswordScreen(isForgot: true));
      }
    } on DioError catch (e) {
      debugPrint('ERROR $e');

      try {
        showInternalError(
          title: (e.response?.data["errors"][0]["message"]).toString(),
        );
      } catch (e) {
        showInternalError();
      }
    }
    loading(false);
  }
  

  onSave() async {
    final appController = Get.find<AppController>();
    final token = box.read('token').toString();

    final age = DateTime.now().difference(birthDate.value).inDays ~/ 365;
     if (age < 3) {
    // Show alert dialog for under age
    showAttentionSnackBar(message: birthdateValidation.tr);
    return;
    }
    loading(true);

    var result = await ProfileRepository.edit(
      token: token,
      id: appController.user!.id,
      bio: bioController.text,
      fullName: nameController.text,
      birthDate: birthDate.value,
      sex: GENDER_LIST_WORD[currentSex.value - 1],
      phone: newPhoneNumberController.text,
      email: emailController.text,
      image: currentImage,
    );
    if (result.statusCode == 200 || result.statusCode == 201) {
      Get.back();
    } else {
      showInternalError();
    }
    fetchUserInfo().then((value) {
      getData();
      _appController.update();
    });
    _appController.update();

    loading(false);
  }

  onDeleteAccount() async {
    loading(true);
    Get.back();

    final token = box.read('token').toString();

    var result = await ProfileRepository.deleteAccount(token);
    if (result.statusCode == 200 || result.statusCode == 204) {
      await box.remove("token");
      Get.offAllNamed(loginRoute);
    } else {
      showInternalError();
    }

    loading(false);
  }

  onSavePassword() async {
    loading(true);

    final appController = Get.find<AppController>();
    final token = box.read('token').toString();

    var result = await ProfileRepository.savePassword(
      token: token,
      id: appController.user!.id,
      password: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
    );
    if (result.statusCode == 200 || result.statusCode == 201) {
      Get.back();
      Get.back();
    } else {
      showInternalError();
    }
    fetchUserInfo().then((value) {
      getData();
    });

    loading(false);
  }

  onResetPassword(BuildContext context) async {
    final result = await SendPhoneNumberRepositories.resetPassword(
      newPasswordController.text,
      confirmPasswordController.text,
      secret.value,
    );
    if (result.statusCode == 201 || result.statusCode == 200) {
      await showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Your password has been successfully changed'),
              actions: <Widget>[
                CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context); //close Dialog
                  },
                  child: const Text('Great'),
                ),
              ],
            );
          });
      Get.back();
      Get.back();
      Get.back();
    }
  }

  onCheckPassword() async {
    loading(true);

    final appController = Get.find<AppController>();
    final token = box.read('token').toString();

    try {
      var result = await ProfileRepository.checkPassword(
        token: token,
        id: appController.user!.id,
        password: oldPasswordController.text,
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        Get.to(const NewPasswordScreen());
      } else {
        showInternalError(
          title: (result.data["errors"][0]["message"]).toString(),
        );
      }
      fetchUserInfo().then((value) {
        getData();
      });
    } on DioError catch (e) {
      showInternalError(
        title: (e.response?.data["errors"][0]["message"]).toString(),
      );
    }

    loading(false);
  }

  Future fetchUserInfo() async {
    loading(true);
    try {
      var result = await HomeRepositories.getUserData(
        box.read('token').toString(),
      );

      if (result.statusCode == 200) {
        userInfoModel(UserInfo.fromJson(
          jsonDecode(
            result.toString(),
          ),
        ));
      }
    } catch (e) {
      showInternalError();
    }
  }

  @override
  void onReady() {
    if (box.read('token') != null) {
      fetchUserInfo().then((value) {
        getData();
      });
    }

    super.onReady();
  }

  getData() async {
    nameController.text = userInfoModel.value?.fullName ?? "";
    bioController.text = userInfoModel.value?.bio ?? "";
    birthDate(userInfoModel.value?.birthDate);
    birthDateString(DateFormat('MM/dd/yyyy').format(birthDate.value));
    if (userInfoModel.value?.sex == "M") {
      defaultSex(genderList[0]);
      currentSex(1);
    } else if (userInfoModel.value?.sex == "F") {
      defaultSex(genderList[1]);
      currentSex(2);
    } else if (userInfoModel.value?.sex == "NB") {
      defaultSex(genderList[2]);
      currentSex(3);
    }
    newPhoneNumberController.text = userInfoModel.value?.phone ?? "";
    emailController.text = userInfoModel.value?.email ?? "";
    if (userInfoModel.value?.imageUrl != null && userInfoModel.value?.imageUrl != "null" && (userInfoModel.value?.imageUrl ?? "").isNotEmpty) {
      currentImage = await _fileFromImageUrl(userInfoModel.value!.imageUrl!);
    }
    loading(false);
  }

  Future<File> _fileFromImageUrl(String url) async {
    debugPrint('URL: $url');

    final response = await http.get(Uri.parse(url));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, url.split("/").last));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }
}

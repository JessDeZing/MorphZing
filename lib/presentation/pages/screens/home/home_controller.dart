import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/home_page/banner.dart';
import 'package:morphzing/data/models/home_page/home_page_images.dart';
import 'package:morphzing/data/repositories/home/home_page_repository.dart';
import 'package:morphzing/data/repositories/user/user_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/show_error.dart';

class HomeController extends GetxController {
  RxBool loading = RxBool(false);
  final box = GetStorage();
  Rx<HomePageImages> homePageImages = Rx(const HomePageImages());
  Rx<Banner> uploadedImage = Rx(const Banner());
  final _homePageRepository = getIt<HomePageRepository>();
  final _userRepo = getIt<UserRepository>();
  final _appController = Get.find<AppController>();
  RxBool bannerLoading = true.obs;
  late final StreamSubscription<InternetConnectionStatus>
      _internetCheckerListener;

  @override
  void onInit() async {
    super.onInit();
    _initInternetListener();
    await getBannerImage();
  }

  void fetchUserInfo() async {
    print("fetchUserInfo called 37");
    try {
      await _userRepo.getUserInfo().then((value) =>
          {print("Fetched user info: $value"), _appController.user = value});
    } on Object {}
  }

  Future<bool> checkSubscriptionShownStatus() async {
    await _homePageRepository.getSubscriptionShown().then((value) {
      if (!value) {
        Future.delayed(const Duration(seconds: 1));
        return false;
      } else {
        return true;
      }
    });
    return true;
  }

  void setSubscriptionShown() {
    _homePageRepository.setSubscriptionShown();
  }

  Future<void> getBannerImage() async {
    bannerLoading.value = true;
    try {
      homePageImages.value = await _homePageRepository.getHomePageImage();
    } on Object catch (_) {
      showErrorSnackBar(message: failedFetchHomeBanner.tr);
    }
    bannerLoading.value = false;
  }

  Future<Banner?> uploadPhoto(File image) async {
    try {
      uploadedImage.value = await _homePageRepository.uploadBannerPhoto(image);
      return uploadedImage.value;
    } on Object catch (_) {
      showErrorSnackBar(message: failedUploadHomeBanner.tr);
    }
    return null;
  }

  Future<Banner?> updateBannerPhoto(File image, int id) async {
    try {
      uploadedImage.value =
          await _homePageRepository.updateBannerPhoto(image, id);
      return uploadedImage.value;
    } on Object catch (_) {
      showErrorSnackBar(message: failedUploadHomeBanner.tr);
    }
    return null;
  }

  void _initInternetListener() {
    _internetCheckerListener =
        getIt<InternetConnectionChecker>().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            _appController.isDeviceConnected = true;
            Get.back();
            break;
          case InternetConnectionStatus.disconnected:
            _appController.isDeviceConnected = false;
            Get.toNamed(notInternetRoute);
            break;
        }
      },
    );
  }
}

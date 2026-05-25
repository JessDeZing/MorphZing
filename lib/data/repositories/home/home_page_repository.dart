import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:morphzing/data/api/home_page_api.dart';
import 'package:morphzing/data/models/home_page/banner.dart';
import 'package:morphzing/data/models/home_page/home_page_images.dart';

const _isSubscriptionShown = 'isSubscriptionShown';

@singleton
class HomePageRepository {
  final HomePageApi _homePageApi;
  final GetStorage _getStorage;

  const HomePageRepository(
    this._homePageApi,
    this._getStorage,
  );

  Future<HomePageImages> getHomePageImage() async {
    return await _homePageApi.getHomePageImage();
  }

  Future<Banner> uploadBannerPhoto(File image) async {
    return await _homePageApi.uploadBannerPhoto(image);
  }

  Future<Banner> updateBannerPhoto(File image, int id) async {
    return await _homePageApi.updateBannerPhoto(image, id);
  }

  Future<bool> getSubscriptionShown() async {
    final result = _getStorage.read(_isSubscriptionShown);
    return result ?? false;
  }

  Future<void> setSubscriptionShown() async {
    await _getStorage.write(_isSubscriptionShown, true);
  }
}

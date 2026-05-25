import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/about_app_model.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/faqs.dart';
import 'package:morphzing/data/repositories/dashboard/dashboard_repository.dart';
import 'package:morphzing/data/repositories/profile_menu/about_the_app_repository.dart';
import 'package:morphzing/di/di_config.dart';

class DisclaimerController extends GetxController {
  final _aboutTheAppRepository = getIt<AboutTheAppRepository>();
  List<AboutAppModel> listOfDisclaimers = [];
  RxBool pageLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await getDisclaimers();
    pageLoading.value = false;
  }

  Future<List<AboutAppModel>?> getDisclaimers() async {
    try {
      final response = await _aboutTheAppRepository.getDisclaimers();
      listOfDisclaimers = response;
      return response;
    } on DioError catch (e) {
      log('fetch disclaimers ${e.response}');
    }
    return null;
  }
}

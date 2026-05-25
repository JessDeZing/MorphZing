import 'package:get/get.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/about_app_model.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/faqs.dart';
import 'package:morphzing/data/repositories/profile_menu/about_the_app_repository.dart';
import 'package:morphzing/di/di_config.dart';

class AboutTheAppController extends GetxController {
  final _aboutTheAppRepository = getIt<AboutTheAppRepository>();
  RxBool loading = RxBool(false);
  Rx<FAQs> faq = Rx(FAQs(results: []));
  RxList<AboutAppModel> privacy = RxList([]);
  RxList<AboutAppModel> terms = RxList([]);
  RxList<AboutAppModel> disclaimer = RxList([]);

  Future<void> fetchAboutAppInfo(AboutAppType aboutAppType) async {
    try {
      loading.value = true;
      switch (aboutAppType) {
        case AboutAppType.privacy:
          privacy.value = await _aboutTheAppRepository.getPrivacy();
          return;
        case AboutAppType.terms:
          terms.value = await _aboutTheAppRepository.getTerms();
          return;
        case AboutAppType.disclaimer:
          disclaimer.value = await _aboutTheAppRepository.getDisclaimers();
          return;
      }
    } on Object {
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchFAQs() async {
    try {
      loading.value = true;
      faq.value = await _aboutTheAppRepository.getFaq();
    } on Object {}
    loading.value = false;
  }
}

enum AboutAppType {
  privacy,
  terms,
  disclaimer,
}

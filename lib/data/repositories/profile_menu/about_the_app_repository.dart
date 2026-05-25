import 'package:injectable/injectable.dart';
import 'package:morphzing/data/api/about_the_app_api.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/about_app_model.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/faqs.dart';

@singleton
class AboutTheAppRepository {
  final AboutTheAppApi _aboutTheAppApi;

  AboutTheAppRepository(this._aboutTheAppApi);

  Future<FAQs> getFaq() async {
    return await _aboutTheAppApi.getFaq();
  }

  Future<List<AboutAppModel>> getPrivacy() async {
    return await _aboutTheAppApi.getPrivacy();
  }

  Future<List<AboutAppModel>> getTerms() async {
    return await _aboutTheAppApi.getTerms();
  }

  Future<List<AboutAppModel>> getDisclaimers() async {
    return await _aboutTheAppApi.getDisclaimers();
  }
}

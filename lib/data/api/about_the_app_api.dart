import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/about_app_model.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/faqs.dart';
import 'package:retrofit/retrofit.dart';

part 'about_the_app_api.g.dart';

@singleton
@RestApi()
abstract class AboutTheAppApi {
  @factoryMethod
  factory AboutTheAppApi(Dio dio) = _AboutTheAppApi;

  @GET(FAQ_GET)
  Future<FAQs> getFaq();

  @GET(PRIVACY_POLICY_GET)
  Future<List<AboutAppModel>> getPrivacy();

  @GET(TERMS_GET)
  Future<List<AboutAppModel>> getTerms();

  @GET(DISCLAIMER)
  Future<List<AboutAppModel>> getDisclaimers();
}

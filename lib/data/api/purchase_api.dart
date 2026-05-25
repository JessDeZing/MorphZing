import 'package:injectable/injectable.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/purchase/purchase_template_request.dart';
import 'package:morphzing/data/models/purchase/template.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'purchase_api.g.dart';

@singleton
@RestApi()
abstract class PurchaseApi {
  @factoryMethod
  factory PurchaseApi(Dio dio) = _PurchaseApi;

  @GET(GET_TEMPLATES)
  Future<ApiPagination<Template>> getTemplates(
      {@Query('page') required int page});

  @GET(FREE_TEMPLATES)
  Future<ApiPagination<Template>> getFreeTemplates(
      {@Query('page') required int page});

  @POST(PURCHASE_TEMPLATE)
  Future<void> purchaseTemplate(
      {@Body() required PurchaseTemplateRequest purchaseTemplateRequest});
}

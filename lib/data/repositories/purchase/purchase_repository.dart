import 'package:injectable/injectable.dart';
import 'package:morphzing/data/api/purchase_api.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/purchase/purchase_template_request.dart';
import 'package:morphzing/data/models/purchase/template.dart';

@singleton
class PurchaseRepository {
  final PurchaseApi _purchaseApi;

  const PurchaseRepository(this._purchaseApi);

  Future<ApiPagination<Template>> getTemplates({required int page}) async {
    return await _purchaseApi.getTemplates(page: page);
  }

  Future<ApiPagination<Template>> getFreeTemplates({required int page}) async {
    return await _purchaseApi.getFreeTemplates(page: page);
  }

  Future<void> purchaseTemplate({
    required int id,
    required bool isBuying,
  }) async {
    await _purchaseApi.purchaseTemplate(
        purchaseTemplateRequest: PurchaseTemplateRequest(
      premiumTemplate: id,
      isPurchased: isBuying,
    ));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/purchase/template.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:morphzing/data/repositories/purchase/purchase_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/presentation/pages/screens/subscription/subscription_controller.dart';
import 'package:morphzing/utils/loading_overlay.dart';

class TemplatesController extends GetxController {
  RxBool pageLoading = true.obs;
  RxBool newPremiumLoading = false.obs;
  RxBool newFreeLoading = false.obs;
  RxList<Template> templateList = RxList([]);
  RxList<Template> freeTemplateList = RxList([]);
  final _purchaseRepository = getIt<PurchaseRepository>();
  final _subscriptionController = Get.find<SubscriptionController>();
  final _appController = Get.find<AppController>();
  int _currentPagePremium = 1;
  int _currentPageFree = 1;
  bool premiumLastPage = false;
  bool freeLastPage = false;
  Rx<Template?> chosenTemplate = Rx(null);

  @override
  void onInit() async {
    super.onInit();
    await getTemplates();
    await getFreeTemplates();
    pageLoading.value = false;
  }

  Future<void> getTemplates() async {
    try {
      if (premiumLastPage) {
        return;
      }
      if (_currentPagePremium > 1) {
        newPremiumLoading.value = true;
      }
      final response =
          await _purchaseRepository.getTemplates(page: _currentPagePremium);
      templateList.addAll(response.data);
      premiumLastPage = templateList.length == response.total;
      newPremiumLoading.value = false;
      _currentPagePremium++;
    } on Object catch (e) {
      debugPrint('error in fetching templates ${e.toString()}');
    }
  }

  Future<void> getFreeTemplates() async {
    try {
      if (freeLastPage) {
        return;
      }
      if (_currentPageFree > 1) {
        newFreeLoading.value = true;
      }
      final response =
          await _purchaseRepository.getFreeTemplates(page: _currentPageFree);
      freeTemplateList.addAll(response.data);
      freeLastPage = freeTemplateList.length == response.total;
      newFreeLoading.value = false;
      _currentPageFree++;
    } on Object catch (e) {
      debugPrint('error in fetching free templates ${e.toString()}');
    }
  }

  Future<void> purchaseTemplate({
    required BuildContext context,
    required int index,
  }) async {
    if (templateList[index].isPurchased) {
      return;
    }
    if (_appController.user?.paymentStatus == SubscriptionType.free) {
      await _buyTemplate(
        context: context,
        index: index,
        isBuying: true,
      );
      return;
    }
    var templateCounter = _appController.user!.templateCounter;
    if ((templateCounter < 3 &&
            _appController.user!.paymentStatus == SubscriptionType.basic) ||
        (templateCounter < 7 &&
            (_appController.user!.paymentStatus == SubscriptionType.premium ||
                _appController.user!.paymentStatus ==
                    SubscriptionType.familyShare))) {
      final total =
          _appController.user!.paymentStatus == SubscriptionType.basic ? 3 : 7;
      CustomDialogs.show(
        context: context,
        title:
            '${thisWillBeYour.tr} ${templateCounter + 1}/$total ${freePremiumTemplate.tr}',
        onPressLeftButton: () {
          Navigator.pop(context);
          return;
        },
        onPressRightButton: () async {
          Navigator.pop(context);
          await _buyTemplate(
            context: context,
            index: index,
            isBuying: false,
          );
        },
      );
    } else {
      await _buyTemplate(
        context: context,
        index: index,
        isBuying: true,
      );
    }
  }

  Future<void> chooseTemplate({
    required Template template,
    required BuildContext context,
    required int index,
  }) async {
    if (template.isPurchased) {
      chosenTemplate.value = template;
      update([123]);
    } else {
      await purchaseTemplate(
        context: context,
        index: index,
      );
    }
  }

  Future<void> _buyTemplate({
    required BuildContext context,
    required int index,
    required bool isBuying,
  }) async {
    LoadingOverlay.show(context);
    await _subscriptionController.purchaseTemplate(
      templates: templateList,
      index: index,
      isBuying: isBuying,
    );
    LoadingOverlay.hide();
  }
}

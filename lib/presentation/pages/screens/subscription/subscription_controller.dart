import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/purchase/template.dart';
import 'package:morphzing/data/repositories/purchase/purchase_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/home/home_controller.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

const _iosKey = 'appl_xOvPATHTMWFUSgWtPGiwNRgvKGL';
const _androidKey = 'goog_FqsaENqzXBMtOGIVOWfbrDfRQaU';

class SubscriptionController extends GetxController {
  RxBool pageLoading = true.obs;
  final _appController = Get.find<AppController>();
  final _purchaseRepository = getIt<PurchaseRepository>();
  RxList<Package> products = RxList([]);

  @override
  void onInit() async {
    super.onInit();
    await initPlatformState(_appController.user!.id).then((_) async {
      await getOfferings();
    });
    pageLoading.value = false;
  }

  Future<void> initPlatformState(int userId) async {
    await Purchases.setLogLevel(LogLevel.info);

    late PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(_androidKey);
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(_iosKey);
    }
    configuration.appUserID = userId.toString();
    await Purchases.configure(configuration);
    final loggedUser = await Purchases.logIn(userId.toString());
  }

  Future<Offerings?> getOfferings() async {
    pageLoading.value = true;
    try {
      Offerings offerings = await Purchases.getOfferings();
      final allPackages = offerings.getOffering('Default');
      if (allPackages != null && allPackages.availablePackages.isNotEmpty) {
        for (final package in allPackages.availablePackages) {
          products.add(package);
          // Print product details
        print('Product ID: ${package}');
       
        }
      }
      products.removeWhere(
          (element) => element.storeProduct.subscriptionPeriod == null);
      products.sort(
          (a, b) => (a.storeProduct.price - b.storeProduct.price).toInt());
      pageLoading.value = false;
      return offerings;
    } on PlatformException catch (e) {
      debugPrint('offer error $e');
      //showGetSnackBar(message: 'Failed to fetch offerings $e');
    } on Object catch (_) {
      showErrorSnackBar(
          message: fetchOfferingFail.tr);
    }
    pageLoading.value = false;
    return null;
  }

  Future<void> makePurchase(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.activeSubscriptions.isNotEmpty) {
        await Purchases.purchasePackage(package,
            upgradeInfo: UpgradeInfo(
              customerInfo.activeSubscriptions.first,
              prorationMode: ProrationMode.immediateWithTimeProration,
            ));
      } else {
        await Purchases.purchasePackage(package);
      }
      Get.find<HomeController>().fetchUserInfo();
      var isPro =
          customerInfo.entitlements.all["is_pro_user"]?.isActive ?? false;
      if (isPro) {
        // Unlock that great "pro" content
      }
    } on PlatformException catch (e) {
      /*showGetSnackBar(
          message: '${e.message}\n${e.details['underlyingErrorMessage']}');*/
    }
  }

  Future<bool> getSubscriptionStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all["isProUser"]?.isActive ?? false;
    } on PlatformException catch (e) {
      print('qqqq');
      // Error fetching purchaser info
      //showGetSnackBar(message: e.message.toString());
      return false;
    }
  }

  Future<void> cancelSubscription(String id) async {
    try {
      if (id.contains(':')) {
        await Purchases.purchaseProduct(id.substring(0, id.indexOf(':')));
      } else {
        await Purchases.purchaseProduct(id);
      }
      Get.find<HomeController>().fetchUserInfo();
    } on Object catch (e) {
      debugPrint('error while canceling ${e.toString()}');
    }
  }

  Future<void> purchaseTemplate({
    required RxList<Template> templates,
    required int index,
    required bool isBuying,
  }) async {
    try {
      final item = templates[index];
      if (isBuying) {
        await Purchases.purchaseProduct(item.categoryId,
            type: PurchaseType.inapp);
      }
      await _purchaseRepository.purchaseTemplate(
        id: item.id,
        isBuying: isBuying,
      );
      Get.find<HomeController>().fetchUserInfo();
      templates[index] = templates[index].copyWith(isPurchased: true);
    } on Object catch (e) {
      if (e is PlatformException) {
        //showGetSnackBar(message: e.message.toString());
      } else {
        showErrorSnackBar(message: purchaseTemplateFail.tr);
      }
    }
  }

  Future<void> restorePurchase() async {
    try {
      await Purchases.restorePurchases();
    } on Object {}
  }

  Future<void> logOut() async {
    await Purchases.logOut();
  }
}

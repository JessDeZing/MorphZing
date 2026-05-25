import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/subscription/subscription_controller.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/verified_row.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class SubscriptionPremium extends StatelessWidget {
  final bool isCurrentPlan;

  const SubscriptionPremium({
    Key? key,
    this.isCurrentPlan = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Get.find<SubscriptionController>().products.last;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewPadding.bottom + 24,
        top: 24,
        left: 8,
        right: 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? darkBgColor : bgColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/local_play.svg',
                  color: selfCareColor,
                  height: 80,
                  width: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  allSubscriptionHeader.tr,
                  style: customTextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'MorphZing Premium',
                  style: customTextStyle(
                    fontSize: 22,
                    color: isDark ? Colors.white : blackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Text(
                      subscriptionIncludes.tr,
                      style: customTextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white : blackTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                VerifiedRow(text: 'Unlimited ${tasksAndTodos.tr}'),
                const SizedBox(height: 20),
                VerifiedRow(text: 'Unlimited ${journalsPerMonth.tr}'),
                const SizedBox(height: 20),
                VerifiedRow(text: 'Unlimited ${notesPerMonth.tr}'),
                const SizedBox(height: 20),
                VerifiedRow(text: 'Unlimited ${eventsPerMonth.tr}'),
                const SizedBox(height: 20),
                VerifiedRow(text: '50 ${uploadPhotosInAll.tr}'),
                const SizedBox(height: 20),
                VerifiedRow(
                    text:
                        '${freeBasicTemplates.tr} ${plus.tr} 7 ${premiumTemplates.tr}'),
                const SizedBox(height: 160),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/subscription/premium_bm_image_lamp.png',
              height: 100,
              width: 100,
            ),
          ),
          Positioned(
            top: 0,
            right: -5,
            bottom: 0,
            child: Image.asset(
              'assets/images/subscription/premium_bm_image_badge.png',
              height: 87,
              width: 87,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ColoredBox(
              color: isDark ? darkBgColor : whiteColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryButton(
                    buttonColor: selfCareColor,
                    buttonText: isCurrentPlan
                        ? currentPlan.tr
                        : '${product.storeProduct.priceString}/${mo.tr.toLowerCase()}',
                    onPressed: () async {
                      LoadingOverlay.show(context);
                      await Get.find<SubscriptionController>()
                          .makePurchase(product);
                      LoadingOverlay.hide();
                      Navigator.of(context).pop();
                    },
                    textColor: isDark ? darkBgColor : whiteColor,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      LoadingOverlay.show(context);
                      await Get.find<SubscriptionController>()
                          .restorePurchase();
                      LoadingOverlay.hide();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      restorePurchase.tr,
                      style: customTextStyle(
                        fontSize: 14,
                        color: blueColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(termsOfUseRoute),
                        child: Text(
                          termsOfUse.tr,
                          style: customTextStyle(
                            fontSize: 15,
                            color: isDark ? Colors.white : greyTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '&',
                        style: customTextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white : greyTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => Get.toNamed(privacyPolicyRoute),
                        child: Text(
                          privacyPolicy.tr,
                          style: customTextStyle(
                            fontSize: 15,
                            color: isDark ? Colors.white : greyTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

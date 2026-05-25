import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/verified_row.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/style/colors.dart';

class SubscriptionFree extends StatelessWidget {
  final bool isCurrentPlan;

  const SubscriptionFree({
    Key? key,
    this.isCurrentPlan = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewPadding.bottom,
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
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/local_play.svg',
                  color: blueColor,
                  height: 80,
                  width: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  allSubscriptionHeader.tr,
                  style: customTextStyle(
                    fontSize: 14,
                    color: greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'MorphZing Free',
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
                VerifiedRow(text: '5 ${tasksAndTodos.tr}'),
                const SizedBox(height: 20),
                VerifiedRow(text: '5 ${journalsPerMonth.tr}'),
                const SizedBox(height: 20),
                VerifiedRow(text: '5 ${notesPerMonth.tr}'),
                const SizedBox(height: 20),
                VerifiedRow(text: '5 ${eventsPerMonth.tr}'),
                const SizedBox(height: 20),
                VerifiedRow(text: '5 ${uploadPhotosInAll.tr}'),
                const SizedBox(height: 20),
                VerifiedRow(text: freeBasicTemplates.tr),
                const SizedBox(height: 160),
              ],
            ),
          ),
          Positioned(
            bottom: 85,
            right: -20,
            child: Image.asset(
              'assets/images/subscription/free_bm_image.png',
              height: 130,
              width: 130,
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
                    buttonColor: blueColor,
                    buttonText: isCurrentPlan ? currentPlan.tr : 'Free',
                    onPressed: () => Navigator.pop(context),
                    textColor: isDark ? darkBgColor : whiteColor,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

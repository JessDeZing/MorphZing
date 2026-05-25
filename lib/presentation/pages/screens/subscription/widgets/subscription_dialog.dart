import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_bottom_sheet.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/style/colors.dart';

class SubscriptionDialog extends StatelessWidget {
  const SubscriptionDialog({Key? key}) : super(key: key);

  static Future show({required BuildContext context}) => showDialog(
        context: context,
        builder: (_) => MediaQuery(
          data: MediaQuery.of(context).removePadding(),
          child: const Center(child: SubscriptionDialog()),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
                color: isDark ? darkBgColor : whiteColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/local_play.svg',
                  height: 80,
                  width: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  'MorphZing Basic',
                  style: customTextStyle(
                    fontSize: 22,
                    color: isDark ? Colors.white : blackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  basicDialogDescription.tr,
                  style: customTextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                PrimaryButton(
                  buttonColor: subButtonColor,
                  buttonText: learnMore.tr,
                  onPressed: () {
                    // SubscriptionBottomSheet.show(context: context)
                    Navigator.pushNamed(context, subscriptionPlanRoute).then(
                      (_) => Navigator.of(context).pop(),
                    );
                  },
                  textColor: whiteColor,
                ),
              ],
            ),
          ),
          Positioned(
            child: Image.asset(
              'assets/images/subscription/calendar_sub.png',
              height: 74,
              width: 74,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 70,
            child: Image.asset(
              'assets/images/subscription/book_sub.png',
              height: 74,
              width: 74,
            ),
          ),
        ],
      ),
    );
  }
}

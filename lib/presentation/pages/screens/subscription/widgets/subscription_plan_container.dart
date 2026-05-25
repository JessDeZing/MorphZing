import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_bottom_sheet.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/style/colors.dart';

class SubscriptionPlanContainer extends StatelessWidget {
  final SubscriptionType subscriptionType;

  const SubscriptionPlanContainer({
    Key? key,
    required this.subscriptionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mySubscriptionPlan.tr,
          style: customTextStyle(
            fontSize: 22,
            color: isDark ? Colors.white : blackTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? darkBgColor : bgColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      subscriptionText,
                      style: customTextStyle(
                        fontSize: 18,
                        color: subscriptionColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/local_play.svg',
                    height: 24,
                    width: 24,
                    color: subscriptionColor,
                  )
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  subscriptionDescription,
                  style: customTextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white : greyTextColor,
                    fontWeight: FontWeight.w400,
                  ).copyWith(height: 16 / 12),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pushNamed(context, subscriptionPlanRoute);
            // SubscriptionBottomSheet.show(context: context);
            // above one is prev sheet for reference
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: isDark ? darkBgColor : bgColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/local_play.svg',
                  height: 22,
                  width: 22,
                  color: isDark ? Colors.white : blackTextColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(
                  subscriptionType == SubscriptionType.free
                      ? subscribeForMoreFeatures.tr
                      : changeSubscriptionPlan.tr,
                  style: customTextStyle(
                    fontSize: 17,
                    color: isDark ? Colors.white : blackTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                )),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Colors.white : blackTextColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String get subscriptionText {
    switch (subscriptionType) {
      case SubscriptionType.free:
        return 'MorphZing Free';
      case SubscriptionType.basic:
        return 'MorphZing Basic';
      case SubscriptionType.familyShare:
      case SubscriptionType.premium:
        return 'MorphZing Premium';
    }
  }

  Color get subscriptionColor {
    switch (subscriptionType) {
      case SubscriptionType.free:
        return blueColor;
      case SubscriptionType.basic:
        return subButtonColor;
      case SubscriptionType.familyShare:
      case SubscriptionType.premium:
        return selfCareColor;
    }
  }

  String get subscriptionDescription {
    switch (subscriptionType) {
      case SubscriptionType.free:
        return freeDescription.tr;
      case SubscriptionType.basic:
        return basicDescription.tr;
      case SubscriptionType.familyShare:
      case SubscriptionType.premium:
        return premiumDescription.tr;
    }
  }
}

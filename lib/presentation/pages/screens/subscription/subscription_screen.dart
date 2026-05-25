import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/subscription/subscription_controller.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_plan_container.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_status_container.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/constants/style.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final subscriptionController = Get.find<SubscriptionController>();
    print('appController.user!.paymentStatus');

    print(' sanaaa ${subscriptionController.products}');
    print(' HI SANAAAA ${appController.user!.paymentStatus}');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? darkBgColor : whiteColor,
      appBar: StaticAppBar.noSubButtonBar(
        context: context,
        title: subscription.tr,
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).removePadding(),
        child: Obx(() {
          return Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    if (appController.user!.paymentStatus !=
                        SubscriptionType.familyShare) ...[
                      SubscriptionStatusContainer(
                        isActive: appController.user!.paymentStatus ==
                                SubscriptionType.basic ||
                            appController.user!.paymentStatus ==
                                SubscriptionType.premium,
                        price:
                            '\$${appController.user?.userSubscription.price}',
                        chargeDate:
                            appController.user?.userSubscription.endDate,
                      ),
                      const SizedBox(height: 30),
                    ],
                    SubscriptionPlanContainer(
                        subscriptionType: appController.user!.paymentStatus),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewPadding.bottom + 24,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      howtoCancelSubscription.trParams({
                        'account': Platform.isIOS ? 'Apple' : 'Play Market'
                      }),
                      textAlign: TextAlign.center,
                      style: customTextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white : blackTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    PrimaryButton(
                      buttonColor: isDark ? darkBgColor : bgColor,
                      buttonText: manageSubscription.tr,
                      onPressed: () {
                        if (Platform.isIOS) {
                          AppSettings.openAppSettings(
                              type: AppSettingsType.subscriptions,
                              asAnotherTask: true);
                        } else {
                          launchUrlString(
                              'https://play.google.com/store/account/subscriptions?package=com.jafton.morphzing');
                        }
                      },
                      textColor: blueColor,
                    )
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

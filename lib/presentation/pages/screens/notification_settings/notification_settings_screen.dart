import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/notification/notification_response.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/notification_settings/notification_settings_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/utils/style/colors.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: StaticAppBar.homeAppBar(
        context,
        notificationSettings.tr,
        false,
        '',
      ),
      body: GetX<NotificationSettingsController>(
        init: NotificationSettingsController(),
        builder: (controller) {
          return controller.pageLoading.value
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        preferReceiveNotification.tr,
                        style: customTextStyle(
                          fontSize: 20,
                          color: isDark ? Colors.white : blackTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notifyMe.tr,
                        style: customTextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white : greyTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      controller.notifications.isEmpty
                          ? const Center(
                              child: CircularProgressIndicator.adaptive(),
                            )
                          : Container(
                              padding: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(
                                color: isDark ? darkBgColor : Color(0xFFF6F6F6),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    // smsMessage.tr,
                                    controller.smsMessageValue.value
                                        ? yes.tr
                                        : no.tr,
                                    style: customTextStyle(
                                      fontSize: 15,
                                      color: isDark
                                          ? Colors.white
                                          : blackTextColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(),
                                  Switch(
                                    value: controller.smsMessageValue.value,
                                    onChanged: (value) =>
                                        controller.switchSmsMessageValue(
                                      value,
                                      controller.notifications.first
                                          .copyWith(smsMessage: value),
                                    ),
                                    inactiveThumbColor:
                                        isDark ? Colors.white : blackTextColor,
                                    inactiveTrackColor:
                                        greyTextColor.withOpacity(0.3),
                                    activeColor: blueColor,
                                    activeTrackColor: isDark
                                        ? Colors.white
                                        : blueColor.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}

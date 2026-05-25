import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:morphzing/logic/controllers/profile/profile_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
import 'package:morphzing/utils/style/colors.dart';

class NewPasswordScreen extends StatefulWidget {
  final bool? isForgot;
  const NewPasswordScreen({Key? key, this.isForgot}) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      return Scaffold(
        appBar: StaticAppBar.customAppBar(context, 'New phone number'),
        body: controller.loading.value
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 16),
                      children: [
                        Text(
                          "What is your new password?",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Color(0xFF050A41),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          hintText: "New Password",
                          labelText: "New Password",
                          textEditingController:
                              controller.newPasswordController,
                          onChanged: (v) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomInputField(
                          hintText: "Confirm Password",
                          labelText: "Confirm Password",
                          textEditingController:
                              controller.confirmPasswordController,
                          onChanged: (v) {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: controller.confirmPasswordController.text ==
                                controller.newPasswordController.text &&
                            controller.confirmPasswordController.text.length >
                                7 &&
                            controller.newPasswordController.text.length > 7
                        ? widget.isForgot ?? false
                            ? () {
                                controller.onResetPassword(context);
                              }
                            : controller.onSavePassword
                        : null,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: Platform.isAndroid ? 16 : 0,
                      ),
                      padding: const EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: controller.confirmPasswordController.text ==
                                    controller.newPasswordController.text &&
                                controller
                                        .confirmPasswordController.text.length >
                                    7 &&
                                controller.newPasswordController.text.length > 7
                            ? blueColor
                            : dowThisMonthCalendar,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? darkBgColor : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SafeArea(child: SizedBox.shrink())
                ],
              ),
      );
    });
  }
}

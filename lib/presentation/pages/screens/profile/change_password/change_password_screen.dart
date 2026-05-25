import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/logic/controllers/profile/profile_controller.dart';
import 'package:morphzing/presentation/pages/screens/profile/change_password/change_password_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<ChangePasswordController>(
      init: ChangePasswordController(),
      builder: (controller) {
        return Scaffold(
          appBar: StaticAppBar.customAppBar(context, password.tr),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  16.verticalSpace,
                  CustomInputField(
                    hintText: oldPassword.tr,
                    labelText: oldPassword.tr,
                    textEditingController: _oldPasswordController,
                    onChanged: (v) {
                      controller.oldPassword = v;
                    },
                  ),
                  16.verticalSpace,
                  CustomInputField(
                    hintText: newPassword.tr,
                    labelText: newPassword.tr,
                    textEditingController: _newPasswordController,
                    onChanged: (v) {
                      controller.newPassword = v;
                    },
                  ),
                  16.verticalSpace,
                  CustomInputField(
                    hintText: confirmPassword.tr,
                    labelText: confirmPassword.tr,
                    textEditingController: _confirmPasswordController,
                    onChanged: (v) {
                      controller.confirmPassword = v;
                    },
                  ),
                  const Spacer(),
                  Obx(() {
                    return CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: controller.isValidate()
                          ? () async {
                              LoadingOverlay.show(context);
                              await controller
                                  .onPressedContinue()
                                  .then((value) async {
                                if (value) {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text(
                                              yourPasswordHasBeenSuccessfullyChanged
                                                  .tr),
                                          actions: <Widget>[
                                            CupertinoButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); //close Dialog
                                              },
                                              child: Text(great.tr),
                                            ),
                                          ],
                                        );
                                      });
                                  Get.back();
                                } else {
                                  showErrorSnackBar(
                                      message: changePasswordErrorMessage.tr);
                                }
                              });
                            }
                          : null,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: controller.isValidate()
                              ? blueColor
                              : dowThisMonthCalendar,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          continueKey.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                  24.verticalSpace,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

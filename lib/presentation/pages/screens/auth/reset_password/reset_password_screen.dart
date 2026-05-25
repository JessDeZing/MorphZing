import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/reset_password/reset_password_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordController controller = ResetPasswordController();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<ResetPasswordController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: StaticAppBar.customAppBar(context, login.tr),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(
                  FocusNode(),
                );
              },
              child: SafeArea(
                child: Container(
                    padding: const EdgeInsets.all(16),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: isDark ? darkBgColor : whiteColor,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: CustomInputField(
                                  hintText: newPassword.tr,
                                  labelText: newPassword.tr,
                                  textEditingController: newPasswordController,
                                  onChanged: (value) =>
                                      controller.newPassword = value,
                                ),
                              ),
                              CustomInputField(
                                hintText: confirmPassword.tr,
                                labelText: confirmPassword.tr,
                                textEditingController:
                                    confirmPasswordController,
                                onChanged: (value) =>
                                    controller.confirmPassword = value,
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          return ElevatedButton(
                            onPressed: controller.isValidate()
                                ? () {
                                    LoadingOverlay.show(context);
                                    controller.onPressedContinue();
                                  }
                                : null,
                            child: Text(continueKey.tr),
                          );
                        }),
                      ],
                    )),
              ),
            ),
          ),
        );
      },
    );
  }
}

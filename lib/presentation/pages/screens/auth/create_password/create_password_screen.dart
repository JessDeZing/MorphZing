import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/create_password/create_password_controller.dart';
import 'package:morphzing/presentation/pages/screens/auth/verification/verification_screen.dart';

import '../../../../../utils/style/colors.dart';
import '../../../../routers/rout_names.dart';
import '../../../../widgets/app_bar.dart';
import '../../../../widgets/input_field.dart';

class CreatePasswordScreenParam {
  final VerificationType verificationType;
  final String secretKey;

  CreatePasswordScreenParam({
    required this.verificationType,
    required this.secretKey,
  });
}

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final CreatePasswordController controller = CreatePasswordController();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<CreatePasswordController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: StaticAppBar.customAppBar(context, 'Sign up'),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(
                  FocusNode(),
                );
              },
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
                              padding: EdgeInsets.only(top: 14, bottom: 20),
                              child: Text(
                                createPassword.tr,
                                style: TextStyle(
                                  color: isDark ? Colors.white : blackTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 34,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: CustomInputField(
                                hintText: password.tr,
                                labelText: password.tr,
                                textEditingController: passwordController,
                                onChanged: (value) {
                                  controller.password = value;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: CustomInputField(
                                hintText: confirmPassword.tr,
                                labelText: confirmPassword.tr,
                                textEditingController:
                                    confirmPasswordController,
                                onChanged: (value) {
                                  controller.confirmPassword = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() {
                        return ElevatedButton(
                          onPressed: controller.isValidate()
                              ? () => controller.onPressedContinue()
                              : null,
                          child: Text(
                            continueKey.tr,
                          ),
                        );
                      }),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}

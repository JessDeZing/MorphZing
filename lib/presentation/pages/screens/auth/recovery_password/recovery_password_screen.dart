import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/recovery_password/recovery_password_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class RecoveryPasswordScreen extends StatefulWidget {
  const RecoveryPasswordScreen({super.key});

  @override
  State<RecoveryPasswordScreen> createState() => _RecoveryPasswordScreenState();
}

class _RecoveryPasswordScreenState extends State<RecoveryPasswordScreen> {
  final RecoveryPasswordController controller = RecoveryPasswordController();

  final TextEditingController emailPhoneTextController =
      TextEditingController();
  final MaskTextInputFormatter maskTextInputFormatter = MaskTextInputFormatter(
    mask: '+1 (###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    emailPhoneTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<RecoveryPasswordController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? Theme.of(context).scaffoldBackgroundColor : bgColor,
          appBar: StaticAppBar.customAppBar(context, login.tr),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    recoveryPassword.tr,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Color(0xFF050A41),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recoveryPasswordDesc.tr,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : Color(0xFF676A8B),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    hintText: phone.tr,
                    labelText: phone.tr,
                    textEditingController: emailPhoneTextController,
                    inputFormatters: [maskTextInputFormatter],
                    onChanged: (value) {
                      controller.phone =
                          '1${maskTextInputFormatter.unmaskText(value)}';
                    },
                  ),
                  const Spacer(),
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
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

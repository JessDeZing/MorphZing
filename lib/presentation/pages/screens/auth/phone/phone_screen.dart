import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/phone/phone_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
import 'package:morphzing/utils/loading_overlay.dart';

class PhoneScreenParam {
  final String secretKey;
  final String? email;

  PhoneScreenParam({required this.secretKey, this.email});
}

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final PhoneController controller = PhoneController();

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
    return GetBuilder<PhoneController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: StaticAppBar.customAppBar(context, login.tr),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    phone.tr,
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

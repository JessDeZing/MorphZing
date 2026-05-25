import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/phone/phone_controller.dart';
import 'package:morphzing/presentation/pages/screens/profile/current_phone/current_phone_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
import 'package:morphzing/utils/loading_overlay.dart';

class CurrentPhoneScreen extends StatefulWidget {
  const CurrentPhoneScreen({super.key});

  @override
  State<CurrentPhoneScreen> createState() => _CurrentPhoneScreenState();
}

class _CurrentPhoneScreenState extends State<CurrentPhoneScreen> {
  final CurrentPhoneController controller = CurrentPhoneController();

  final TextEditingController emailPhoneTextController = TextEditingController();
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
    return GetBuilder<CurrentPhoneController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: StaticAppBar.customAppBar(context, phone.tr),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  Text(
                    'You can change your phone number at any time',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF676A8B),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    hintText: phone.tr,
                    labelText: phone.tr,
                    textEditingController: TextEditingController(),
                    inputFormatters: [maskTextInputFormatter],
                    onChanged: (value) {
                      controller.phone = '1${maskTextInputFormatter.unmaskText(value)}';
                    },
                  ),
                  const Spacer(),
                  Obx(() {
                    return ElevatedButton(
                      onPressed: controller.isValidate()
                          ? () {
                              LoadingOverlay.show(context);
                              controller.onPressedChangePhoneNumber();
                            }
                          : null,
                      child: Text(changePhoneNumber.tr),
                    );
                  }),
                  24.verticalSpace
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

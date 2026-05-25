import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/verification/verification_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

enum VerificationType {
  recoveryVerification,
  signUpVerification,
  socialVerification,
  updatePhoneVerification
}

class VerificationScreenParam {
  final VerificationType verificationType;
  final String phone;
  final String? email;
  final String? secretKey;

  VerificationScreenParam({
    required this.verificationType,
    required this.phone,
    this.email,
    this.secretKey,
  });
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final VerificationController controller = VerificationController();

  final TextEditingController verificationTextEditingController =
      TextEditingController();
  final MaskTextInputFormatter maskTextInputFormatter = MaskTextInputFormatter(
    mask: '+# (###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    verificationTextEditingController.dispose();
    super.dispose();
  }

  String appBarTitle() {
    if (controller.param.verificationType ==
        VerificationType.recoveryVerification) return recoveryPassword.tr;
    if (controller.param.verificationType ==
        VerificationType.signUpVerification) return signUp.tr;
    if (controller.param.verificationType ==
        VerificationType.updatePhoneVerification) return phone.tr;

    return signUp.tr;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<VerificationController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          appBar: StaticAppBar.customAppBar(context, appBarTitle()),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Obx(
                () {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: isDark ? darkBgColor : bgColor,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 14, bottom: 4),
                                child: Text(
                                  verification.tr,
                                  style: TextStyle(
                                    color:
                                        isDark ? Colors.white : blackTextColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SF Pro Display',
                                    fontSize: 34,
                                  ),
                                ),
                              ),
                              Text(
                                pleaseEnterTheCode.tr,
                                style: TextStyle(
                                  color: isDark ? Colors.white : hintTextColor,
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${maskTextInputFormatter.maskText(controller.param.phone)}',
                                style: TextStyle(
                                  color: isDark ? Colors.white : blackTextColor,
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 15,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: (controller.timeIsEnded)
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Text(changePhoneNumber.tr,
                                            style:
                                                staticTextStyle(15, blueColor)),
                                      )
                                    : Container(),
                              ),
                              CustomInputField(
                                hintText: codeVerification.tr,
                                textEditingController:
                                    verificationTextEditingController,
                                labelText: codeVerification.tr,
                                maxLength: 6,
                                onChanged: (value) =>
                                    controller.verificationCode = value,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Container(
                                  width: 66,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: bgColor,
                                  ),
                                  child: Center(
                                    child: (controller.timeIsEnded)
                                        ? GestureDetector(
                                            onTap: () {
                                              /// TODO
                                              LoadingOverlay.show(context);
                                              controller.retrySms();
                                            },
                                            child: Icon(
                                              Icons.refresh,
                                              color: isDark
                                                  ? Colors.white
                                                  : blackTextColor,
                                              size: 20,
                                            ),
                                          )
                                        : Text(
                                            controller.endTime.toString(),
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : blackTextColor,
                                              fontFamily: 'SF Pro Display',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                    onPressed: controller.isValidate()
                                        ? () {
                                            LoadingOverlay.show(context);
                                            controller.onPressedContinue();
                                          }
                                        : null,
                                    child: Text(continueKey.tr)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

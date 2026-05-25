import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/signup/sign_up_controller.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
// import 'package:morphzing/presentation/widgets/social_component.dart';
import 'package:morphzing/presentation/widgets/twilio_sms_consent.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController controller = SignUpController();

  final TextEditingController phoneTextController = TextEditingController();
  final MaskTextInputFormatter maskTextInputFormatter = MaskTextInputFormatter(
    mask: '+1 (###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    phoneTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<SignUpController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
          backgroundColor: isDark ? darkBgColor : whiteColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: isDark ? darkBgColor : bgColor,
            centerTitle: true,
            title: Text(
              signUp.tr,
              style: TextStyle(
                color: isDark ? Colors.white : blackTextColor,
                fontFamily: 'SF Pro Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(
                        FocusNode(),
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                              top: 30,
                              left: 30,
                              right: 30,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GradientText(
                                  'M',
                                  style: TextStyle(
                                    color:
                                        isDark ? Colors.white : blackTextColor,
                                    fontSize: 34,
                                    fontFamily: 'SF Pro Display',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  colors: const [
                                    Colors.red,
                                    Colors.pink,
                                    Colors.purple,
                                    Colors.deepPurple,
                                    Colors.deepPurple,
                                    Colors.indigo,
                                    Colors.blue,
                                    Colors.lightBlue,
                                    Colors.cyan,
                                    Colors.teal,
                                    Colors.green,
                                    Colors.lightGreen,
                                    Colors.lime,
                                    Colors.yellow,
                                    Colors.amber,
                                    Colors.orange,
                                    Colors.deepOrange,
                                  ],
                                ),
                                Text('orph your future',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : blackTextColor,
                                      fontSize: 34,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'into something',
                                  style: TextStyle(
                                    color:
                                        isDark ? Colors.white : blackTextColor,
                                    fontSize: 34,
                                    fontFamily: 'SF Pro Display',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(
                              bottom: 5,
                              left: 30,
                              right: 30,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('ama',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : blackTextColor,
                                      fontSize: 34,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.bold,
                                    )),
                                GradientText(
                                  'Z',
                                  style: TextStyle(
                                    color:
                                        isDark ? Colors.white : blackTextColor,
                                    fontSize: 34,
                                    fontFamily: 'SF Pro Display',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  colors: const [
                                    Colors.red,
                                    Colors.pink,
                                    Colors.purple,
                                    Colors.deepPurple,
                                    Colors.deepPurple,
                                    Colors.indigo,
                                    Colors.blue,
                                    Colors.lightBlue,
                                    Colors.cyan,
                                    Colors.teal,
                                    Colors.green,
                                    Colors.lightGreen,
                                    Colors.lime,
                                    Colors.yellow,
                                    Colors.amber,
                                    Colors.orange,
                                    Colors.deepOrange,
                                  ],
                                ),
                                Text('ing',
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : blackTextColor,
                                      fontSize: 34,
                                      fontFamily: 'SF Pro Display',
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                          ),
                          child: CustomInputField(
                            hintText: phone.tr,
                            labelText: phone.tr,
                            textEditingController: phoneTextController,
                            inputFormatters: [maskTextInputFormatter],
                            onChanged: (value) => controller.phone =
                                '1${maskTextInputFormatter.unmaskText(value)}',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                          ),
                          child: TwilioSmsConsent(
                            smsSendingAccepted:
                                controller.smsTwilioConsentAccepted,
                          ),
                        ),
                        const Spacer(flex: 2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              alreadyHaveAnAccount.tr,
                              style: TextStyle(
                                color: isDark ? Colors.white : greyTextColor,
                                fontFamily: 'SF Pro Display',
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                controller.onPressedLogin();
                              },
                              child: Text(
                                login.tr,
                                style: TextStyle(
                                  color: blueColor,
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        20.verticalSpace,
                        Obx(() {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                            ),
                            child: ElevatedButton(
                              onPressed: controller.isValidate()
                                  ? () {
                                      LoadingOverlay.show(context);
                                      controller.onPressedSignUp();
                                    }
                                  : null,
                              child: Text(signUp.tr),
                            ),
                          );
                        }),
                        32.verticalSpace,
                        SizedBox(
                          height: 25,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Center(
                                child: Container(
                                  height: 1,
                                  width: MediaQuery.of(context).size.width,
                                  color: isDark ? darkBgColor : bgColor,
                                ),
                              ),
                              // Center(
                              //   child: Container(
                              //     height: 25,
                              //     decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
                              //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                              //     child: Text(
                              //       orSignUpWith.tr,
                              //       style: TextStyle(
                              //         color: blackTextColor,
                              //         fontSize: 14,
                              //         fontFamily: 'SF Pro Display',
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        24.verticalSpace,
                        // const SocialComponent(),
                        const Spacer(flex: 2),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              byUsingMorphzingYouAgreeToThe.tr,
                              style: customTextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.white : greyTextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    launchUrlString(
                                        'https://morphzing.com/terms-of-use.html');
                                  },
                                  child: Text(
                                    termsOfUse.tr,
                                    style: customTextStyle(
                                      fontSize: 14,
                                      color: blueColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '&',
                                  style: customTextStyle(
                                    fontSize: 14,
                                    color:
                                        isDark ? Colors.white : greyTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    launchUrlString(
                                        'https://morphzing.com/privacy-policy.html');
                                  },
                                  child: Text(
                                    privacyPolicy.tr,
                                    style: customTextStyle(
                                      fontSize: 14,
                                      color: blueColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        32.verticalSpace,
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

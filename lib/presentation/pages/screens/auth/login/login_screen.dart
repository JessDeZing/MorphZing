import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/auth/login/login_controller.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
// import 'package:morphzing/presentation/widgets/social_component.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = LoginController();

  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final MaskTextInputFormatter maskTextInputFormatter = MaskTextInputFormatter(
    mask: '+1 (###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    phoneTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<LoginController>(
      init: controller,
      builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              backgroundColor: isDark ? darkBgColor : bgColor,
              centerTitle: true,
              title: Text(
                login.tr,
                style: TextStyle(
                  color: isDark ? Colors.white : blackTextColor,
                  fontFamily: 'SF Pro Display',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(
                    FocusNode(),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: isDark ? darkBgColor : whiteColor,
                  child: ListView(
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
                                  color: isDark ? Colors.white : blackTextColor,
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
                                    color:
                                        isDark ? Colors.white : blackTextColor,
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
                              Text('into something',
                                  style: TextStyle(
                                    color:
                                        isDark ? Colors.white : blackTextColor,
                                    fontSize: 34,
                                    fontFamily: 'SF Pro Display',
                                    fontWeight: FontWeight.bold,
                                  )),
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
                                    color:
                                        isDark ? Colors.white : blackTextColor,
                                    fontSize: 34,
                                    fontFamily: 'SF Pro Display',
                                    fontWeight: FontWeight.bold,
                                  )),
                              GradientText(
                                'Z',
                                style: TextStyle(
                                  color: isDark ? Colors.white : blackTextColor,
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
                                    color:
                                        isDark ? Colors.white : blackTextColor,
                                    fontSize: 34,
                                    fontFamily: 'SF Pro Display',
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 5, top: 25),
                        child: CustomInputField(
                          hintText: phone.tr,
                          labelText: phone.tr,
                          textEditingController: phoneTextController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [maskTextInputFormatter],
                          onChanged: (value) {
                            return controller.login =
                                '1${maskTextInputFormatter.unmaskText(value)}';
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 10, top: 5),
                        child: CustomInputField(
                          hintText: password.tr,
                          labelText: password.tr,
                          textEditingController: passwordTextController,
                          onChanged: (value) => controller.password = value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              controller.onPressedForgot();
                            },
                            child: Text(
                              forgotPassword.tr,
                              style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 15,
                                color: blueColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Obx(() {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: controller.isValidate()
                                ? () {
                                    LoadingOverlay.show(context);
                                    controller.onPressedLogin();
                                  }
                                : null,
                            child: Text(login.tr),
                          ),
                        );
                      }),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 24.0),
                      //   child: SizedBox(
                      //     height: 25,
                      //     width: MediaQuery.of(context).size.width,
                      //     child: Stack(
                      //       children: [
                      //         Center(
                      //           child: Container(
                      //             height: 1,
                      //             width: MediaQuery.of(context).size.width,
                      //             color: bgColor,
                      //           ),
                      //         ),
                      //         Center(
                      //           child: Container(
                      //             height: 25,
                      //             decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
                      //             padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      //             child: Text(
                      //               orLogInWith.tr,
                      //               style: TextStyle(
                      //                 color: blackTextColor,
                      //                 fontSize: 14,
                      //                 fontFamily: 'SF Pro Display',
                      //               ),
                      //             ),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // const SocialComponent(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              doNotHaveAnAccountYet.tr,
                              style: TextStyle(
                                color: isDark ? Colors.white : greyTextColor,
                                fontFamily: 'SF Pro Display',
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                controller.onPressedSignUp();
                              },
                              child: Text(
                                signUp.tr,
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
                      )
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/logic/controllers/profile/profile_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
import 'package:morphzing/utils/style/colors.dart';

class OldPasswordScreen extends StatefulWidget {
  const OldPasswordScreen({super.key});

  @override
  State<OldPasswordScreen> createState() => _OldPasswordScreenState();
}

class _OldPasswordScreenState extends State<OldPasswordScreen> {
  final controller = Get.find<ProfileController>();
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      return Scaffold(
          appBar: StaticAppBar.customAppBar(context, 'Password'),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  16.verticalSpace,
                  CustomInputField(
                    hintText: "New Password",
                    labelText: "New Password",
                    textEditingController: controller.newPasswordController,
                    onChanged: (v) {
                      setState(() {});
                    },
                  ),
                  16.verticalSpace,
                  CustomInputField(
                    hintText: "New Password",
                    labelText: "New Password",
                    textEditingController: controller.newPasswordController,
                    onChanged: (v) {
                      setState(() {});
                    },
                  ),
                  16.verticalSpace,
                  CustomInputField(
                    hintText: "Confirm Password",
                    labelText: "Confirm Password",
                    textEditingController: controller.confirmPasswordController,
                    onChanged: (v) {
                      setState(() {});
                    },
                  ),
                  const Spacer(),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: controller.oldPasswordController.text.length > 7
                        ? controller.onCheckPassword
                        : null,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: controller.oldPasswordController.text.length > 7
                            ? blueColor
                            : dowThisMonthCalendar,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        continueKey.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? darkBgColor : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )

          // controller.loading.value
          //     ? const Center(
          //         child: CupertinoActivityIndicator(),
          //       )
          //     : Column(
          //         children: [
          //           Expanded(
          //             child: ListView(
          //               padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          //               children: [
          //                 const Text(
          //                   "What is your password?",
          //                   style: TextStyle(
          //                     fontSize: 34,
          //                     fontWeight: FontWeight.w700,
          //                     color: Color(0xFF050A41),
          //                   ),
          //                 ),
          //                 const SizedBox(height: 20),
          //                 CustomInputField(
          //                   hintText: "Password",
          //                   labelText: "Password",
          //                   textEditingController: controller.oldPasswordController,
          //                   obscureText: showPassword,
          //                   onChanged: (v) {
          //                     setState(() {});
          //                   },
          //                   suffixIcon: CupertinoButton(
          //                     padding: const EdgeInsets.all(0),
          //                     onPressed: () {
          //                       setState(() {
          //                         showPassword = !showPassword;
          //                       });
          //                     },
          //                     child: Icon(
          //                       showPassword ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
          //                       color: const Color(0xFF050A41),
          //                     ),
          //                   ),
          //                 ),
          //                 const SizedBox(height: 10),
          //                 Align(
          //                   alignment: Alignment.centerRight,
          //                   child: CupertinoButton(
          //                     padding: const EdgeInsets.all(0),
          //                     onPressed: () {},
          //                     child: const Text(
          //                       "Forgot Password",
          //                       style: TextStyle(
          //                         fontSize: 15,
          //                         fontWeight: FontWeight.w500,
          //                         color: blueColor,
          //                       ),
          //                     ),
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //           CupertinoButton(
          //             padding: const EdgeInsets.all(0),
          //             onPressed: controller.oldPasswordController.text.length > 7 ? controller.onCheckPassword : null,
          //             child: Container(
          //               margin: EdgeInsets.symmetric(
          //                 horizontal: 16,
          //                 vertical: Platform.isAndroid ? 16 : 0,
          //               ),
          //               padding: const EdgeInsets.all(16),
          //               width: MediaQuery.of(context).size.width,
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(10),
          //                 color: controller.oldPasswordController.text.length > 7 ? blueColor : dowThisMonthCalendar,
          //               ),
          //               alignment: Alignment.center,
          //               child: const Text(
          //                 "Continue",
          //                 style: TextStyle(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.w600,
          //                   color: Colors.white,
          //                 ),
          //               ),
          //             ),
          //           ),
          //           const SafeArea(child: SizedBox.shrink())
          //         ],
          //       ),
          );
    });
  }
}

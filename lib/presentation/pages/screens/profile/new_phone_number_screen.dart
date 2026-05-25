import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:morphzing/logic/controllers/profile/profile_controller.dart';
import 'package:morphzing/presentation/pages/screens/auth/recovery_password/recovery_password_screen.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
import 'package:morphzing/utils/style/colors.dart';

class NewPhoneNumberScreen extends StatefulWidget {
  const NewPhoneNumberScreen({super.key});

  @override
  State<NewPhoneNumberScreen> createState() => _OldPasswordScreenState();
}

class _OldPasswordScreenState extends State<NewPhoneNumberScreen> {
  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: StaticAppBar.customAppBar(context, 'New phone number'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
              children: [
                Text(
                  "What is your new phone number?",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Color(0xFF050A41),
                  ),
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  hintText: "Phone number",
                  labelText: "Phone number",
                  textEditingController: controller.newPhoneNumberController,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '+1 (###) ###-####',
                      filter: {"#": RegExp(r'[0-9]')},
                    ),
                  ],
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => controller.smsVerify(),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: Platform.isAndroid ? 16 : 0,
              ),
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: blueColor,
              ),
              alignment: Alignment.center,
              child: Text(
                "Continue",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? darkBgColor : Colors.white,
                ),
              ),
            ),
          ),
          const SafeArea(child: SizedBox.shrink())
        ],
      ),
    );
  }
}

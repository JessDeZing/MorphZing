import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:morphzing/logic/controllers/profile/profile_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/input_field.dart';
import 'package:morphzing/utils/style/colors.dart';

class NewEmailScreen extends StatefulWidget {
  const NewEmailScreen({super.key});

  @override
  State<NewEmailScreen> createState() => _OldPasswordScreenState();
}

class _OldPasswordScreenState extends State<NewEmailScreen> {
  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: StaticAppBar.customAppBar(context, 'Email'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
              children: [
                Text(
                  "You can change your email at any time",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Color(0xFF676A8B),
                  ),
                ),
                const SizedBox(height: 20),
                CustomInputField(
                  hintText: "Email",
                  labelText: "Enter your email",
                  textEditingController: controller.emailController,
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => Get.back(),
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
                "Save",
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

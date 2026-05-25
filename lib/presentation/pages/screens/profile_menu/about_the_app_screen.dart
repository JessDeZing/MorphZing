import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/logic/controllers/profile_menu/about_the_app_controller.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/utils/style/colors.dart';

class AboutTheAppScreen extends StatelessWidget {
  AboutTheAppScreen({Key? key}) : super(key: key);

  final logic = Get.put(AboutTheAppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StaticAppBar.homeAppBar(context, aboutTheApp.tr, false, ""),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildAboutTitle(
              faq.tr,
              "assets/icons/faq_sv.svg",
              () => Get.toNamed(faqRoute),
              context,
            ),
            const SizedBox(height: 10),
            _buildAboutTitle(
              privacyPolicy.tr,
              "assets/icons/privacy_policy.svg",
              () => Get.toNamed(privacyPolicyRoute),
              context,
            ),
            const SizedBox(height: 10),
            _buildAboutTitle(
              termsOfUse.tr,
              "assets/icons/terms_of_use.svg",
              () => Get.toNamed(termsOfUseRoute),
              context,
            ),
            const SizedBox(height: 10),
            _buildAboutTitle(
              disclaimer.tr,
              "assets/icons/disclaimer.svg",
              () => Get.toNamed(disclaimerRoute),
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTitle(String title, String icon, void Function() onPressed,
      BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? darkBorderColor
              : const Color.fromARGB(255, 238, 238, 238),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          horizontalTitleGap: 0,
          leading: SvgPicture.asset(
            icon,
            color: isDark ? Colors.white : blackTextColor,
            width: 20,
            fit: BoxFit.cover,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

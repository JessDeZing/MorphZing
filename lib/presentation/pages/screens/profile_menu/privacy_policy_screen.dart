import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/about_app_model.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/logic/controllers/profile_menu/about_the_app_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final logic = Get.find<AboutTheAppController>();

  @override
  void initState() {
    super.initState();
    logic.fetchAboutAppInfo(AboutAppType.privacy);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: StaticAppBar.homeAppBar(context, privacyPolicy.tr, false, ""),
        body: logic.loading.value
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : logic.privacy.isNotEmpty
                ? ListView(
                  padding:const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Html(
                        data:
                            logic.privacy.first.localeAnswer(),
                      ),
                      const SafeArea(
                        child: SizedBox(height: 10),
                      ),
                    ],
                  )
                : const Text("Data is empty!"),
      ),
    );
  }
}

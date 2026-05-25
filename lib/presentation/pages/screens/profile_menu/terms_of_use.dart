import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/about_app_model.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/logic/controllers/profile_menu/about_the_app_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';

class TermsOfUseScreen extends StatefulWidget {
  const TermsOfUseScreen({Key? key}) : super(key: key);

  @override
  State<TermsOfUseScreen> createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  final logic = Get.find<AboutTheAppController>();

  @override
  void initState() {
    super.initState();
    logic.fetchAboutAppInfo(AboutAppType.terms);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: StaticAppBar.homeAppBar(context, termsOfUse.tr, false, ""),
        body: logic.loading.value
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : logic.terms.isNotEmpty
                ? ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Html(
                        data: logic.terms.first.localeAnswer(),
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

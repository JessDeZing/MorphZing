import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/about_app_model.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/profile_menu/disclaimer_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<DisclaimerController>(
        init: DisclaimerController(),
        builder: (logic) {
          return Scaffold(
            appBar: StaticAppBar.homeAppBar(context, disclaimer.tr, false, ""),
            body: logic.pageLoading.value
                ? const Center(child: CircularProgressIndicator.adaptive())
                : logic.listOfDisclaimers.isNotEmpty ? ListView(

              padding: const EdgeInsets.all(16),
                    children: [
                      Html(
                        data: logic.listOfDisclaimers.first.localeAnswer(),
                      ),
                    ],
                  ) : const Text('Date is empty'),
          );
        });
  }
}

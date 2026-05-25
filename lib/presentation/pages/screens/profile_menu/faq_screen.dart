import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/about_app_model.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/logic/controllers/profile_menu/about_the_app_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/utils/style/colors.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final logic = Get.find<AboutTheAppController>();

  @override
  void initState() {
    super.initState();
    logic.fetchFAQs();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: StaticAppBar.homeAppBar(context, faq.tr, false, ""),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: logic.loading.value
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : logic.faq.value.results.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: logic.faq.value.results
                            .map(
                              (e) => _buildExpansionTile(
                                e.localQuestion(),
                                e.localeAnswer(),
                              ),
                            )
                            .toList(),
                      ),
                    )
                  : const Text("Data is empty!"),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, String childrenTitle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(0),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        children: [
          Html(
            data: childrenTitle,
            style: {
              '*': Style(
                color: isDark ? whiteColor : Colors.black,
                backgroundColor: Colors.transparent,
              ),
            },
          ),
          const SizedBox(height: 8)
        ],
      ),
    );
  }
}

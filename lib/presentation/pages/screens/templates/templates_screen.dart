import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/templates/templates_controller.dart';
import 'package:morphzing/presentation/pages/screens/templates/widgets/template.dart'
    as ui;
import 'package:morphzing/presentation/widgets/app_bar.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: StaticAppBar.homeAppBar(
        context,
        templates.tr,
        false,
        Get.find<AppController>().user!.imageUrl,
      ),
      body: GetX<TemplatesController>(
        init: TemplatesController(),
        builder: (controller) {
          return controller.pageLoading.value
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : controller.templateList.isEmpty
                  ? Center(child: Text(noTemplatesToShow.tr))
                  : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                        mainAxisExtent: 30 +
                            (MediaQuery.of(context).size.width * 155 / 360),
                      ),
                      itemBuilder: (_, index) {
                        if (!controller.premiumLastPage &&
                            index == controller.templateList.length) {
                          if (!controller.newPremiumLoading.value) {
                            controller.getTemplates();
                          }
                          return const SizedBox.shrink();
                        }
                        final item = controller.templateList[index];
                        return GestureDetector(
                          onTap: () => controller.purchaseTemplate(
                            context: context,
                            index: index,
                          ),
                          child: ui.Template(
                            name: item.name,
                            imageUrl: item.image,
                            isPurchased: item.isPurchased,
                          ),
                        );
                      },
                      itemCount: controller.premiumLastPage
                          ? controller.templateList.length
                          : controller.templateList.length + 1,
                    );
        },
      ),
    );
  }
}

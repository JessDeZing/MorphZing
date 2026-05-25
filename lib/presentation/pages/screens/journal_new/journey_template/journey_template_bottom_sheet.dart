import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/purchase/template.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/journey_template/widgets/template_grid_view.dart';
import 'package:morphzing/presentation/pages/screens/templates/templates_controller.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/style/colors.dart';

class JourneyTemplateBottomSheet extends StatelessWidget {
  //уже выбранный темплейт
  final Template? template;

  const JourneyTemplateBottomSheet({
    Key? key,
    this.template,
  }) : super(key: key);

  static Future<Template?> show({
    required BuildContext context,
    Template? template,
  }) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        builder: (_) {
          return JourneyTemplateBottomSheet(template: template);
        },
      );

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 1,
      expand: false,
      builder: (_, scrollController) => Scaffold(
        backgroundColor: isDark ? darkBgColor : whiteColor,
        body: GetBuilder<TemplatesController>(
          id: 123,
          init: TemplatesController(),
          builder: (controller) {
            return Stack(
              fit: StackFit.expand,
              children: [
                ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      templates.tr.capitalizeFirst.toString(),
                      style: customTextStyle(
                        fontSize: 20,
                        color: isDark ? whiteColor : blackTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TemplateGridView(
                      chooseTemplate: controller.chooseTemplate,
                      templateList: controller.freeTemplateList,
                      chosenTemplate: controller.chosenTemplate.value,
                      gridName: freeTemplate.tr.capitalizeFirst.toString(),
                      lastPage: controller.freeLastPage,
                      newDataLoading: controller.newFreeLoading.value,
                      loadNewData: controller.getFreeTemplates,
                    ),
                    const SizedBox(height: 20),
                    TemplateGridView(
                      chooseTemplate: controller.chooseTemplate,
                      templateList: controller.templateList,
                      chosenTemplate: controller.chosenTemplate.value,
                      gridName: premiumTemplate.tr.capitalizeFirst.toString(),
                      lastPage: controller.premiumLastPage,
                      newDataLoading: controller.newPremiumLoading.value,
                      loadNewData: controller.getTemplates,
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).viewPadding.bottom +
                            24 +
                            48),
                  ],
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: isDark ? darkBgColor : bgColor,
                      ),
                      child: Icon(
                        CupertinoIcons.clear,
                        color: hintTextColor,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                if (controller.chosenTemplate.value != null)
                  Positioned(
                      bottom: MediaQuery.of(context).viewPadding.bottom + 24,
                      left: 16,
                      right: 16,
                      child: PrimaryButton(
                          buttonColor: blueColor,
                          buttonText: 'Continue',
                          onPressed: () {
                            Get.back(result: controller.chosenTemplate.value);
                          }))
              ],
            );
          },
        ),
      ),
    );
  }
}

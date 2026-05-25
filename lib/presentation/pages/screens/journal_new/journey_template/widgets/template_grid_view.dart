import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/purchase/template.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:morphzing/presentation/pages/screens/templates/widgets/template.dart' as ui;

class TemplateGridView extends StatelessWidget {
  final Future Function({
    required Template template,
    required BuildContext context,
    required int index,
  }) chooseTemplate;
  final List<Template> templateList;
  final Template? chosenTemplate;
  final String gridName;
  final bool lastPage;
  final bool newDataLoading;
  final VoidCallback loadNewData;

  const TemplateGridView({
    Key? key,
    required this.chooseTemplate,
    required this.templateList,
    required this.chosenTemplate,
    required this.gridName,
    required this.lastPage,
    required this.newDataLoading,
    required this.loadNewData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridViewHeight = (30 + (MediaQuery.of(context).size.width * (155 / 360))) * 2 + 20;
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                gridName,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: customTextStyle(
                  fontSize: 18,
                  color: greyTextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              // Text(
              //   more.tr,
              //   softWrap: false,
              //   overflow: TextOverflow.fade,
              //   style: customTextStyle(
              //     fontSize: 16,
              //     color: greyTextColor,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: gridViewHeight,
            child: templateList.isEmpty
                ? const Center(child: CircularProgressIndicator.adaptive())
                : GridView.builder(
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisExtent: 30 + (MediaQuery.of(context).size.width * 155 / 360),
                    ),
                    itemBuilder: (_, index) {
                      if (!lastPage && index == templateList.length) {
                        if (!newDataLoading) {
                          loadNewData();
                        }
                        return const SizedBox.shrink();
                      }
                      final item = templateList[index];
                      return GestureDetector(
                        onTap: () async => await chooseTemplate(
                          template: item,
                          context: context,
                          index: index,
                        ),
                        child: ui.Template(
                          name: item.name,
                          imageUrl: item.image,
                          isPurchased: item.isPurchased,
                          chosen: item.id == chosenTemplate?.id && item.image == chosenTemplate?.image,
                        ),
                      );
                    },
                    itemCount: lastPage ? templateList.length : templateList.length + 1,
                  ),
          ),
        ],
      );
    });
  }
}

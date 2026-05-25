import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/purchase/template.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/bottom_picker/template_option_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/presentation/pages/screens/journal/journey_screen.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/all_journal/all_journal_controller.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/journey_template/journey_template_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/today_journal/today_journal_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/presentation/widgets/journal/journal_item.dart';
import 'package:morphzing/presentation/widgets/journal/today_journal_item.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:share_plus/share_plus.dart';

class TodayJournalScreen extends StatelessWidget {
  const TodayJournalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<TodayJournalController>(
      init: TodayJournalController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.onPressedBack();
            return false;
          },
          child: Scaffold(
            backgroundColor: isDark ? darkBgColor : whiteColor,
            appBar: StaticAppBar.homeAppBar(
              context,
              todayJourney.tr,
              false,
              "",
              onPressedBack: () => controller.onPressedBack(),
            ),
            body: SafeArea(
              child: Obx(() {
                return CustomScrollView(
                  slivers: [
                    if (controller.rxStatus.isLoading)
                      SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    if (controller.rxStatus.isError)
                      SliverFillRemaining(
                        child: Center(
                          child:
                              Text(controller.rxStatus.errorMessage.toString()),
                        ),
                      ),
                    if (controller.rxStatus.isSuccess)
                      controller.response.data.isNotEmpty
                          ? SliverPadding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (!controller.response.isLastPage() &&
                                        index ==
                                            controller.response.data.length) {
                                      if (controller.rxStatus.isLoadingMore) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        controller.getPaginationJournalList();
                                        return SizedBox.shrink();
                                      }
                                    }
                                    JournalModel model =
                                        controller.response.data[index];
                                    return TodayJournalItem(
                                      journalItem:
                                          controller.response.data[index],
                                      onPressedItem: () => controller
                                          .openUpdateJournalScreen(model),
                                      onPressedMore: () => showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return TemplateOptionBottomSheet(
                                            onPressedTemplate: () async {
                                              final template =
                                                  await JourneyTemplateBottomSheet
                                                      .show(context: context);
                                              if (template is Template) {
                                                Get.back();
                                                LoadingOverlay.show(context);
                                                if (template.isPremium) {
                                                  controller
                                                      .setJourneyUserTemplate(
                                                          model.id, template);
                                                } else {
                                                  controller
                                                      .setJourneyFreeTemplate(
                                                          model.id, template);
                                                }
                                              }
                                            },
                                            onPressedShare: () async {
                                              if (model.images != null &&
                                                  model.images!.isNotEmpty) {
                                                LoadingOverlay.show(context);
                                                controller.shareFile(
                                                  imageUrl: model
                                                      .images![0].imageUrl!,
                                                  title: model.noteName,
                                                  description:
                                                      model.description ?? '',
                                                );
                                              }
                                            },
                                            onPressedDelete: () {
                                              CustomDialogs.show(
                                                context: context,
                                                title: '${deleteJourney.tr}?',
                                                onPressLeftButton: () =>
                                                    Get.back(),
                                                onPressRightButton: () {
                                                  Get.back();
                                                  Get.back();
                                                  LoadingOverlay.show(context);
                                                  controller
                                                      .deleteJourney(model.id);
                                                },
                                                leftButton: no.tr,
                                                rightButton: yes.tr,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      formatTime: '',
                                      onPressedPlay: () {},
                                      onPressedDoc: () => controller
                                          .launchURL(model.documentUrl!),
                                      onChangeSlider: (double value) {},
                                    );
                                  },
                                  // 40 list items
                                  childCount: controller.response.isLastPage()
                                      ? controller.response.data.length
                                      : controller.response.data.length + 1,
                                ),
                              ),
                            )
                          : SliverFillRemaining(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    noJourneyForTodayTitle.tr,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? whiteColor
                                          : Color(0xFF050A41),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    noJourneyForTodayDesc.tr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: isDark
                                          ? greyTextColor
                                          : Color(0xFF676A8B),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                  ],
                );
              }),
            ),
            // bottomNavigationBar: CustomBottomBar.journalFloatingActionButton(
            //     //onPressedCalendar: () => controller.openCalendarJournalScreen(),
            //     ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            // floatingActionButton: CustomBottomBar.journalFloatingActionButton(
            //   () => controller.openCreateJournalScreen(),
            //   color: blueColor,
            // ),
          ),
        );
      },
    );
  }
}

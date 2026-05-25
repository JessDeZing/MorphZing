import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/router.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/journal/journey_screen.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/all_journal/all_journal_controller.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/presentation/widgets/journal/journal_item.dart';
import 'package:morphzing/utils/style/colors.dart';

class AllJournalScreen extends StatelessWidget {
  const AllJournalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<AllJournalController>(
        init: AllJournalController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: isDark ? darkBgColor : whiteColor,
            appBar:
                StaticAppBar.searchAppBar(context, todayJourney.tr, false, ""),
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
                      SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 16,
                              ),
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () => controller.openTodayJournal(),
                                child: Container(
                                  height: 50,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(colors: [
                                      Color(0xFFD9271D),
                                      Color(0xFFE67817),
                                      Color(0xFFFFF701),
                                      Color(0xFF84C428),
                                      Color(0xFF76C5F0),
                                      Color(0xFF8F1E78),
                                    ]),
                                  ),
                                  child: Center(
                                    child: Text(
                                      myLifeJourney.tr,
                                      style: staticTextStyle(
                                        16,
                                        whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(height: 2, color: greyTextColor),
                            SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        controller
                                            .journalStreakModel.totalEntries
                                            .toString(),
                                        style: staticTextStyle(
                                          18,
                                          travelColor,
                                        ),
                                      ),
                                      Text(
                                        totalEntries.tr,
                                        style: staticTextStyle(
                                          12,
                                          greyTextColor,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: greyTextColor,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        controller
                                            .journalStreakModel.streakCount
                                            .toString(),
                                        style: staticTextStyle(
                                          18,
                                          travelColor,
                                        ),
                                      ),
                                      Text(
                                        currentStreak.tr,
                                        style: staticTextStyle(
                                          12,
                                          greyTextColor,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: greyTextColor,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        controller.journalStreakModel.weekStreak
                                            .toString(),
                                        style: staticTextStyle(
                                          18,
                                          travelColor,
                                        ),
                                      ),
                                      Text(
                                        weeksJournaling.tr,
                                        style: staticTextStyle(
                                          12,
                                          greyTextColor,
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            const Divider(height: 2, color: greyTextColor),
                          ],
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
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 8),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: JournalItem(
                                        journalItem:
                                            controller.response.data[index],
                                        onPressedItem: () => controller
                                            .openUpdateJournalScreen(model),
                                      ),
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
            bottomNavigationBar: CustomBottomBar.customJournalBottomBar(
              context: context,
              onPressedCalendar: () => controller.openCalendarJournalScreen(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: CustomBottomBar.journalFloatingActionButton(
              () => controller.openCreateJournalScreen(),
              color: blueColor,
            ),
          );
        });
  }
}

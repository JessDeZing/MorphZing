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

class AllJournalScreen extends StatefulWidget {
  const AllJournalScreen({Key? key}) : super(key: key);

  @override
  State<AllJournalScreen> createState() => _AllJournalScreenState();
}

class _AllJournalScreenState extends State<AllJournalScreen> {
  bool _searchExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<JournalModel> _filtered(List<JournalModel> source) {
    if (_searchQuery.isEmpty) return source;
    return source
        .where((j) =>
            (j.noteName ?? '').toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<AllJournalController>(
        init: AllJournalController(),
        tag: 'allJournal',
        builder: (controller) {
          return Scaffold(
            backgroundColor: isDark ? darkBgColor : whiteColor,
            appBar: AppBar(
              backgroundColor: isDark ? darkBgColor : whiteColor,
              elevation: 0,
              title: Text(
                todayJourney.tr,
                style: TextStyle(
                  color: isDark ? whiteColor : blackTextColor,
                  fontFamily: 'SF Pro Display',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                      Builder(builder: (_) {
                        final filtered = _filtered(controller.response.data);
                        return filtered.isNotEmpty
                            ? SliverPadding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      // Only show pagination loader when not searching
                                      if (_searchQuery.isEmpty &&
                                          !controller.response.isLastPage() &&
                                          index ==
                                              controller.response.data.length) {
                                        if (controller.rxStatus.isLoadingMore) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          controller.getPaginationJournalList();
                                          return SizedBox.shrink();
                                        }
                                      }
                                      JournalModel model = filtered[index];
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: JournalItem(
                                          journalItem: model,
                                          onPressedItem: () => controller
                                              .openUpdateJournalScreen(model),
                                        ),
                                      );
                                    },
                                    childCount: _searchQuery.isEmpty &&
                                            !controller.response.isLastPage()
                                        ? filtered.length + 1
                                        : filtered.length,
                                  ),
                                ),
                              )
                            : SliverFillRemaining(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _searchQuery.isNotEmpty
                                          ? searchNoResultsTitle.tr
                                          : [journalEmptyTitle1, journalEmptyTitle2, journalEmptyTitle3][DateTime.now().difference(DateTime(2026)).inDays % 3].tr,
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
                                      _searchQuery.isNotEmpty
                                          ? searchNoResultsDesc.tr
                                          : [journalEmptyBody1, journalEmptyBody2, journalEmptyBody3][DateTime.now().difference(DateTime(2026)).inDays % 3].tr,
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
                              );
                      }),
                  ],
                );
              }),
            ),
            bottomNavigationBar: null,
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

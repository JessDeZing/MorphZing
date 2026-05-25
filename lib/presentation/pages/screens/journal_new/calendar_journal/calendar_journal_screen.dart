import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/logic/controllers/journal/journal_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_moth/widgets/header_for_calendar.dart';
import 'package:morphzing/presentation/pages/screens/journal/journey_screen.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/calendar_journal/calendar_journal_controller.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/presentation/widgets/journal/journal_item.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarJournalScreen extends StatefulWidget {
  const CalendarJournalScreen({super.key});

  @override
  State<CalendarJournalScreen> createState() => _CalendarJournalScreenState();
}

class _CalendarJournalScreenState extends State<CalendarJournalScreen> {
  final CalendarJournalController controller = CalendarJournalController();

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<CalendarJournalController>(
      init: controller,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.onPressedBack();
            return false;
          },
          child: Scaffold(
            backgroundColor: isDark ? darkBgColor : whiteColor,
            appBar: StaticAppBar.searchAppBar(
              context,
              calendar.tr,
              false,
              "",
              onPressedBack: () => controller.onPressedBack(),
            ),
            body: Obx(() {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.verticalSpace,
                        HeaderForCalendar(
                          focusedDay: controller.focusedDay,
                          onLeftArrowTap: () async {
                            controller.pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                          onRightArrowTap: () async {
                            controller.pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          },
                          color: thisMonthColor,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color.fromARGB(40, 217, 38, 29),
                              Color.fromARGB(40, 230, 120, 23),
                              Color.fromARGB(40, 255, 247, 1),
                              Color.fromARGB(40, 131, 196, 40),
                              Color.fromARGB(40, 118, 197, 240),
                              Color.fromARGB(40, 143, 30, 120),
                            ]),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                            top: 18,
                            bottom: 18,
                            right: 2,
                          ),
                          child: TableCalendar<String>(
                            onCalendarCreated: (pageController) =>
                                controller.pageController = pageController,
                            firstDay: DateTime(DateTime.now().year - 10,
                                DateTime.now().month, DateTime.now().day),
                            lastDay: DateTime(DateTime.now().year + 10,
                                DateTime.now().month, DateTime.now().day),
                            currentDay: controller.chosenDay,
                            focusedDay: controller.focusedDay,
                            rowHeight: 42.h,
                            headerVisible: false,
                            sixWeekMonthsEnforced: true,
                            onPageChanged: (DateTime date) {
                              LoadingOverlay.show(context);
                              controller.focusedDay = date;
                              controller.getJournalDateTimeList(
                                startDate: date.subtract(Duration(days: 6)),
                                enDate: date.add(Duration(days: 42)),
                              );
                            },
                            eventLoader: (date) {
                              String? isEvent;
                              for (String eventDate
                                  in controller.journalDateTimeList) {
                                if (DateFormat('yyyy-MM-dd').format(date) ==
                                    eventDate) {
                                  isEvent = eventDate;
                                  break;
                                }
                              }
                              return isEvent == null ? [] : [isEvent];
                            },
                            selectedDayPredicate: (DateTime day) =>
                                controller.chosenDay.millisecondsSinceEpoch ==
                                day.millisecondsSinceEpoch,
                            onDaySelected: (DateTime selectedDay,
                                DateTime focusedDay) async {
                              controller.chosenDay = selectedDay;
                              controller.getJournalList();
                            },
                            calendarBuilders: CalendarBuilders(
                              singleMarkerBuilder:
                                  (_, _calendarDay, _hasEvent) {
                                bool isEqualDate = DateFormat('yyyy-MM-dd')
                                        .format(_calendarDay) ==
                                    _hasEvent;
                                if (isEqualDate) {
                                  return Container(
                                    margin: EdgeInsets.only(top: 6.h),
                                    height: 4.h,
                                    width: 16.w,
                                    decoration: BoxDecoration(
                                      color: thisMonthColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100.w)),
                                    ),
                                  );
                                }

                                return const SizedBox();
                              },
                            ),
                            calendarStyle: const CalendarStyle(
                              cellMargin: EdgeInsets.all(10),
                              isTodayHighlighted: true,
                              todayDecoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 217, 38, 29),
                                  Color.fromARGB(255, 230, 120, 23),
                                  Color.fromARGB(255, 255, 247, 1),
                                  Color.fromARGB(255, 131, 196, 40),
                                  Color.fromARGB(255, 118, 197, 240),
                                  Color.fromARGB(255, 143, 30, 120),
                                ]),
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color.fromARGB(255, 217, 38, 29),
                                  Color.fromARGB(255, 230, 120, 23),
                                  Color.fromARGB(255, 255, 247, 1),
                                  Color.fromARGB(255, 131, 196, 40),
                                  Color.fromARGB(255, 118, 197, 240),
                                  Color.fromARGB(255, 143, 30, 120),
                                ]),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  if (controller.rxStatus.isSuccess &&
                      controller.response.data.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Text(
                          '${controller.response.total.toString()} ${journey.tr}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF676A8B),
                          ),
                        ),
                      ),
                    ),
                  if (controller.rxStatus.isSuccess)
                    controller.response.data.isNotEmpty
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (!controller.response.isLastPage() &&
                                    index == controller.response.data.length) {
                                  if (controller.rxStatus.isLoadingMore) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    controller.getPaginationJournalList();
                                    return const SizedBox.shrink();
                                  }
                                }
                                JournalModel model =
                                    controller.response.data[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                          )
                        : SliverFillRemaining(
                            hasScrollBody: false,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
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
                            ),
                          )
                ],
              );
            }),
            floatingActionButton:
                CustomBottomBar.journalFloatingActionButton(() {
              controller.openCreateJournalScreen();
            }),
            bottomNavigationBar: CustomBottomBar.customBottomBar(context),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }
}

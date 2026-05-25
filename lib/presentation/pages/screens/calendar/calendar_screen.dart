import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_moth/widgets/header_for_calendar.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/todo_screen_controller.dart';
import 'package:morphzing/presentation/pages/screens/calendar/calendar_screen_controller.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/bottom_sheet_for_floating_button.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final controller =
      Get.put<CalendarScreenController>(CalendarScreenController());

  @override
  void initState() {
    super.initState();
    Get.put(TodoScreenController());
  }

  @override
  void dispose() {
    Get.delete<CalendarScreenController>();
    Get.delete<TodoScreenController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: StaticAppBar.searchAppBar(context, 'Calendar', false, ''),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Obx(() {
              return HeaderForCalendar(
                focusedDay: controller.focusedDay.value,
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
                color: blueColor,
              );
            }),
            const SizedBox(height: 24),
            Obx(() {
              return controller.pageLoading.value
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : TableCalendar(
                      availableGestures: AvailableGestures.none,
                      rowHeight: 98,
                      daysOfWeekHeight: 29,
                      headerVisible: false,
                      currentDay: DateTime.now(),
                      focusedDay: controller.focusedDay.value,
                      firstDay: controller.startTime,
                      lastDay: controller.endTime,
                      weekendDays: const [],
                      onCalendarCreated: (pageController) =>
                          controller.pageController = pageController,
                      onDaySelected: (_focusedDay, _) async {
                        LoadingOverlay.show(context);
                        await controller.changeFocusedDay(_focusedDay);
                        LoadingOverlay.hide();
                      },
                      onPageChanged: (DateTime time) async {
                        LoadingOverlay.show(context);
                        controller.focusedDay.value = time;
                        await controller.getCalendarMonth(time);
                        LoadingOverlay.hide();
                      },
                      calendarBuilders: CalendarBuilders(
                        dowBuilder: (_, time) {
                          return Container(
                            width: 26,
                            alignment: Alignment.topCenter,
                            child: Text(
                              DateFormat('E').format(time).toUpperCase(),
                              style: customTextStyle(
                                fontSize: 11,
                                color: isDark ? whiteColor : greyTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                        defaultBuilder: (_, _currentDay, _focusedDay) {
                          return Obx(() {
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(calendarCellDetailsRoute,
                                    arguments: _currentDay);
                              },
                              child: Container(
                                height: 98,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 4,
                                ),
                                width: double.infinity,
                                decoration: _getCorrectBorderSide(_currentDay),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      // height: 13,
                                      child: Text(
                                        '${_currentDay.day}',
                                        style: customTextStyle(
                                            fontSize: 12,
                                            color: isDark
                                                ? whiteColor
                                                : blackTextColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    ...List.generate(
                                        controller.getTheListLength(controller
                                            .calendarData[_currentDay.day]
                                            ?.length), (index) {
                                      final singleCalendarData =
                                          controller.calendarData[
                                              _currentDay.day]![index];
                                      if (index == 4) {
                                        if ((controller
                                                    .calendarData[
                                                        _currentDay.day]
                                                    ?.length ??
                                                0) >
                                            5) {
                                          return _eventTodoContainer(
                                            singleCalendarData.name,
                                            color: singleCalendarData.color,
                                            isExceeding: true,
                                            exceedingNumber: controller
                                                    .calendarData[
                                                        _currentDay.day]!
                                                    .length -
                                                4,
                                          );
                                        }
                                        return _eventTodoContainer(
                                          singleCalendarData.name,
                                          color: singleCalendarData.color,
                                        );
                                      }
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _eventTodoContainer(
                                            singleCalendarData.name,
                                            color: singleCalendarData.color,
                                          ),
                                          const SizedBox(height: 2),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                        todayBuilder: (_, _currentDay, _focusedDay) {
                          return Obx(() {
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(calendarCellDetailsRoute,
                                    arguments: _currentDay);
                              },
                              child: Container(
                                height: 98,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 4,
                                ),
                                width: double.infinity,
                                decoration: _getCorrectBorderSide(_currentDay),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      color: snackBarBgColor.withOpacity(0.4),
                                      alignment: Alignment.center,
                                      // height: 13,
                                      child: Text(
                                        '${_currentDay.day}',
                                        style: customTextStyle(
                                          fontSize: 12,
                                          color:
                                              isDark ? whiteColor : whiteColor,
                                          fontWeight: FontWeight.w700,
                                          textDecoration:
                                              TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    ...List.generate(
                                        controller.getTheListLength(controller
                                            .calendarData[_currentDay.day]
                                            ?.length), (index) {
                                      final singleCalendarData =
                                          controller.calendarData[
                                              _currentDay.day]![index];
                                      if (index == 4) {
                                        if ((controller
                                                    .calendarData[
                                                        _currentDay.day]
                                                    ?.length ??
                                                0) >
                                            5) {
                                          return _eventTodoContainer(
                                            singleCalendarData.name,
                                            color: singleCalendarData.color,
                                            isExceeding: true,
                                            exceedingNumber: controller
                                                    .calendarData[
                                                        _currentDay.day]!
                                                    .length -
                                                4,
                                          );
                                        }
                                        return _eventTodoContainer(
                                          singleCalendarData.name,
                                          color: singleCalendarData.color,
                                        );
                                      }
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _eventTodoContainer(
                                            singleCalendarData.name,
                                            color: singleCalendarData.color,
                                          ),
                                          const SizedBox(height: 2),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                        outsideBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    );
            }),
          ],
        ),
      ),
      floatingActionButton: CustomBottomBar.customFloatingActionButton(() {
        _onFloatingButtonPressed(context);
      }),
      bottomNavigationBar: CustomBottomBar.customBottomBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _onFloatingButtonPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const BottomSheetForFloatingButton(),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black38,
    ).then((_) async {
      LoadingOverlay.show(context);
      await controller.getCalendarMonth(controller.focusedDay.value);
      LoadingOverlay.hide();
    });
  }

  Container _eventTodoContainer(
    String name, {
    Color? color,
    bool isExceeding = false,
    int? exceedingNumber,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isExceeding) {
      return Container(
        height: 13,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        child: Center(
          child: Text(
            '+ $exceedingNumber',
            style: customTextStyle(
              fontSize: 10,
              color: greyTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return Container(
      // height: 18,
      width: double.infinity,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        gradient: color == null ? specialOccasionGradient : null,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      child: Center(
        child: Text(
          name,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: customTextStyle(
            fontSize: 10,
            color: isDark ? whiteColor : whiteColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Decoration _getCorrectBorderSide(DateTime currentDay) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    //first day of calendar
    if (currentDay.day == 1) {
      if (currentDay.weekday == 6) {
        return BoxDecoration(
            border: Border(
          top: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          left: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          right:
              BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          bottom:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
        ));
      }
      return BoxDecoration(
          border: Border(
        top: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
        left: BorderSide(width: 1, color: dividerColor),
        right: BorderSide(width: 0.5, color: dividerColor),
        bottom: BorderSide(width: 0.5, color: dividerColor),
      ));
    }
    //last day of calendar
    if (currentDay.day ==
        DateTime(currentDay.year, currentDay.month + 1, 0).day) {
      if (currentDay.weekday == 7) {
        return BoxDecoration(
            border: Border(
          bottom:
              BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          right:
              BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          left: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          top:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
        ));
      }
      return BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
        right: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
        left: BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
        top: BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
      ));
    }
    //first 7 days of calendar
    if (currentDay.day < 8) {
      //last right side of calendar screen (Saturday)
      if (currentDay.weekday == 6) {
        return BoxDecoration(
            border: Border(
          top: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          right:
              BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          left:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
          bottom:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
        ));
      } else if (currentDay.weekday == 7) {
        return BoxDecoration(
            border: Border(
          top: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          right: BorderSide(width: 0.5, color: dividerColor),
          left: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          bottom:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
        ));
      } else {
        return BoxDecoration(
            border: Border(
          top: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          right:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
          left:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
          bottom:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
        ));
      }
    }
    //last 7 days of calendar
    if (currentDay.day >=
        controller.getTheStartLastSevenCalendarDays(currentDay)) {
      if (currentDay.weekday == 7) {
        return BoxDecoration(
            border: Border(
          top:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
          right:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
          left: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          bottom:
              BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
        ));
      } else if (currentDay.weekday == 6) {
        return BoxDecoration(
            border: Border(
          top:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
          right:
              BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
          left:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
          bottom:
              BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
        ));
      } else {
        return BoxDecoration(
            border: Border(
          top:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
          right:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
          left:
              BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
          bottom:
              BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
        ));
      }
    }
    if (currentDay.weekday == 6) {
      return BoxDecoration(
          border: Border(
        top: BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
        right: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
        left: BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
        bottom:
            BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
      ));
    }
    if (currentDay.weekday == 7) {
      return BoxDecoration(
          border: Border(
        top: BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
        right:
            BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
        left: BorderSide(width: 1, color: isDark ? whiteColor : dividerColor),
        bottom:
            BorderSide(width: 0.5, color: isDark ? whiteColor : dividerColor),
      ));
    }
    return BoxDecoration(
        border:
            Border.all(width: 0.5, color: isDark ? whiteColor : dividerColor));
  }
}

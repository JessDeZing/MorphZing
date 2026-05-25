import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:table_calendar/table_calendar.dart';

//ignore: must_be_immutable
class CustomCalendar extends StatefulWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final Color primaryColor;
  final Function(DateTime) changeFocusedDay;
  final Function(DateTime) onPageChanged;
  final Rx<DateTime> selectedDay;
  final Rx<DateTime> focusedDay;
  PageController pageController;

  CustomCalendar({
    Key? key,
    required this.firstDay,
    required this.lastDay,
    required this.selectedDay,
    required this.primaryColor,
    required this.changeFocusedDay,
    required this.onPageChanged,
    required this.focusedDay,
    required this.pageController,
  }) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final LinkedHashMap<DateTime, bool> listOfDaysWithEvents =
      LinkedHashMap<DateTime, bool>(
    hashCode: (key) => key.day * 1000000 + key.month * 10000 + key.year,
    equals: isSameDay,
  );

  void _buildDayConfirmedTasks(List<Event> dayConfirmedEventList) {
    for (var item in dayConfirmedEventList) {
      Map<DateTime, bool> event = {item.startTime!: true};
      listOfDaysWithEvents.addAll(event);
    }
  }

  List<bool> getEventsForDay(DateTime day) {
    return listOfDaysWithEvents[day] == null
        ? []
        : [listOfDaysWithEvents[day]!];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.h,
        horizontal: 28.w,
      ),
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: widget.primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Obx(() {
            return TableCalendar<bool>(
              availableGestures: AvailableGestures.horizontalSwipe,
              firstDay: widget.firstDay,
              lastDay: widget.lastDay,
              sixWeekMonthsEnforced: true,
              focusedDay: widget.selectedDay.value,
              currentDay: DateTime.now(),
              headerVisible: true,
              headerStyle: HeaderStyle(
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: widget.primaryColor,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: widget.primaryColor,
                ),
                titleTextFormatter: (date, _) =>
                    DateFormat("MMMM yyyy", Get.locale?.languageCode).format(date),
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: widget.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              rowHeight: 32.w,
              onDaySelected: (selectedDay, _) async {
                LoadingOverlay.show(context);
                await widget.changeFocusedDay(selectedDay);
                LoadingOverlay.hide();
              },
              availableCalendarFormats: const {CalendarFormat.month: ""},
              onPageChanged: widget.onPageChanged,
              weekendDays: const [],
              holidayPredicate: (_) => false,
              calendarBuilders: CalendarBuilders(
                weekNumberBuilder: (_, __) => const SizedBox(),
                holidayBuilder: (_, __, ___) => const SizedBox(),
                todayBuilder: (_, _currentDay, __) {
                  return _customizableDayCell(
                      _currentDay, widget.selectedDay.value, greyTextColor);
                },
                dowBuilder: (_, _week) {
                  return SizedBox(
                    width: 26.w,
                    height: 13.h,
                    child: Center(
                      child: Text(
                        DateFormat("E", Get.locale?.languageCode).format(_week),
                        textAlign: TextAlign.center,
                        style: customTextStyle(
                          fontSize: 11.sp,
                          color: dowThisMonthCalendar,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
                defaultBuilder: (_, _givenDay, __) {
                  return _customizableDayCell(
                      _givenDay, widget.selectedDay.value, greyTextColor);
                },
                outsideBuilder: (_, _givenDay, __) {
                  return _customizableDayCell(
                      _givenDay, null, dowThisMonthCalendar);
                },
                disabledBuilder: (_, _givenDay, __) {
                  return _customizableDayCell(
                      _givenDay, null, dowThisMonthCalendar);
                },
                singleMarkerBuilder: (_, _currentDay, _hasEvent) {
                  if (_hasEvent) {
                    return Container(
                      height: 4.h,
                      width: 10.w,
                      decoration: BoxDecoration(
                        color: thisMonthColor,
                        borderRadius: BorderRadius.all(Radius.circular(100.w)),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _customizableDayCell(
      DateTime currentDay, DateTime? focusedDay, Color color) {
    return Container(
      height: 32.w,
      width: 32.w,
      decoration: isSameDay(currentDay, focusedDay)
          ? BoxDecoration(
              color: widget.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(32.w)),
            )
          : const BoxDecoration(
              color: Colors.transparent,
            ),
      child: Center(
        child: Text(
          '${currentDay.day}',
          style: customTextStyle(
            fontSize: 14.sp,
            color: isSameDay(currentDay, focusedDay) ? whiteColor : color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

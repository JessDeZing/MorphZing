import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/special_occasions/widgets/gradient_maker.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_moth/widgets/header_for_calendar.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class DialogCalendar extends StatefulWidget {
  final DateTime chosenTime;
  final Color? color;
  final VoidCallback changeIndexedStackIndex;
  final Function(DateTime) changeSelectedDay;

  const DialogCalendar({
    Key? key,
    required this.chosenTime,
    required this.color,
    required this.changeIndexedStackIndex,
    required this.changeSelectedDay,
  }) : super(key: key);

  @override
  State<DialogCalendar> createState() => _DialogCalendarState();
}

class _DialogCalendarState extends State<DialogCalendar> {
  late final PageController pageController;
  late final ValueNotifier<DateTime> _focusedDay =
      ValueNotifier(widget.chosenTime);
  late DateTime selectedDay = widget.chosenTime;
  DateTime firstDay = DateTime.now().subtract(90.days);
  DateTime lastDay = DateTime.now().add((365 * 3).days);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          calendar.tr,
          style: customTextStyle(
            fontSize: 16.sp,
            color: isDark ? whiteColor : blackTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _focusedDay,
          builder: (_, DateTime value, __) => widget.color == null
              ? _specialOccasionCalendarHeader(value)
              : HeaderForCalendar(
                  focusedDay: value,
                  onLeftArrowTap: () async {
                    pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  onRightArrowTap: () async {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  color: widget.color!,
                ),
        ),
        SizedBox(height: 16.h),
        TableCalendar(
          locale: Get.locale?.languageCode,
          availableGestures: AvailableGestures.horizontalSwipe,
          onCalendarCreated: (controller) => pageController = controller,
          firstDay: firstDay,
          lastDay: lastDay,
          sixWeekMonthsEnforced: true,
          focusedDay: _focusedDay.value,
          currentDay: DateTime.now(),
          headerVisible: false,
          rowHeight: 32.w,
          onDaySelected: _onDaySelected,
          onPageChanged: _onPageChanged,
          weekendDays: const [],
          holidayPredicate: (_) => false,
          calendarBuilders: CalendarBuilders(
              weekNumberBuilder: (_, __) => const SizedBox(),
              holidayBuilder: (_, __, ___) => const SizedBox(),
              todayBuilder: (_, _currentDay, _focusedDay) {
                return _customizableDayCell(_currentDay, _focusedDay,
                    isDark ? whiteColor : greyTextColor);
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
                return _customizableDayCell(_givenDay, selectedDay,
                    isDark ? whiteColor : greyTextColor);
              },
              outsideBuilder: (_, _givenDay, __) {
                return _customizableDayCell(_givenDay, null,
                    isDark ? whiteColor : dowThisMonthCalendar);
              },
              disabledBuilder: (_, _givenDay, __) {
                return _customizableDayCell(_givenDay, null,
                    isDark ? whiteColor : dowThisMonthCalendar);
              }),
        ),
        SizedBox(height: 40.h),
        PrimaryButton(
          buttonColor: widget.color,
          buttonText: continueKey.tr,
          onPressed: widget.changeIndexedStackIndex,
        ),
      ],
    );
  }

  Widget _customizableDayCell(
      DateTime currentDay, DateTime? focusedDay, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 32.w,
      width: 32.w,
      decoration: isSameDay(currentDay, focusedDay)
          ? BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.all(Radius.circular(32.w)),
              gradient: widget.color == null ? specialOccasionGradient : null,
            )
          : const BoxDecoration(
              color: Colors.transparent,
            ),
      child: Center(
        child: Text(
          '${currentDay.day}',
          style: customTextStyle(
            fontSize: 14.sp,
            color: isSameDay(currentDay, focusedDay)
                ? isDark
                    ? blackTextColor
                    : whiteColor
                : color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _onPageChanged(DateTime date) {
    setState(() {
      _focusedDay.value = date;
    });
  }

  void _onDaySelected(_newFocusedDay, __) {
    setState(() {
      _focusedDay.value = _newFocusedDay;
      selectedDay = _newFocusedDay;
    });
    widget.changeSelectedDay(_newFocusedDay);
  }

  Widget _specialOccasionCalendarHeader(DateTime focusedDay) {
    final headerText =
        DateFormat("MMMM yyyy", Get.locale?.languageCode).format(focusedDay);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: GradientMaker(
              child: Icon(
                Icons.chevron_left,
              ),
            ),
            onTap: () {
              pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
          GradientMaker(
            child: Text(
              headerText,
              style: customTextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? whiteColor : blackTextColor,
              ),
            ),
          ),
          GestureDetector(
            child: GradientMaker(
              child: Icon(
                Icons.chevron_right,
              ),
            ),
            onTap: () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
          ),
        ],
      ),
    );
  }
}

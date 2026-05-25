import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/special_occasions/widgets/gradient_maker.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class GradientCalendar extends StatelessWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final Function(DateTime) changeFocusedDay;
  final Function(DateTime) onPageChanged;
  final Rx<DateTime> selectedDay;
  final Rx<DateTime> focusedDay;
  PageController pageController;

  GradientCalendar({
    Key? key,
    required this.firstDay,
    required this.lastDay,
    required this.changeFocusedDay,
    required this.onPageChanged,
    required this.selectedDay,
    required this.focusedDay,
    required this.pageController,
  }) : super(key: key);

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
        gradient: specialOccasionGradientWithOpacity,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          /*Obx(() {
            return _header(focusedDay.value);
          }),
          SizedBox(height: 16.h),*/
          Obx(() {
            return TableCalendar(
              availableGestures: AvailableGestures.horizontalSwipe,
              onCalendarCreated: (controller) => pageController = controller,
              firstDay: firstDay,
              lastDay: lastDay,
              sixWeekMonthsEnforced: true,
              focusedDay: selectedDay.value,
              currentDay: DateTime.now(),
              headerVisible: true,
              headerStyle: const HeaderStyle(
                leftChevronIcon: GradientMaker(
                  child: Icon(
                    Icons.chevron_left,
                  ),
                ),
                rightChevronIcon: GradientMaker(
                  child: Icon(
                    Icons.chevron_right,
                  ),
                ),
                formatButtonVisible: false,
              ),
              rowHeight: 32.w,
              onDaySelected: (selectedDay, _) async {
                LoadingOverlay.show(context);
                await changeFocusedDay(selectedDay);
                LoadingOverlay.hide();
              },
              onPageChanged: onPageChanged,
              weekendDays: const [],
              holidayPredicate: (_) => false,
              availableCalendarFormats: const {CalendarFormat.month: ""},
              calendarBuilders: CalendarBuilders(
                  weekNumberBuilder: (_, __) => const SizedBox(),
                  holidayBuilder: (_, __, ___) => const SizedBox(),
                  headerTitleBuilder: (_, date) {
                    final headerText = DateFormat("MMMM yyyy", Get.locale?.languageCode).format(date);
                    return GradientMaker(
                      child: Text(
                        headerText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                  todayBuilder: (_, _currentDay, __) {
                    return _customizableDayCell(
                        _currentDay, selectedDay.value, greyTextColor);
                  },
                  dowBuilder: (_, _week) {
                    return SizedBox(
                      width: 26.w,
                      height: 13.h,
                      child: Center(
                        child: Text(
                          DateFormat("E").format(_week),
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
                        _givenDay, selectedDay.value, greyTextColor);
                  },
                  outsideBuilder: (_, _givenDay, __) {
                    return _customizableDayCell(
                        _givenDay, null, dowThisMonthCalendar);
                  },
                  disabledBuilder: (_, _givenDay, __) {
                    return _customizableDayCell(
                        _givenDay, null, dowThisMonthCalendar);
                  }),
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
              gradient: specialOccasionGradient,
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

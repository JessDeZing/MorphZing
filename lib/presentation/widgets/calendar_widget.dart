import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/start_and_finish_date/time_picker_spinner.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime dateTime;
  final Function(DateTime value) onChangeDateTime;

  const CalendarWidget({Key? key, required this.dateTime, required this.onChangeDateTime}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _BuildCalendarState();
}

class _BuildCalendarState extends State<CalendarWidget> {
  late DateTime dateTime = widget.dateTime;
  bool isCalendar = true;

  final CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: (isCalendar)
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 500,
              width: Get.width - 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Calendar',
                    style: staticTextStyle(
                      16,
                      blackTextColor,
                    ),
                  ),
                  Expanded(
                    child: TableCalendar(
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: blueColor,
                          // borderRadius: BorderRadius.circular(10),
                        ),
                        // selectedDecoration: BoxDecoration(
                        //   color: blueColor,
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                      ),
                      calendarFormat: _calendarFormat,
                      headerStyle: HeaderStyle(
                        titleTextStyle: staticTextStyle(
                          16,
                          blueColor,
                        ),
                        formatButtonVisible: false,
                        formatButtonShowsNext: false,
                        titleCentered: true,
                      ),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          dateTime = selectedDay;
                          dateTime = focusedDay;
                        });
                      },
                      currentDay: dateTime,
                      focusedDay: dateTime,
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2040, 3, 14),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isCalendar = false;
                      });
                    },
                    child: Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: blueColor),
                      child: Center(
                        child: Text(
                          'Continue',
                          style: staticTextStyle(
                            16,
                            whiteColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 220,
              width: Get.width - 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: staticTextStyle(
                      16,
                      blackTextColor,
                    ),
                  ),
                  Expanded(
                    child: TimePickerSpinner(
                      is24HourMode: false,
                      normalTextStyle: staticTextStyle(
                        20,
                        blackTextColor.withOpacity(0.5),
                      ),
                      highlightedTextStyle: const TextStyle(fontSize: 24, color: blackTextColor),
                      spacing: 20,
                      itemHeight: 40,
                      isForce2Digits: true,
                      onTimeChange: (time) {
                        setState(() {
                          dateTime = DateTime(
                            dateTime.year,
                            dateTime.month,
                            dateTime.day,
                            time.hour,
                            time.minute,
                            time.second,
                          );
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.onChangeDateTime(dateTime);
                      Get.back();
                    },
                    child: Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: blueColor),
                      child: Center(
                        child: Text(
                          'Save',
                          style: staticTextStyle(
                            16,
                            whiteColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

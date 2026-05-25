import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/start_and_finish_date/dialog_calendar.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/start_and_finish_date/time_picker_spinner.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/style/colors.dart';

class ChooseDayAndTime extends StatefulWidget {
  final DateTime chosenTime;

  const ChooseDayAndTime({
    Key? key,
    required this.chosenTime,
  }) : super(key: key);

  @override
  State<ChooseDayAndTime> createState() => _ChooseDayAndTimeState();
}

class _ChooseDayAndTimeState extends State<ChooseDayAndTime> {
  int _index = 0;
  late DateTime _actualTime = DateTime(
    widget.chosenTime.year,
    widget.chosenTime.month,
    widget.chosenTime.day,
    DateTime.now().hour,
    DateTime.now().minute,
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 28.w,
        vertical: 16.h,
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark ? darkBgColor : whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: AnimatedCrossFade(
        crossFadeState:
            _index == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: DialogCalendar(
          color: todayColor,
          changeIndexedStackIndex: changeVisibleWidget,
          changeSelectedDay: _changeSelectedDay,
          chosenTime: widget.chosenTime,
        ),
        secondChild: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: todayColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 12,
              ),
              child: Text(
                startTime.tr,
                style: customTextStyle(
                  fontSize: 18.sp,
                  color: isDark ? whiteColor : whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            TimePickerSpinner(
              is24HourMode: false,
              itemHeight: 40,
              highlightedTextStyle: customTextStyle(
                fontSize: 25.sp,
                color: isDark ? whiteColor : blackTextColor,
                fontWeight: FontWeight.w600,
              ),
              normalTextStyle: customTextStyle(
                fontSize: 25.sp,
                color: isDark ? whiteColor : greyTextColor,
                fontWeight: FontWeight.w400,
              ),
              fadedTextStyle: customTextStyle(
                fontSize: 25.sp,
                color: isDark ? whiteColor : greyTextColor.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
              onTimeChange: (time) {
                _actualTime = DateTime(
                  _actualTime.year,
                  _actualTime.month,
                  _actualTime.day,
                  time.hour,
                  time.minute,
                );
              },
            ),
            SizedBox(
              height: 30.h,
            ),
            PrimaryButton(
              buttonColor: todayColor,
              buttonText: save.tr,
              onPressed: () {
                if (DateTime.now().isAfter(_actualTime)) {
                  Get.defaultDialog(
                    title: startCannotBeEarlier.tr,
                    middleText: chooseDifferentTime.tr,
                  );
                } else {
                  Navigator.of(context).pop(_actualTime);
                }
              },
            ),
          ],
        ),
        duration: 100.milliseconds,
      ),
    );
  }

  void changeVisibleWidget() {
    setState(() {
      _index = 1;
    });
  }

  void _changeSelectedDay(DateTime time) {
    setState(() {
      _actualTime = DateTime(
        time.year,
        time.month,
        time.day,
        DateTime.now().hour,
        DateTime.now().minute,
      );
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';

class ReminderTimeSliderDialog extends StatefulWidget {
  final Function(Duration) onSetDuration;

  const ReminderTimeSliderDialog({
    Key? key,
    required this.onSetDuration,
  }) : super(key: key);

  static Future show({
    required BuildContext context,
    required Function(Duration) onSetDuration,
  }) =>
      showDialog(
          context: context,
          builder: (_) =>
              ReminderTimeSliderDialog(onSetDuration: onSetDuration));

  @override
  State<ReminderTimeSliderDialog> createState() =>
      _ReminderTimeSliderDialogState();
}

class _ReminderTimeSliderDialogState extends State<ReminderTimeSliderDialog> {
  Duration duration = const Duration(hours: 0, minutes: 0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      content: Container(
        //height: 200.h,
        decoration: BoxDecoration(
          color: isDark ? darkBgColor : whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            Text(
              reminderBeforeStart.tr,
              style: customTextStyle(
                fontSize: 16.sp,
                color: isDark ? whiteColor : blackTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              height: 200.h,
              width: 200.w,
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: duration,
                minuteInterval: 1,
                onTimerDurationChanged: (Duration newDuration) {
                  widget.onSetDuration(newDuration);
                  setState(() => duration = newDuration);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

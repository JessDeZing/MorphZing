import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/reminder_time_slider_dialog.dart';
import 'package:morphzing/utils/style/colors.dart';

class ReminderWidget extends StatefulWidget {
  final Function(Duration) setReminder;
  final Event? event;

  const ReminderWidget({
    Key? key,
    required this.event,
    required this.setReminder,
  }) : super(key: key);

  @override
  State<ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  late Duration duration = const Duration(minutes: 0);

  @override
  void initState() {
    super.initState();
    if (widget.event?.reminder != null) {
      duration = Duration(minutes: widget.event!.reminder!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => ReminderTimeSliderDialog.show(
          context: context,
          onSetDuration: (Duration newDuration) {
            setState(() {
              duration = newDuration;
            });
            widget.setReminder(newDuration);
          }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            reminder.tr,
            style: customTextStyle(
              fontSize: 15.sp,
              color: isDark ? whiteColor : blackTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(
              color: isDark ? darkBgColor : bgColor,
              borderRadius: BorderRadius.all(Radius.circular(10.w)),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 15.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.event != null && widget.event!.reminder == null
                      ? noReminderSet.tr
                      : _correctReminderDuration,
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: isDark ? whiteColor : blackTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: isDark ? whiteColor : blackTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _correctReminderDuration {
    String result = '';
    if (duration.inMinutes ~/ 60 == 0) {
      result = '${duration.inMinutes} ${minutes.tr} ${beforeStart.tr}';
    } else if (duration.inMinutes % 60 == 0) {
      result = '${duration.inMinutes ~/ 60} ${hours.tr} ${beforeStart.tr}';
    } else {
      result =
          '${duration.inMinutes ~/ 60} ${hours.tr} ${duration.inMinutes % 60} ${minutes.tr} ${beforeStart.tr}';
    }
    return result;
  }
}

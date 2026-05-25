import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/arguments.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/repeat_bottom_sheet.dart';
import 'package:morphzing/utils/enum_map.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:morphzing/localization/translation_keys.dart' as t;

class RepeatWidget extends StatefulWidget {
  final Event? event;
  final Color? color;
  final Function(RepeatArguments) onRepeatChanged;
  final DateTime chosenDay;

  const RepeatWidget({
    Key? key,
    required this.event,
    required this.color,
    required this.onRepeatChanged,
    required this.chosenDay,
  }) : super(key: key);

  @override
  State<RepeatWidget> createState() => _RepeatWidgetState();
}

class _RepeatWidgetState extends State<RepeatWidget> {
  String? repeat = repeatValues.reverse[RepeatRadioButtonOptions.doNotRepeat];
  String? durationText;

  void _setRepeatTextAccordingly(String recurrences) {
    setState(() {
      if (recurrences.contains('FREQ=WEEKLY')) {
        repeat = repeatValues.reverse[RepeatRadioButtonOptions.everyWeek];
      } else if (recurrences.contains('FREQ=MONTHLY')) {
        repeat = repeatValues.reverse[RepeatRadioButtonOptions.everyMonth];
      } else if (recurrences.contains('FREQ=YEARLY')) {
        repeat = repeatValues.reverse[RepeatRadioButtonOptions.everyYear];
      } else if (recurrences.contains('FREQ=DAILY')) {
        repeat = repeatValues.reverse[RepeatRadioButtonOptions.everyday];
      }
    });
  }

  void _setDurationText(String recurrences) {
    setState(() {
      if (recurrences.contains('UNTIL')) {
        final time = recurrences
            .substring(recurrences.indexOf('UNTIL=') + 'UNTIL='.length);
        durationText =
            '${t.duration.tr} ${t.until.tr}: ${time.substring(4, 6)}/${time.substring(6, 8)}/${time.substring(0, 4)}';
      } else {
        durationText = t.forever.tr;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.event != null && widget.event!.recurrences != null) {
        _setRepeatTextAccordingly(widget.event!.recurrences!);
        _setDurationText(widget.event!.recurrences!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () async {
        final chosenRepeatOptions = await RepeatBottomSheet.show(
          context: context,
          color: widget.color,
          chosenDay: widget.chosenDay,
        );
        if (chosenRepeatOptions != null &&
            chosenRepeatOptions is RepeatArguments) {
          debugPrint(chosenRepeatOptions.toString());
          setState(() {
            repeat = repeatValues.reverse[chosenRepeatOptions.repeat];
            if (repeat !=
                repeatValues.reverse[RepeatRadioButtonOptions.doNotRepeat]) {
              if (chosenRepeatOptions.until != null) {
                durationText =
                    '${t.duration.tr} ${t.until.tr}: ${DateFormat('MM/dd/yyyy').format(chosenRepeatOptions.until!)}';
              } else {
                durationText = t.forever.tr;
              }
            }
          });
          widget.onRepeatChanged(chosenRepeatOptions);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.repeat.tr,
            style: customTextStyle(
              fontSize: 15.sp,
              color: isDark ? whiteColor : blackTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 15.h,
            ),
            decoration: BoxDecoration(
              color: isDark ? darkBgColor : bgColor,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$repeat',
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
          if (durationText != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const SizedBox(width: 12),
                Text(
                  '*',
                  style: customTextStyle(
                    fontSize: 12,
                    color: isDark ? whiteColor : greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '$durationText',
                  style: customTextStyle(
                    fontSize: 12,
                    color: isDark ? whiteColor : greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}

enum RepeatRadioButtonOptions {
  doNotRepeat,
  everyday,
  everyWeek,
  everyMonth,
  everyYear,
}

final repeatValues = EnumValues({
  t.doNotRepeat.tr: RepeatRadioButtonOptions.doNotRepeat,
  t.everyday.tr: RepeatRadioButtonOptions.everyday,
  t.everyWeek.tr: RepeatRadioButtonOptions.everyWeek,
  t.everyMonth.tr: RepeatRadioButtonOptions.everyMonth,
  t.everyYear.tr: RepeatRadioButtonOptions.everyYear,
});

enum DurationRadioButtonOptions {
  forever,
  until,
}

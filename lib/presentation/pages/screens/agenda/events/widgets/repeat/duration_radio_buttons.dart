import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/repeat_widget.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/single_radio_button.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/start_and_finish_date/dialog_calendar.dart';
import 'package:morphzing/utils/style/colors.dart';

class DurationRadioButtons extends StatefulWidget {
  final Color? color;
  final Function(DurationRadioButtonOptions, DateTime?) changeDurationOption;
  final DateTime chosenDay;

  const DurationRadioButtons({
    Key? key,
    required this.color,
    required this.changeDurationOption,
    required this.chosenDay,
  }) : super(key: key);

  @override
  State<DurationRadioButtons> createState() => _DurationRadioButtonsState();
}

class _DurationRadioButtonsState extends State<DurationRadioButtons> {
  DateTime? untilDay;
  DurationRadioButtonOptions _chosenOption = DurationRadioButtonOptions.forever;

  void _chooseRepeatTime(
      DurationRadioButtonOptions newDurationRadioButtonOptions) {
    if (newDurationRadioButtonOptions != DurationRadioButtonOptions.until) {
      untilDay = null;
    }
    setState(() {
      _chosenOption = newDurationRadioButtonOptions;
    });
    widget.changeDurationOption(newDurationRadioButtonOptions, untilDay);
  }

  void _changeUntilDay(DateTime dateTime) {
    untilDay = dateTime;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        GestureDetector(
          onTap: () => _chooseRepeatTime(DurationRadioButtonOptions.forever),
          child: SingleRadioButton(
            text: forever.tr,
            isChosen: _chosenOption == DurationRadioButtonOptions.forever,
            color: widget.color,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () async {
            await showDialog(
              useRootNavigator: false,
              context: context,
              builder: (_) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      margin: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: isDark ? darkBgColor : whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      ),
                      child: DialogCalendar(
                        color: widget.color,
                        changeIndexedStackIndex: () {
                          untilDay ??= widget.chosenDay;
                          Navigator.of(context).pop();
                        },
                        changeSelectedDay: _changeUntilDay,
                        chosenTime: widget.chosenDay,
                      ),
                    ),
                  ],
                ),
              ),
            );
            if (untilDay != null) {
              _chooseRepeatTime(DurationRadioButtonOptions.until);
            }
          },
          child: SingleRadioButton(
            text: until.tr,
            isChosen: _chosenOption == DurationRadioButtonOptions.until,
            color: widget.color,
          ),
        ),
      ],
    );
  }
}

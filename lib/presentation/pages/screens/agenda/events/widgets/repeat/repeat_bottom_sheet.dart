import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/arguments.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/duration_radio_buttons.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/repeat_radio_buttons.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/repeat_widget.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';

class RepeatBottomSheet extends StatefulWidget {
  final Color? color;
  final DateTime chosenDay;

  const RepeatBottomSheet({
    Key? key,
    required this.color,
    required this.chosenDay,
  }) : super(key: key);

  @override
  State<RepeatBottomSheet> createState() => _RepeatBottomSheetState();

  static Future show({
    required BuildContext context,
    required Color? color,
    required DateTime chosenDay,
  }) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
        builder: (_) => RepeatBottomSheet(
          color: color,
          chosenDay: chosenDay,
        ),
      );
}

class _RepeatBottomSheetState extends State<RepeatBottomSheet> {
  RepeatRadioButtonOptions repeatOption = RepeatRadioButtonOptions.doNotRepeat;
  DurationRadioButtonOptions durationOption =
      DurationRadioButtonOptions.forever;

  //these two only if user chooses to repeat Every week
  List<int> _chosenWeeks = [];
  int _numberOfWeeks = 1;

  //this only for duration until
  DateTime? _until;

  void _changeRepeatOption(
      RepeatRadioButtonOptions newRepeatRadioButtonOption) {
    repeatOption = newRepeatRadioButtonOption;
    setState(() {});
  }

  void _changeDurationOption(
      DurationRadioButtonOptions newDurationRadioButtonOption,
      DateTime? newUntil) {
    durationOption = newDurationRadioButtonOption;
    _until = newUntil;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Container(
          color: isDark ? darkBgColor : whiteColor,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.95,
            minHeight: MediaQuery.of(context).size.height * 0.95,
          ),
          child: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 18.h),
                Text(
                  repeat.tr,
                  style: customTextStyle(
                    fontSize: 17.sp,
                    color: isDark ? whiteColor : blackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 28.h),
                RepeatRadioButtons(
                  changeRepeatOption: _changeRepeatOption,
                  color: widget.color,
                  onChooseEveryWeek: (list, number) {
                    _chosenWeeks = list;
                    _numberOfWeeks = number;
                  },
                ),
                SizedBox(height: 24.h),
                AnimatedSize(
                  duration: 300.milliseconds,
                  child: repeatOption != RepeatRadioButtonOptions.doNotRepeat
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 12.w),
                              child: Text(
                                duration.tr,
                                style: customTextStyle(
                                  fontSize: 15.sp,
                                  color: isDark ? whiteColor : blackTextColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            DurationRadioButtons(
                              color: widget.color,
                              changeDurationOption: _changeDurationOption,
                              chosenDay: widget.chosenDay,
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                SizedBox(
                    height: MediaQuery.of(context).viewPadding.bottom + 70.h),
              ],
            ),
          ),
        ),
        Positioned(
          right: 10.w,
          top: 10.h,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.w),
                color: isDark ? darkBgColor : bgColor,
              ),
              child: Icon(
                CupertinoIcons.clear,
                color: isDark ? whiteColor : hintTextColor,
                size: 16,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewPadding.bottom + 16.h,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: PrimaryButton(
              buttonColor: widget.color,
              onPressed: () {
                if (repeatOption == RepeatRadioButtonOptions.everyWeek) {
                  if (_chosenWeeks.isEmpty) {
                    showAttentionSnackBar(message: oneDayOfWeek.tr);
                    return;
                  } else if (_numberOfWeeks == 0) {
                    showGetSnackBar(
                        message: 'At least every 1 week must be set');
                    return;
                  }
                }
                Navigator.of(context).pop(RepeatArguments(
                  repeat: repeatOption,
                  chosenWeekDays: _chosenWeeks,
                  numberOfWeeks: _numberOfWeeks,
                  until: _until,
                  durationOption: durationOption,
                ));
              },
              buttonText: submit.tr,
            ),
          ),
        ),
      ],
    );
  }
}

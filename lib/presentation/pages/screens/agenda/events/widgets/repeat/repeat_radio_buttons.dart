import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/every_week_widget.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/repeat_widget.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/repeat/single_radio_button.dart';

class RepeatRadioButtons extends StatefulWidget {
  final Color? color;
  final Function(RepeatRadioButtonOptions) changeRepeatOption;
  final Function(List<int>, int) onChooseEveryWeek;

  const RepeatRadioButtons({
    Key? key,
    required this.color,
    required this.changeRepeatOption,
    required this.onChooseEveryWeek,
  }) : super(key: key);

  @override
  State<RepeatRadioButtons> createState() => _RepeatRadioButtonsState();
}

class _RepeatRadioButtonsState extends State<RepeatRadioButtons> {
  RepeatRadioButtonOptions _chosenOption = RepeatRadioButtonOptions.doNotRepeat;

  void _chooseRepeatTime(RepeatRadioButtonOptions newRepeatRadioButtonOptions) {
    widget.changeRepeatOption(newRepeatRadioButtonOptions);
    setState(() {
      _chosenOption = newRepeatRadioButtonOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _chooseRepeatTime(RepeatRadioButtonOptions.doNotRepeat),
          child: SingleRadioButton(
            text: doNotRepeat.tr,
            isChosen: _chosenOption == RepeatRadioButtonOptions.doNotRepeat,
            color: widget.color,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _chooseRepeatTime(RepeatRadioButtonOptions.everyday),
          child: SingleRadioButton(
            text: everyday.tr,
            isChosen: _chosenOption == RepeatRadioButtonOptions.everyday,
            color: widget.color,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _chooseRepeatTime(RepeatRadioButtonOptions.everyWeek),
          child: EveryWeekWidget(
            isChosen: _chosenOption == RepeatRadioButtonOptions.everyWeek,
            onChooseEveryWeek: widget.onChooseEveryWeek,
            color: widget.color,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _chooseRepeatTime(RepeatRadioButtonOptions.everyMonth),
          child: SingleRadioButton(
            text: everyMonth.tr,
            isChosen: _chosenOption == RepeatRadioButtonOptions.everyMonth,
            color: widget.color,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _chooseRepeatTime(RepeatRadioButtonOptions.everyYear),
          child: SingleRadioButton(
            text: everyYear.tr,
            isChosen: _chosenOption == RepeatRadioButtonOptions.everyYear,
            color: widget.color,
          ),
        ),
      ],
    );
  }
}

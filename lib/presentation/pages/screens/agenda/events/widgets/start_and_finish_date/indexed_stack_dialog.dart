import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/start_and_finish_date/choose_start_and_end_time.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/start_and_finish_date/dialog_calendar.dart';
import 'package:morphzing/utils/style/colors.dart';

class IndexedStackDialog extends StatefulWidget {
  final Color? color;
  final DateTime chosenTime;

  const IndexedStackDialog({
    Key? key,
    required this.color,
    required this.chosenTime,
  }) : super(key: key);

  @override
  State<IndexedStackDialog> createState() => _IndexedStackDialogState();
}

class _IndexedStackDialogState extends State<IndexedStackDialog> {
  int _index = 0;
  late DateTime _selectedDay = widget.chosenTime;

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
        duration: 100.milliseconds,
        crossFadeState:
            _index == 0 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: DialogCalendar(
          color: widget.color,
          changeIndexedStackIndex: changeVisibleWidget,
          changeSelectedDay: _changeSelectedDay,
          chosenTime: widget.chosenTime,
        ),
        secondChild: ChooseStartAndEndTime(
          color: widget.color,
          selectedDay: _selectedDay,
        ),
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
      _selectedDay = time;
    });
  }
}

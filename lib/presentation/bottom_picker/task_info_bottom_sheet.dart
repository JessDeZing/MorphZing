import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/bottom_sheet_bottom_buttons.dart';
import 'package:morphzing/utils/style/colors.dart';

class TaskInfoBottomSheet extends StatefulWidget {
  static Future show({
    required BuildContext context,
    required Todo task,
  }) =>
      showModalBottomSheet(
        context: context,
        builder: (_) => TaskInfoBottomSheet(task: task),
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
      );

  final Todo task;

  const TaskInfoBottomSheet({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskInfoBottomSheet> createState() => _TaskInfoBottomSheetState();
}

class _TaskInfoBottomSheetState extends State<TaskInfoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10.w),
      constraints: BoxConstraints(
        maxHeight: (MediaQuery.of(context).size.height * 0.9).h - kToolbarHeight,
      ),
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40.w,
                      width: 40.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.w),
                        color: bgColor,
                      ),
                      child: const Icon(
                        CupertinoIcons.clear,
                        color: hintTextColor,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              TextFormField(
                initialValue: widget.task.taskName,
                obscureText: false,
                textCapitalization: TextCapitalization.sentences,
                readOnly: true,
                style: customTextStyle(
                  fontSize: 34.sp,
                  color: blackTextColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Task name',
                  hintStyle: customTextStyle(
                    fontSize: 34.sp,
                    color: hintTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              if (widget.task.todayTime != null || widget.task.monthTime != null || widget.task.yearTime != null) ...[
                Text(
                  getDateTitle(),
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: blackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  getDate(),
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 32.h)
              ],
              if (widget.task.todayReminder != null && widget.task.isMonthlyReminderOn && widget.task.isYearlyReminderOn) ...[
                Text(
                  'Reminder',
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: blackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  getReminder(),
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 32.h),
              ],
              if (widget.task.notes.isNotEmpty) ...[
                Text(
                  'Note',
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: blackTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  widget.task.notes,
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 32.h),
              ],
              if (widget.task.isGoal)
                Row(
                  children: [
                    Text(
                      "Goal",
                      style: customTextStyle(
                        fontSize: 15.sp,
                        color: blackTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    SvgPicture.asset('assets/icons/goal_star.svg'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String getDateTitle() {
    if (widget.task.todayTime != null) {
      return 'Date';
    } else if (widget.task.monthTime != null) {
      return 'Month';
    } else if (widget.task.yearTime != null) {
      return 'Year';
    }
    return '';
  }

  String getDate() {
    if (widget.task.todayTime != null) {
      return DateFormat("EEEE, MMM d, h:mm a").format(widget.task.todayTime!);
    } else if (widget.task.monthTime != null) {
      return DateFormat('MMMM, yyyy').format(widget.task.monthTime!);
    } else if (widget.task.yearTime != null) {
      return DateFormat('yyyy').format(widget.task.yearTime!);
    }
    return '';
  }

  String getReminder() {
    if (widget.task.todayReminder != null) {
      return '${widget.task.todayReminder} minutes before start';
    } else if (widget.task.isMonthlyReminderOn) {
      return 'Send SMS message on the 1st day of the month';
    } else if (widget.task.isYearlyReminderOn) {
      return 'Send SMS message every 3 months';
    }
    return '';
  }
}

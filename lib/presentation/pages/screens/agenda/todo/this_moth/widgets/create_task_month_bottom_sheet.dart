import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_moth/widgets/choose_month_dialog.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/todo_screen_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/bottom_sheet_bottom_buttons.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';

class CreateTaskMonthBottomSheet extends StatefulWidget {
  final Todo? taskToEdit;

  const CreateTaskMonthBottomSheet({
    Key? key,
    required this.taskToEdit,
  }) : super(key: key);

  @override
  State<CreateTaskMonthBottomSheet> createState() =>
      _CreateTaskMonthBottomSheetState();

  static Future show({
    required BuildContext context,
    Todo? taskToEdit,
  }) =>
      showModalBottomSheet(
        context: context,
        builder: (_) => CreateTaskMonthBottomSheet(taskToEdit: taskToEdit),
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.w))),
      );
}

class _CreateTaskMonthBottomSheetState
    extends State<CreateTaskMonthBottomSheet> {
  final _todoScreenController = Get.find<TodoScreenController>();
  bool absorb = false;
  String dateAndTime = pleaseEnterMonth.tr;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _switchValue = false;
  bool _reminderSwitchValue = false;
  DateTime? _changedDateTimeForEditTask;

  void _changeSwitchValue(bool newValue) {
    setState(() {
      _switchValue = newValue;
    });
  }

  void _changeReminderSwitchValue(bool newValue) {
    setState(() {
      _reminderSwitchValue = newValue;
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final task = widget.taskToEdit;
      if (task != null) {
        if (task.status == TodoStatus.done) {
          absorb = true;
        }
        setState(() {
          _textEditingController.text = task.taskName;
          _notesController.text = task.notes;
          dateAndTime = DateFormat('MMMM, yyyy', Get.locale?.languageCode)
              .format(task.monthTime!);
          _changedDateTimeForEditTask = task.monthTime!;
          _switchValue = task.isGoal;
          _reminderSwitchValue = task.isMonthlyReminderOn;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? darkBgColor : Colors.white,
      padding: EdgeInsets.all(10.w),
      constraints: BoxConstraints(
        maxHeight: (MediaQuery.of(context).size.height * 0.9).h,
      ),
      child: Scaffold(
        backgroundColor: isDark ? darkBgColor : whiteColor,
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
                        color: isDark ? darkBgColor : bgColor,
                      ),
                      child: Icon(
                        CupertinoIcons.clear,
                        color: isDark ? whiteColor : hintTextColor,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: _textEditingController,
                obscureText: false,
                textCapitalization: TextCapitalization.sentences,
                readOnly: absorb,
                style: customTextStyle(
                  fontSize: 34.sp,
                  color: isDark ? whiteColor : blackTextColor,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: taskName.tr,
                  hintStyle: customTextStyle(
                    fontSize: 34.sp,
                    color: isDark ? whiteColor : hintTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                month.tr,
                style: customTextStyle(
                  fontSize: 15.sp,
                  color: isDark ? whiteColor : blackTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.h),
              Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.w))),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: absorb
                      ? () {}
                      : () async {
                          final result =
                              await ChooseMonthDialog.show(context: context);
                          if (result != null && result is DateTime) {
                            setState(() {
                              dateAndTime = DateFormat(
                                      'MMMM, yyyy', Get.locale?.languageCode)
                                  .format(result);
                            });
                            _changedDateTimeForEditTask = result;
                          }
                        },
                  child: Ink(
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
                          dateAndTime,
                          style: customTextStyle(
                            fontSize: 15.sp,
                            color: isDark ? whiteColor : greyTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: SvgPicture.asset(
                            'assets/icons/task_month.svg',
                            color: isDark ? whiteColor : blackTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                description.tr,
                style: customTextStyle(
                  fontSize: 15.sp,
                  color: isDark ? whiteColor : blackTextColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: _notesController,
                maxLines: 4,
                maxLength: 2000,
                textCapitalization: TextCapitalization.sentences,
                readOnly: absorb,
                style: customTextStyle(
                  fontSize: 15.sp,
                  color: isDark ? whiteColor : greyTextColor,
                  fontWeight: FontWeight.w400,
                ).copyWith(height: (21 / 14).sp),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? darkBgColor : bgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    borderSide: BorderSide.none,
                  ),
                  counterText: "",
                  hintText: pleaseEnterDescription.tr,
                  hintStyle: customTextStyle(
                    fontSize: 15.sp,
                    color: isDark ? whiteColor : greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.only(left: 12.w),
                decoration: BoxDecoration(
                  color: isDark ? darkBgColor : bgColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                ),
                child: Row(
                  children: [
                    Text(
                      goal.tr,
                      style: customTextStyle(
                        fontSize: 15.sp,
                        color: isDark ? whiteColor : blackTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    SvgPicture.asset(
                      'assets/icons/goal_star.svg',
                      color: isDark ? whiteColor : blackTextColor,
                    ),
                    const Spacer(),
                    Switch(
                      value: _switchValue,
                      onChanged: absorb ? (_) {} : _changeSwitchValue,
                      inactiveThumbColor: isDark ? whiteColor : blackTextColor,
                      inactiveTrackColor:
                          isDark ? whiteColor : greyTextColor.withOpacity(0.3),
                      activeColor: isDark ? whiteColor : blueColor,
                      activeTrackColor:
                          isDark ? whiteColor : blueColor.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.only(left: 12.w),
                decoration: BoxDecoration(
                  color: isDark ? darkBgColor : bgColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                ),
                child: Row(
                  children: [
                    Text(
                      reminder.tr,
                      style: customTextStyle(
                        fontSize: 15.sp,
                        color: isDark ? whiteColor : blackTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: _reminderSwitchValue,
                      onChanged: absorb ? (_) {} : _changeReminderSwitchValue,
                      inactiveThumbColor: isDark ? whiteColor : blackTextColor,
                      inactiveTrackColor:
                          isDark ? whiteColor : greyTextColor.withOpacity(0.3),
                      activeColor: isDark ? whiteColor : blueColor,
                      activeTrackColor:
                          isDark ? whiteColor : blueColor.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                sendSmsMessageOnTheFirstDay.tr,
                style: customTextStyle(
                  fontSize: 15.sp,
                  color: isDark ? whiteColor : greyTextColor,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 40.h),
              BottomSheetBottomButtons(
                text: deleteTask.tr,
                buttonColor: thisMonthColor,
                onPressSave: () async {
                  LoadingOverlay.show(context);
                  if (widget.taskToEdit == null) {
                    if (_textEditingController.text.isEmpty ||
                        dateAndTime == pleaseEnterMonth.tr) {
                      showAttentionSnackBar(message: allFieldsRequired.tr);
                    } else {
                      await _todoScreenController.createTask(Todo(
                        monthTime: _changedDateTimeForEditTask,
                        taskName: _textEditingController.text,
                        status: TodoStatus.todo,
                        isGoal: _switchValue,
                        todoType: TodoType.monthly,
                        notes: _notesController.text,
                        isMonthlyReminderOn: _reminderSwitchValue,
                      ));
                      Navigator.of(context).pop(true);
                    }
                  } else {
                    await _todoScreenController
                        .editTask(widget.taskToEdit!.copyWith(
                      taskName: _textEditingController.text,
                      monthTime: _changedDateTimeForEditTask,
                      notes: _notesController.text,
                      isGoal: _switchValue,
                      isMonthlyReminderOn: _reminderSwitchValue,
                    ));
                    Navigator.of(context).pop(true);
                  }
                  LoadingOverlay.hide();
                },
                onPressDelete: () async {
                  LoadingOverlay.show(context);
                  if (widget.taskToEdit == null) {
                  } else {
                    await _todoScreenController.deleteTask(widget.taskToEdit!);
                  }
                  LoadingOverlay.hide();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
                showDeleteButton: widget.taskToEdit != null,
                showSaveButton: absorb == false,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}

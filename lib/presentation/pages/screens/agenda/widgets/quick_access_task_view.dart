import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/todo.dart';

class QuickAccessTaskView extends StatelessWidget {
  final Color backgroundColor;
  final Function(Todo) onCheckBoxValueChanged;
  final Todo todo;

  const QuickAccessTaskView({
    Key? key,
    required this.backgroundColor,
    required this.onCheckBoxValueChanged,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: Checkbox(
              value: todo.status == TodoStatus.done,
              onChanged: (value) {
                if (value == true) {
                  onCheckBoxValueChanged(todo);
                }
              },
              side: const BorderSide(
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6.w))),
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            todo.taskName,
            style: customTextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              textDecoration: todo.status == TodoStatus.done
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          const Spacer(),
          if (todo.todayTime != null)
            Text(
              DateFormat(
                'h:mm a',
                Get.locale?.languageCode,
              ).format(todo.todayTime!),
              style: customTextStyle(
                fontSize: 15.sp,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            )
        ],
      ),
    );
  }
}

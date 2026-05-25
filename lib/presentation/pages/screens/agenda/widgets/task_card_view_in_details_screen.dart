import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/localization/translation_keys.dart';

class TaskCardViewInDetailsScreen extends StatelessWidget {
  final Color cardColor;
  final Todo task;
  final DateTime? time;
  final Function(BuildContext) changeTaskStatus;

  const TaskCardViewInDetailsScreen({
    Key? key,
    required this.cardColor,
    required this.task,
    required this.changeTaskStatus,
    this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.all(Radius.circular(6.w)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: Checkbox(
                  value: task.status == TodoStatus.done,
                  onChanged: (_) {
                    changeTaskStatus(context);
                  },
                  side: const BorderSide(
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.w))),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  task.taskName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ).copyWith(
                      decoration: task.status == TodoStatus.done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
              ),
              SizedBox(width: 10.w),
              if (time != null) ...[
                Text(
                  DateFormat.jm().format(time!),
                  style: customTextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              if (task.isGoal) ...[
                Text(
                  goals.tr,
                  style: customTextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 4.w),
                const Icon(
                  Icons.star,
                  color: Colors.white,
                ),
              ],
            ],
          ),
          if (task.notes.isNotEmpty)
            Row(
              children: [
                SizedBox(width: 30.w),
                Expanded(
                  child: Text(
                    task.notes,
                    softWrap: true,
                    style: customTextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ).copyWith(height: (15.6 / 12).sp),
                  ),
                )
              ],
            )
        ],
      ),
    );
  }
}

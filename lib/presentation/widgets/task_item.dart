import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/utils/style/colors.dart';

class TaskItem extends StatelessWidget {
  final Todo todoItem;
  final VoidCallback onPressedItem;

  const TaskItem({
    Key? key,
    required this.todoItem,
    required this.onPressedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = todoItem.getBgColor() ?? whiteColor;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => onPressedItem(),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      todoItem.taskName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  if (todoItem.todoType == TodoType.daily && todoItem.todayTime != null)
                    Text(
                      DateFormat.jm().format(todoItem.todayTime!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: whiteColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                '${todoItem.notes}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

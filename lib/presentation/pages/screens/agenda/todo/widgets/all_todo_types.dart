import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/todo_screen_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/quick_access_task_view.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class AllTodoTypes extends StatefulWidget {
  final String title;
  final Future Function() func;
  final Color color;
  final RxList<Todo> allTodos;

  const AllTodoTypes({
    Key? key,
    required this.title,
    required this.func,
    required this.color,
    required this.allTodos,
  }) : super(key: key);

  @override
  State<AllTodoTypes> createState() => _AllTodoTypesState();
}

class _AllTodoTypesState extends State<AllTodoTypes> {
  final controller = Get.find<TodoScreenController>();
  bool? checkBoxValueOfTask = false;
  late String taskCount;

  void changeTaskStatus(Todo todo) async {
    CustomDialogs.show(
      context: context,
      title: completeTask.tr,
      onPressLeftButton: () => Navigator.pop(context),
      onPressRightButton: () async {
        LoadingOverlay.show(context);
        await Get.find<AgendaController>()
            .changeTodoStatus(widget.allTodos, todo);
        LoadingOverlay.hide();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: widget.func,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 16.w,
        ),
        //height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: isDark ? darkBgColor : whiteColor,
                    fontFamily: 'SF Pro Display',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(() {
                  if (widget.allTodos.isEmpty) {
                    taskCount = "";
                  } else if (widget.allTodos.length == 1) {
                    taskCount = "1 ${task.tr}";
                  } else {
                    taskCount = "${widget.allTodos.length} ${tasks.tr}";
                  }

                  return Text(
                    taskCount,
                    style: TextStyle(
                      color: isDark ? whiteColor : whiteColor,
                      fontFamily: 'SF Pro Display',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ],
            ),
            Obx(() {
              return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  if (index == 0) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10.h),
                        QuickAccessTaskView(
                          todo: widget.allTodos[index],
                          backgroundColor: isDark
                              ? greyButton.withOpacity(0.2)
                              : Colors.black.withOpacity(0.2),
                          onCheckBoxValueChanged: changeTaskStatus,
                        ),
                      ],
                    );
                  }
                  return QuickAccessTaskView(
                    todo: widget.allTodos[index],
                    backgroundColor: isDark
                        ? greyButton.withOpacity(0.2)
                        : Colors.black.withOpacity(0.2),
                    onCheckBoxValueChanged: changeTaskStatus,
                  );
                },
                separatorBuilder: (_, __) => SizedBox(height: 5.h),
                itemCount:
                    widget.allTodos.length > 2 ? 2 : widget.allTodos.length,
              );
            }),
          ],
        ),
      ),
    );
  }
}

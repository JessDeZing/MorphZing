import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_moth/this_month_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_year/this_year_screen_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/today/today_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/task_card_view_in_details_screen.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class TabBarViewChild extends StatelessWidget {
  final RxList<Todo> listOfTasksByStatus;
  final Function(Todo) onTapEditTask;
  final Color taskColor;
  final RxBool isPageEmpty;
  final bool? isGoal;
  final bool? isDone;

  const TabBarViewChild({
    Key? key,
    required this.listOfTasksByStatus,
    required this.onTapEditTask,
    required this.taskColor,
    required this.isPageEmpty,
    this.isGoal,
    this.isDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.h,
        ),
        child: isPageEmpty.value
            ? Center(
                child: Text(
                  noTasksYet.tr,
                  style: customTextStyle(
                    fontSize: 16.sp,
                    color: isDark ? whiteColor : greyTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: listOfTasksByStatus.length + 1,
                itemBuilder: (_, index) {
                  if (index == 0) {
                    int _counter = 0;
                    if (isGoal == null && isDone == null) {
                      _counter = listOfTasksByStatus.length;
                    } else {
                      for (var element in listOfTasksByStatus) {
                        if ((element.status == TodoStatus.done) == isDone &&
                            (element.isGoal == isGoal || isGoal == null)) {
                          _counter++;
                        }
                      }
                    }
                    String taskQuantity = '';
                    if (_counter == 1) {
                      taskQuantity = "1 ${task.tr}";
                    } else if (_counter != 0) {
                      taskQuantity = "$_counter ${tasks.tr}";
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          taskQuantity,
                          style: customTextStyle(
                            fontSize: 12.sp,
                            color: isDark ? whiteColor : greyTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  } else {
                    final actualTaskIndex = index - 1;
                    final task = listOfTasksByStatus[actualTaskIndex];
                    if ((isGoal == null && isDone == null) ||
                        ((task.status == TodoStatus.done) == isDone &&
                            (task.isGoal == isGoal || isGoal == null))) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              onTapEditTask(
                                  listOfTasksByStatus[actualTaskIndex]);
                            },
                            child: TaskCardViewInDetailsScreen(
                              cardColor: taskColor,
                              task: task,
                              changeTaskStatus: (BuildContext _context) =>
                                  _changeTaskStatus(
                                _context,
                                listOfTasksByStatus,
                                listOfTasksByStatus[actualTaskIndex],
                              ),
                              time: task.todayTime,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (index == listOfTasksByStatus.length)
                            const SizedBox(height: 8),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }
                },
              ),
      );
    });
  }

  void _changeTaskStatus(
    BuildContext context,
    RxList<Todo> todosListByTodoType,
    Todo task,
  ) async {
    CustomDialogs.show(
        context: context,
        title: completeTask.tr,
        onPressLeftButton: () => Navigator.pop(context),
        onPressRightButton: () async {
          LoadingOverlay.show(context);
          await Get.find<AgendaController>()
              .changeTodoStatus(todosListByTodoType, task);
          _checkAndCallController(todosListByTodoType, task);
          LoadingOverlay.hide();
          Navigator.pop(context);
        });
  }

  void _checkAndCallController(
    RxList<Todo> todosListByTodoType,
    Todo task,
  ) {
    try {
      switch (task.todoType) {
        case TodoType.daily:
          Get.find<TodayController>()
              .checkIfTabBarChildEmpty(todosListByTodoType);
          break;
        case TodoType.monthly:
          Get.find<ThisMonthController>()
              .checkIfTabBarChildEmpty(todosListByTodoType);
          break;
        case TodoType.yearly:
          Get.find<ThisYearScreenController>()
              .checkIfTabBarChildEmpty(todosListByTodoType);
          break;
        case null:
          break;
      }
    } on Object catch (_) {}
  }
}

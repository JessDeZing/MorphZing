import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/agenda_calendar.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/quick_access_task_view.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class TodoSingleWidget extends StatefulWidget {
  const TodoSingleWidget({Key? key}) : super(key: key);

  @override
  State<TodoSingleWidget> createState() => _TodoSingleWidgetState();
}

class _TodoSingleWidgetState extends State<TodoSingleWidget> {
  final controller = Get.find<AgendaController>();
  bool? checkBoxValueOfTask = false;
  late String taskCount;

@override
  void initState() {
    super.initState();
    _setTaskCountText();
  }

  void _setTaskCountText() {
    if (controller.allTodos.isEmpty) {
      taskCount = "";
    } else if (controller.allTodos.length == 1) {
      taskCount = "1 ${task.tr}";
    } else {
      taskCount = "${controller.allTodos.length} ${tasks.tr}";
    }
  }

  void changeTaskStatus(Todo todo) async {
    CustomDialogs.show(
      leftButton: no.tr,
      rightButton: yes.tr,
      context: context,
      title: completeTask.tr,
      onPressLeftButton: () => Navigator.pop(context),
      onPressRightButton: () async {
        LoadingOverlay.show(context);
        await controller.changeTodoStatus(controller.allTodos, todo);
        LoadingOverlay.hide();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      _setTaskCountText();
      return GestureDetector(
        onTap: () => Navigator.pushNamed(context, todoRoute),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 16.w,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: todayColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    todo.tr,
                    style: const TextStyle(
                      color: whiteColor,
                      fontFamily: 'SF Pro Display',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    taskCount,
                    style: const TextStyle(
                      color: whiteColor,
                      fontFamily: 'SF Pro Display',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (controller.allTodos.isNotEmpty) ...[
                SizedBox(height: 10.h),
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return QuickAccessTaskView(
                      todo: controller.allTodos[index],
                      backgroundColor: Colors.black.withOpacity(0.2),
                      onCheckBoxValueChanged: changeTaskStatus,
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 5.h),
                  itemCount: controller.allTodos.length > 2
                      ? 2
                      : controller.allTodos.length,
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}

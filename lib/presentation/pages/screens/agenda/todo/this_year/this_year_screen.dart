import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_year/this_year_screen_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_year/widgets/create_task_year_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_year/widgets/year_picker_widget.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/todo_screen_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/widgets/tab_bar_view_child.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class ThisYearScreen extends StatefulWidget {
  const ThisYearScreen({Key? key}) : super(key: key);

  @override
  State<ThisYearScreen> createState() => _ThisYearScreenState();
}

class _ThisYearScreenState extends State<ThisYearScreen> {
  final todoScreenController = Get.find<TodoScreenController>();

  void _onEditOrCreateTask(Todo? todo) async {
    final result = await CreateTaskYearBottomSheet.show(
        context: context, taskToEdit: todo);
    if (result == true) {
      final controller = Get.find<ThisYearScreenController>();
      LoadingOverlay.show(context);
      await controller.getThisYearTodos(controller.lastFocusedYear);
      await todoScreenController.getThisYearTodos(DateTime.now().year);
      LoadingOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: StaticAppBar.searchAppBar(context, yearly.tr, false, ''),
        body: GetX<ThisYearScreenController>(
          init: ThisYearScreenController(),
          initState: (_) {},
          builder: (logic) {
            return logic.pageLoading.value
                ? const Center(child: CircularProgressIndicator.adaptive())
                : Column(
                    children: [
                      SizedBox(height: 20.h),
                      YearPickerWidget(),
                      SizedBox(height: 20.h),
                      _typeBar(logic),
                    ],
                  );
          },
        ),
        floatingActionButton: CustomBottomBar.agendaFloatingActionButton(
          context: context,
          onPressed: () {
            _onEditOrCreateTask(null);
          },
          color: thisYearColor,
        ),
        bottomNavigationBar: CustomBottomBar.customBottomBar(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  _typeBar(ThisYearScreenController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: isDark ? darkBgColor : Colors.white,
              border: Border.symmetric(
                horizontal: BorderSide(
                  width: 0,
                  color: isDark ? whiteColor : dividerColor,
                ),
              ),
            ),
            child: TabBar(
              padding: EdgeInsets.zero,
              indicatorColor: thisYearColor,
              labelColor: thisYearColor,
              labelStyle: const TextStyle(
                color: thisYearColor,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro Display',
                fontSize: 14,
              ),
              unselectedLabelColor: isDark ? whiteColor : hintTextColor,
              tabs: [
                Tab(
                  text: all.tr,
                ),
                Tab(
                  text: todo.tr,
                ),
                Tab(
                  child: Row(
                    children: [
                      Text(goals.tr),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.star,
                        size: 14,
                      ),
                    ],
                  ),
                ),
                Tab(
                  text: done.tr,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                TabBarViewChild(
                  listOfTasksByStatus: controller.yearTodos,
                  onTapEditTask: _onEditOrCreateTask,
                  taskColor: thisYearColor,
                  isPageEmpty: controller.allPageEmpty,
                ),
                TabBarViewChild(
                  listOfTasksByStatus: controller.yearTodos,
                  onTapEditTask: _onEditOrCreateTask,
                  taskColor: thisYearColor,
                  isGoal: false,
                  isDone: false,
                  isPageEmpty: controller.todoPageEmpty,
                ),
                TabBarViewChild(
                  listOfTasksByStatus: controller.yearTodos,
                  onTapEditTask: _onEditOrCreateTask,
                  taskColor: thisYearColor,
                  isDone: false,
                  isGoal: true,
                  isPageEmpty: controller.goalPageEmpty,
                ),
                TabBarViewChild(
                  listOfTasksByStatus: controller.yearTodos,
                  onTapEditTask: _onEditOrCreateTask,
                  taskColor: thisYearColor,
                  isDone: true,
                  isPageEmpty: controller.donePageEmpty,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

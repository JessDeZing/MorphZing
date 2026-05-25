import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/todo_screen_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/widgets/all_todo_types.dart';
import 'package:morphzing/presentation/widgets/bottom_sheet_for_floating_button.dart';
import 'package:morphzing/utils/loading_overlay.dart';

import '../../../../../utils/style/colors.dart';
import '../../../../routers/rout_names.dart';
import '../../../../widgets/app_bar.dart';
import '../../../../widgets/custom_bottom_bar.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final currentDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: StaticAppBar.searchAppBar(context, todo.tr, false, ''),
        body: GetX<TodoScreenController>(
          init: TodoScreenController(),
          initState: (_) {},
          builder: (logic) {
            return logic.pageLoading.value
                ? const Center(child: CircularProgressIndicator.adaptive())
                : Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ListView(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              AllTodoTypes(
                                title: today.tr,
                                func: () async {
                                  final shouldRefresh =
                                      await Navigator.of(context)
                                          .pushNamed(todayRoute);
                                  if (shouldRefresh == true) {
                                    LoadingOverlay.show(context);
                                    await logic.getTodayTodos(currentDateTime);
                                    LoadingOverlay.hide();
                                  }
                                },
                                color: todayColor,
                                allTodos: logic.todayTodos,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              AllTodoTypes(
                                title: monthly.tr,
                                func: () async {
                                  final shouldRefresh =
                                      await Navigator.of(context)
                                          .pushNamed(thisMonthRoute);
                                  if (shouldRefresh == true) {
                                    LoadingOverlay.show(context);
                                    await logic
                                        .getThisMonthTodos(currentDateTime);
                                    LoadingOverlay.hide();
                                  }
                                },
                                color: thisMonthColor,
                                allTodos: logic.thisMonthTodos,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              AllTodoTypes(
                                title: yearly.tr,
                                func: () async {
                                  final shouldRefresh =
                                      await Navigator.of(context)
                                          .pushNamed(thisYearRoute);
                                  if (shouldRefresh == true) {
                                    LoadingOverlay.show(context);
                                    await logic
                                        .getThisYearTodos(currentDateTime.year);
                                    LoadingOverlay.hide();
                                  }
                                },
                                color: thisYearColor,
                                allTodos: logic.thisYearTodos,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
        floatingActionButton: CustomBottomBar.customFloatingActionButton(() {
          _onFloatingButtonPressed(context);
        }),
        bottomNavigationBar: CustomBottomBar.customBottomBar(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  void _onFloatingButtonPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const BottomSheetForFloatingButton(),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black38,
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/today/today_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/today/widgets/create_task_today_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/todo_screen_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/widgets/tab_bar_view_child.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../../utils/style/colors.dart';
import '../../../../../widgets/app_bar.dart';
import '../../../../../widgets/custom_bottom_bar.dart';

class TodayScreen extends StatefulWidget {
  final DateTime? chosenDayFromMonthly;

  const TodayScreen({
    Key? key,
    this.chosenDayFromMonthly,
  }) : super(key: key);

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  late double widthOfEachCell =
      ((MediaQuery.of(context).size.width - 100.w) / 7).w;
  final todoScreenController = Get.find<TodoScreenController>();
  final agendaController = Get.find<AgendaController>();
  final appController = Get.find<AppController>();
  late final todayController =
      TodayController(chosenDayFromMonthly: widget.chosenDayFromMonthly);

  void _onEditOrCreateTask(Todo? todo) async {
    final result = await CreateTaskTodayBottomSheet.show(
        context: context,
        taskToEdit: todo,
        chosenTime: todo?.todayTime ?? todayController.focusedDay.value);
    if (result == true) {
      final controller = Get.find<TodayController>();
      LoadingOverlay.show(context);
      await controller.getTodayTodos(controller.focusedDay.value);
      unawaited(todoScreenController.getTodayTodos(DateTime.now()));
      unawaited(agendaController.getAgendaCalendar());
      LoadingOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: isDark ? darkBgColor : whiteColor,
        appBar: StaticAppBar.searchAppBar(context, today.tr, false, ''),
        body: GetX<TodayController>(
          init: todayController,
          initState: (_) {},
          builder: (logic) {
            return logic.pageLoading.value
                ? const Center(child: CircularProgressIndicator.adaptive())
                : Column(
                    children: [
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                            16.w,
                            20.w,
                            16.w,
                            16.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.w)),
                            color: todayColor.withOpacity(0.05),
                          ),
                          child: TableCalendar(
                            locale: Get.locale?.languageCode,
                            focusedDay: logic.focusedDay.value,
                            firstDay: logic.startDay,
                            lastDay: logic.lastDay,
                            calendarFormat: CalendarFormat.week,
                            rowHeight: 70.h,
                            headerStyle: _headerStyle,
                            daysOfWeekVisible: false,
                            onDaySelected: (_firstDay, _secondDay) async {
                              LoadingOverlay.show(context);
                              await logic.selectDayAndFetchTasks(_firstDay);
                              LoadingOverlay.hide();
                            },
                            calendarBuilders: CalendarBuilders(
                              disabledBuilder: (_, _day, __) {
                                return SizedBox(
                                  width: widthOfEachCell,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${_day.day}',
                                        style: customTextStyle(
                                          fontSize: 14.sp,
                                          color: isDark
                                              ? whiteColor
                                              : greyTextColor.withOpacity(0.3),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        appController.dateFormat.format(_day),
                                        style: customTextStyle(
                                          fontSize: 14.sp,
                                          color: isDark
                                              ? whiteColor
                                              : greyTextColor.withOpacity(0.3),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              outsideBuilder: (_, _day, __) {
                                return SizedBox(
                                  width: widthOfEachCell,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${_day.day}',
                                        style: customTextStyle(
                                          fontSize: 14.sp,
                                          color: isDark
                                              ? whiteColor
                                              : greyTextColor.withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        appController.dateFormat.format(_day),
                                        style: customTextStyle(
                                          fontSize: 14.sp,
                                          color: isDark
                                              ? whiteColor
                                              : greyTextColor.withOpacity(0.7),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              defaultBuilder: (_, day, focusedDay) {
                                if (isSameDay(day, logic.focusedDay.value)) {
                                  return Container(
                                    width: widthOfEachCell,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.w)),
                                      color: todayColor,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${day.day}',
                                          style: customTextStyle(
                                            fontSize: 14.sp,
                                            color: isDark
                                                ? whiteColor
                                                : Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          appController.dateFormat.format(day),
                                          style: customTextStyle(
                                            fontSize: 14.sp,
                                            color: isDark
                                                ? whiteColor
                                                : Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return SizedBox(
                                  width: widthOfEachCell,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${day.day}',
                                        style: customTextStyle(
                                          fontSize: 14.sp,
                                          color: isDark
                                              ? whiteColor
                                              : greyTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        appController.dateFormat.format(day),
                                        style: customTextStyle(
                                          fontSize: 14.sp,
                                          color: isDark
                                              ? whiteColor
                                              : greyTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              todayBuilder: (_, day, focusedDay) {
                                if (isSameDay(day, logic.focusedDay.value)) {
                                  return Container(
                                    width: widthOfEachCell,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.w)),
                                      color: todayColor,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${day.day}',
                                          style: customTextStyle(
                                            fontSize: 14.sp,
                                            color: isDark
                                                ? whiteColor
                                                : Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          appController.dateFormat.format(day),
                                          style: customTextStyle(
                                            fontSize: 14.sp,
                                            color: isDark
                                                ? whiteColor
                                                : Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return Container(
                                  width: widthOfEachCell,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.w)),
                                      border: Border.all(color: todayColor)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${day.day}',
                                        style: customTextStyle(
                                          fontSize: 14.sp,
                                          color: isDark
                                              ? whiteColor
                                              : greyTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        appController.dateFormat.format(day),
                                        style: customTextStyle(
                                          fontSize: 14.sp,
                                          color: isDark
                                              ? whiteColor
                                              : greyTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 21.h),
                      _typeBar(logic),
                    ],
                  );
          },
        ),
        floatingActionButton: CustomBottomBar.agendaFloatingActionButton(
          color: todayColor,
          context: context,
          onPressed: () {
            _onEditOrCreateTask(null);
          },
        ),
        bottomNavigationBar: CustomBottomBar.customBottomBar(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  _typeBar(TodayController controller) {
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
                  color: isDark ? darkBorderColor : dividerColor,
                ),
              ),
            ),
            child: TabBar(
              padding: EdgeInsets.zero,
              indicatorColor: todayColor,
              labelColor: todayColor,
              labelStyle: const TextStyle(
                color: todayColor,
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
                  listOfTasksByStatus: controller.listOfTodos,
                  onTapEditTask: _onEditOrCreateTask,
                  taskColor: todayColor,
                  isPageEmpty: controller.allPageEmpty,
                ),
                TabBarViewChild(
                  listOfTasksByStatus: controller.listOfTodos,
                  onTapEditTask: _onEditOrCreateTask,
                  taskColor: todayColor,
                  isDone: false,
                  isGoal: false,
                  isPageEmpty: controller.todoPageEmpty,
                ),
                TabBarViewChild(
                  listOfTasksByStatus: controller.listOfTodos,
                  onTapEditTask: _onEditOrCreateTask,
                  taskColor: todayColor,
                  isDone: false,
                  isGoal: true,
                  isPageEmpty: controller.goalPageEmpty,
                ),
                TabBarViewChild(
                  listOfTasksByStatus: controller.listOfTodos,
                  onTapEditTask: _onEditOrCreateTask,
                  taskColor: todayColor,
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

  late final HeaderStyle _headerStyle = HeaderStyle(
    titleTextStyle: customTextStyle(
      fontSize: 16.sp,
      color: todayColor,
      fontWeight: FontWeight.w500,
    ),
    titleCentered: true,
    formatButtonVisible: false,
    headerPadding: EdgeInsets.only(bottom: 18.h),
    leftChevronMargin:
        EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
    leftChevronPadding: EdgeInsets.zero,
    leftChevronIcon: const Icon(
      Icons.chevron_left,
      color: todayColor,
    ),
    rightChevronMargin:
        EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
    rightChevronPadding: EdgeInsets.zero,
    rightChevronIcon: const Icon(
      Icons.chevron_right,
      color: todayColor,
    ),
  );
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_moth/this_month_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_moth/widgets/create_task_month_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_moth/widgets/header_for_calendar.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/todo_screen_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/widgets/tab_bar_view_child.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class ThisMonthScreen extends StatefulWidget {
  const ThisMonthScreen({Key? key}) : super(key: key);

  @override
  State<ThisMonthScreen> createState() => _ThisMonthScreenState();
}

class _ThisMonthScreenState extends State<ThisMonthScreen> {
  final todoScreenController = Get.find<TodoScreenController>();
  final appController = Get.find<AppController>();

  void _onEditOrCreateTask(Todo? todo) async {
    final result = await CreateTaskMonthBottomSheet.show(
      context: context,
      taskToEdit: todo,
    );
    if (result == true) {
      final controller = Get.find<ThisMonthController>();
      LoadingOverlay.show(context);
      await controller.getThisMonthTodos(controller.lastFocusedMonth);
      await todoScreenController.getThisMonthTodos(DateTime.now());
      LoadingOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: StaticAppBar.searchAppBar(
          context,
          monthly.tr,
          false,
          '',
        ),
        body: GetX<ThisMonthController>(
          init: ThisMonthController(),
          builder: (controller) {
            return controller.pageLoading.value
                ? const Center(child: CircularProgressIndicator.adaptive())
                : NestedScrollView(
                    headerSliverBuilder: (_, __) {
                      return [
                        SliverToBoxAdapter(
                          child: _calendar(controller),
                        ),
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          backgroundColor:
                              isDark ? darkBgColor : Colors.transparent,
                          flexibleSpace: _tabBar(),
                          elevation: 0,
                          toolbarHeight: 48.h,
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        TabBarViewChild(
                          listOfTasksByStatus: controller.monthTodoTasks,
                          onTapEditTask: _onEditOrCreateTask,
                          taskColor: thisMonthColor,
                          isPageEmpty: controller.allPageEmpty,
                        ),
                        TabBarViewChild(
                          listOfTasksByStatus: controller.monthTodoTasks,
                          onTapEditTask: _onEditOrCreateTask,
                          taskColor: thisMonthColor,
                          isDone: false,
                          isGoal: false,
                          isPageEmpty: controller.todoPageEmpty,
                        ),
                        TabBarViewChild(
                          listOfTasksByStatus: controller.monthTodoTasks,
                          onTapEditTask: _onEditOrCreateTask,
                          taskColor: thisMonthColor,
                          isDone: false,
                          isGoal: true,
                          isPageEmpty: controller.goalPageEmpty,
                        ),
                        TabBarViewChild(
                          listOfTasksByStatus: controller.monthTodoTasks,
                          onTapEditTask: _onEditOrCreateTask,
                          taskColor: thisMonthColor,
                          isDone: true,
                          isPageEmpty: controller.donePageEmpty,
                        ),
                      ],
                    ),
                  );
          },
        ),
        floatingActionButton: CustomBottomBar.agendaFloatingActionButton(
          context: context,
          onPressed: () {
            _onEditOrCreateTask(null);
          },
          color: thisMonthColor,
        ),
        bottomNavigationBar: CustomBottomBar.customBottomBar(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _calendar(ThisMonthController _controller) {
    return Container(
      decoration: BoxDecoration(
        color: thisMonthColor.withOpacity(.1),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 28.w,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      alignment: Alignment.center,
      child: Obx(() {
        return Column(
          children: [
            HeaderForCalendar(
              focusedDay: _controller.focusedDay.value,
              onLeftArrowTap: () async {
                _controller.pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              onRightArrowTap: () async {
                _controller.pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              color: thisMonthColor,
            ),
            SizedBox(height: 16.h),
            GetBuilder<ThisMonthController>(builder: (_) {
              return TableCalendar<bool>(
                locale: appController.dateFormat.locale,
                availableGestures: AvailableGestures.horizontalSwipe,
                onCalendarCreated: (controller) =>
                    _controller.pageController = controller,
                firstDay: _controller.startDay,
                lastDay: _controller.lastDay,
                sixWeekMonthsEnforced: true,
                focusedDay: _controller.focusedDay.value,
                eventLoader: _controller.getEventsForDay,
                currentDay: DateTime.now(),
                headerVisible: false,
                rowHeight: 42.h,
                onPageChanged: (_focusedDay) async {
                  LoadingOverlay.show(context);
                  _controller.changeFocusedDay(_focusedDay);
                  await _controller.getThisMonthTodos(_focusedDay);
                  _controller.lastFocusedMonth = _focusedDay;
                  LoadingOverlay.hide();
                },
                weekendDays: const [],
                holidayPredicate: (_) => false,
                calendarBuilders: CalendarBuilders(
                  weekNumberBuilder: (_, __) => const SizedBox(),
                  holidayBuilder: (_, __, ___) => const SizedBox(),
                  todayBuilder: (_, _currentDay, _focusedDay) {
                    return GestureDetector(
                      onTap: () {
                        if (_controller.listOfDaysWithEvents[_currentDay] ==
                            true) {
                          _goToTodayScreen(_currentDay);
                        }
                      },
                      child: Center(
                        child: SizedBox(
                          height: 32.w,
                          width: 32.w,
                          child: Text(
                            '${_currentDay.day}',
                            textAlign: TextAlign.center,
                            style: customTextStyle(
                              fontSize: 14.sp,
                              color: _currentDay.month == _focusedDay.month
                                  ? greyTextColor
                                  : dowThisMonthCalendar,
                              fontWeight: FontWeight.w500,
                            ).copyWith(height: (22 / 14).sp),
                          ),
                        ),
                      ),
                    );
                  },
                  dowBuilder: (_, _week) {
                    return SizedBox(
                      width: 26.w,
                      height: 13.h,
                      child: Center(
                        child: Text(
                          appController.dateFormat.format(_week),
                          textAlign: TextAlign.center,
                          style: customTextStyle(
                            fontSize: 11.sp,
                            color: dowThisMonthCalendar,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                  defaultBuilder: (_, _givenDay, _focusedDay) {
                    return GestureDetector(
                      onTap: () {
                        if (_controller.listOfDaysWithEvents[_givenDay] ==
                            true) {
                          _goToTodayScreen(_givenDay);
                        }
                      },
                      child: Center(
                        child: SizedBox(
                          height: 32.w,
                          width: 32.w,
                          child: Text(
                            '${_givenDay.day}',
                            textAlign: TextAlign.center,
                            style: customTextStyle(
                              fontSize: 14.sp,
                              color: greyTextColor,
                              fontWeight: FontWeight.w500,
                            ).copyWith(height: (22 / 14).sp),
                          ),
                        ),
                      ),
                    );
                  },
                  outsideBuilder: (_, _givenDay, _focusedDay) {
                    return Center(
                      child: SizedBox(
                        height: 32.w,
                        width: 32.w,
                        child: Text(
                          '${_givenDay.day}',
                          textAlign: TextAlign.center,
                          style: customTextStyle(
                            fontSize: 14.sp,
                            color: dowThisMonthCalendar,
                            fontWeight: FontWeight.w500,
                          ).copyWith(height: (22 / 14).sp),
                        ),
                      ),
                    );
                  },
                  singleMarkerBuilder: (_, _currentDay, _hasEvent) {
                    if (_hasEvent) {
                      return Container(
                        height: 4.h,
                        width: 10.w,
                        decoration: BoxDecoration(
                          color: thisMonthColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.w)),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _tabBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
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
            indicatorColor: thisMonthColor,
            labelColor: thisMonthColor,
            labelStyle: const TextStyle(
              color: thisMonthColor,
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
      ],
    );
  }

  void _goToTodayScreen(DateTime chosenDay) {
    Get.toNamed(todayRoute, arguments: chosenDay);
  }
}

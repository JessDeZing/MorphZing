import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/create_or_edit_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/list_tile_event.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/model/event_with_participants.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/participant_event_details.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/today/widgets/create_task_today_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/todo_screen_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/task_card_view_in_details_screen.dart';
import 'package:morphzing/presentation/pages/screens/calendar/calendar_screen_controller.dart';
import 'package:morphzing/presentation/pages/screens/calendar/tasks_events_details/tasks_events_controller.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class TasksAndEventsScreen extends StatefulWidget {
  final DateTime time;

  const TasksAndEventsScreen({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  State<TasksAndEventsScreen> createState() => _TasksAndEventsScreenState();
}

class _TasksAndEventsScreenState extends State<TasksAndEventsScreen> {
  final calendarController = Get.find<CalendarScreenController>();
  final agendaController = Get.find<AgendaController>();

  @override
  void initState() {
    super.initState();
    Get.put<TodoScreenController>(
      TodoScreenController(),
      tag: "TaskEventsScreen",
    );
  }

  @override
  void dispose() {
    Get.delete<TodoScreenController>(tag: "TaskEventsScreen");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black26,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isDark ? whiteColor : blackTextColor,
            ),
          ),
          backgroundColor: isDark ? darkBgColor : bgColor,
          centerTitle: true,
          title: Text(
            DateFormat('MMMM d, yyyy').format(widget.time),
            style: TextStyle(
              color: isDark ? whiteColor : blackTextColor,
              fontFamily: 'SF Pro Display',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Center(
                child: SizedBox(
                    height: 30,
                    width: 30,
                    child: SvgPicture.asset('assets/icons/premium.svg')),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: GetX<TasksEventsController>(
          init: TasksEventsController(widget.time),
          builder: (logic) {
            return logic.pageLoading.value
                ? const Center(child: CircularProgressIndicator.adaptive())
                : Column(
                    children: <Widget>[
                      // the tab bar with two items
                      SizedBox(
                        height: 50,
                        child: AppBar(
                          backgroundColor: isDark ? darkBgColor : bgColor,
                          bottom: TabBar(
                            labelColor: Colors.blue,
                            indicatorColor: Colors.blue,
                            unselectedLabelColor:
                                isDark ? whiteColor : greyTextColor,
                            tabs: [
                              Tab(
                                text: todoCapital.tr,
                              ),
                              Tab(
                                text: capitalEvents.tr,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // first tab bar view widget
                            logic.dailyTodos.isEmpty
                                ? Center(
                                    child: Text(
                                      'No Tasks for Today',
                                      style: TextStyle(
                                        color:
                                            isDark ? whiteColor : greyTextColor,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 10),
                                    itemBuilder: (_, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          _onEditTask(
                                              logic.dailyTodos[index], logic);
                                        },
                                        child: TaskCardViewInDetailsScreen(
                                          cardColor: todayColor,
                                          task: logic.dailyTodos[index],
                                          time:
                                              logic.dailyTodos[index].todayTime,
                                          changeTaskStatus:
                                              (BuildContext _context) =>
                                                  _changeTaskStatus(
                                            _context,
                                            logic.dailyTodos,
                                            logic.dailyTodos[index],
                                            logic,
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: logic.dailyTodos.length,
                                    shrinkWrap: true,
                                  ),
                            logic.events.isEmpty
                                ? Center(
                                    child: Text(
                                      'No Events for Today',
                                      style: TextStyle(
                                        color:
                                            isDark ? whiteColor : greyTextColor,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 10),
                                    itemBuilder: (_, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          _onEditEvent(
                                            logic.events[index],
                                            calendarController.getCorrectColor(
                                                logic.events[index].event
                                                    .categoryId),
                                            logic
                                                .events[index].event.categoryId,
                                            logic,
                                          );
                                        },
                                        child: ListTileEvent(
                                          color: calendarController
                                              .getCorrectColor(logic
                                                  .events[index]
                                                  .event
                                                  .categoryId),
                                          event: logic.events[index].event,
                                          onRefreshCalendar: () async {
                                            await logic.getTasksEventsByDay(
                                                widget.time);
                                          },
                                          gradient: logic.events[index].event
                                                      .categoryId ==
                                                  agendaController
                                                      .listOfAgendaNames[4].id
                                              ? specialOccasionGradient
                                              : null,
                                        ),
                                      );
                                    },
                                    itemCount: logic.events.length,
                                    shrinkWrap: true,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  void _changeTaskStatus(
    BuildContext context,
    RxList<Todo> todosListByTodoType,
    Todo task,
    TasksEventsController controller,
  ) async {
    CustomDialogs.show(
      context: context,
      title: 'Are you sure you want to complete this task?',
      onPressLeftButton: () => Navigator.pop(context),
      onPressRightButton: () async {
        LoadingOverlay.show(context);
        await agendaController.changeTodoStatus(todosListByTodoType, task);
        await controller.getTasksEventsByDay(widget.time);
        LoadingOverlay.hide();
        Navigator.pop(context);
      },
    );
  }

  void _onEditTask(Todo todo, TasksEventsController controller) async {
    final result = await CreateTaskTodayBottomSheet.show(
      context: context,
      taskToEdit: todo,
      chosenTime: todo.todayTime!,
    );
    if (result == true) {
      LoadingOverlay.show(context);
      await controller.getTasksEventsByDay(widget.time);
      unawaited(calendarController.getCalendarMonth(widget.time));
      LoadingOverlay.hide();
    }
  }

  void _onEditEvent(
    EventWithParticipants eventWithParticipants,
    Color? color,
    int categoryId,
    TasksEventsController controller,
  ) async {
    if (eventWithParticipants.event.isParticipant) {
      await ParticipantEventDetails.show(
        context: context,
        event: eventWithParticipants.event,
      );
      return;
    } else {
      final result = await CreateOrEditBottomSheet.editEvent(
        context: context,
        eventWithParticipants: eventWithParticipants,
        color: color,
        categoryId: categoryId,
        chosenTime: widget.time,
      );
      if (result == true) {
        LoadingOverlay.show(context);
        await controller.getTasksEventsByDay(widget.time);
        unawaited(calendarController.getCalendarMonth(widget.time));
        LoadingOverlay.hide();
      }
    }
  }
}

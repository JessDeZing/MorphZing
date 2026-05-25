import 'dart:collection';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/data/repositories/agenda/agenda_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:table_calendar/table_calendar.dart';

class ThisMonthController extends GetxController {
  final _agendaRepository = getIt<AgendaRepository>();
  Rx<DateTime> focusedDay = DateTime.now().obs;
  DateTime startDay = DateTime.now().add(-180.days);
  DateTime lastDay = DateTime(DateTime.now().year + 1, 12, 31);
  RxList<Todo> monthTodoTasks = RxList();
  RxBool pageLoading = true.obs;
  DateTime today = DateTime.now();

  //using to update the list of tasks according to last stopped month in calendar
  DateTime lastFocusedMonth = DateTime.now();
  PageController pageController = PageController();

  //-------- for tab bar children
  RxBool allPageEmpty = true.obs;
  RxBool todoPageEmpty = true.obs;
  RxBool goalPageEmpty = true.obs;
  RxBool donePageEmpty = true.obs;

  final LinkedHashMap<DateTime, bool> listOfDaysWithEvents =
      LinkedHashMap<DateTime, bool>(
    hashCode: (key) => key.day * 1000000 + key.month * 10000 + key.year,
    equals: isSameDay,
  );

  @override
  void onInit() async {
    super.onInit();
    await getThisMonthTodos(today);
    pageLoading.value = false;
  }

  List<bool> getEventsForDay(DateTime day) {
    return listOfDaysWithEvents[day] == null
        ? []
        : [listOfDaysWithEvents[day]!];
  }

  void _buildDayConfirmedTasks(List<Todo> dayConfirmedTaskList) {
    for (var item in dayConfirmedTaskList) {
      Map<DateTime, bool> event = {item.todayTime!: true};
      listOfDaysWithEvents.addAll(event);
    }
    update();
  }

  Future<void> getThisMonthTodos(DateTime chosenMonth) async {
    try {
      final response = await _agendaRepository.getAgendaCalendar(
        DateTime(chosenMonth.year, chosenMonth.month, 1),
        DateTime(chosenMonth.year, chosenMonth.month + 1, 0),
      );
      listOfDaysWithEvents.clear();
      _buildDayConfirmedTasks(response.todos.daily);
      monthTodoTasks.clear();
      for (var element in response.todos.monthly) {
        monthTodoTasks.add(element);
      }
      checkIfTabBarChildEmpty(monthTodoTasks);
    } on DioError catch (e) {
      log("error: ${e.response}");
    }
  }

  void changeFocusedDay(DateTime newFocusedDay) {
    focusedDay.value = newFocusedDay;
  }

  void checkIfTabBarChildEmpty(List<Todo> list) {
    allPageEmpty.value = true;
    goalPageEmpty.value = true;
    todoPageEmpty.value = true;
    donePageEmpty.value = true;
    if (list.isNotEmpty) {
      allPageEmpty.value = false;
      for (var element in list) {
        if (element.status == TodoStatus.todo) {
          if (element.isGoal) {
            goalPageEmpty.value = false;
          } else {
            todoPageEmpty.value = false;
          }
        } else {
          donePageEmpty.value = false;
        }
      }
    }
  }
}

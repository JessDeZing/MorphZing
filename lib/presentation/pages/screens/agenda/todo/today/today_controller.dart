import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/data/repositories/agenda/agenda_repository.dart';
import 'package:morphzing/di/di_config.dart';

class TodayController extends GetxController {
  final DateTime? chosenDayFromMonthly;

  TodayController({this.chosenDayFromMonthly});

  final _agendaRepository = getIt<AgendaRepository>();
  RxList<Todo> listOfTodos = RxList([]);
  RxBool pageLoading = true.obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  DateTime startDay = DateTime(DateTime.now().year, 1, 1);
  DateTime lastDay = DateTime(DateTime.now().year + 3, 12, 31);

  //-------- for tab bar children
  RxBool allPageEmpty = true.obs;
  RxBool todoPageEmpty = true.obs;
  RxBool goalPageEmpty = true.obs;
  RxBool donePageEmpty = true.obs;

  @override
  void onInit() async {
    super.onInit();
    if (chosenDayFromMonthly != null) {
      focusedDay.value = chosenDayFromMonthly!;
      await getTodayTodos(chosenDayFromMonthly!);
    } else {
      await getTodayTodos(DateTime.now());
    }
    pageLoading.value = false;
  }

  Future<void> getTodayTodos(DateTime day) async {
    try {
      final agendaCalendar =
          await _agendaRepository.getAgendaCalendar(day, day);
      listOfTodos.clear();
      for (var element in agendaCalendar.todos.daily) {
        listOfTodos.add(element);
      }
      checkIfTabBarChildEmpty(listOfTodos);
    } on DioError catch (e) {
      log("TodayController: ${e.response}");
    }
  }

/*  Future<void> changeSingleTodo(Todo todo) async {
    try {
      await _agendaRepository.updateAgendaTodo(todo);
    } on DioError catch (e) {
      log("TodayController: ${e.response}");
    }
  }*/

  Future<void> selectDayAndFetchTasks(DateTime day) async {
    focusedDay.value = day;
    await getTodayTodos(day);
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

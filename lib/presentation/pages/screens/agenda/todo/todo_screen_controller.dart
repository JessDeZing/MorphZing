import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/data/repositories/agenda/agenda_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/show_error.dart';

class TodoScreenController extends GetxController {
  final _agendaRepository = getIt<AgendaRepository>();
  RxBool pageLoading = true.obs;
  RxList<Todo> todayTodos = RxList();
  RxList<Todo> thisMonthTodos = RxList();
  RxList<Todo> thisYearTodos = RxList();

  @override
  void onInit() async {
    super.onInit();
    await getAllRelevantTodos();
    pageLoading.value = false;
  }

  Future<void> getAllRelevantTodos() async {
    final currentTime = DateTime.now();
    await getTodayTodos(currentTime);
    await getThisMonthTodos(currentTime);
    await getThisYearTodos(currentTime.year);
  }

  Future<void> getTodayTodos(DateTime chosenDay) async {
    try {
      final response =
          await _agendaRepository.getAgendaCalendar(chosenDay, chosenDay);
      todayTodos.clear();
      for (var element in response.todos.daily) {
        todayTodos.add(element);
      }
    } on DioError catch (e) {
      log("error: ${e.response}");
    }
  }

  Future<void> getThisMonthTodos(DateTime chosenMonth) async {
    try {
      final response = await _agendaRepository.getAgendaCalendar(
        DateTime(
          chosenMonth.year,
          chosenMonth.month,
          1,
        ),
        DateTime(
          chosenMonth.year,
          chosenMonth.month + 1,
          0,
        ),
      );
      thisMonthTodos.clear();
      for (var element in response.todos.monthly) {
        thisMonthTodos.add(element);
      }
    } on DioError catch (e) {
      log("error: ${e.response}");
    }
  }

  Future<void> getThisYearTodos(int chosenYear) async {
    try {
      final response = await _agendaRepository.getAgendaCalendar(
        DateTime(
          chosenYear,
          1,
          1,
        ),
        DateTime(
          chosenYear,
          12,
          31,
        ),
      );
      thisYearTodos.clear();
      for (var element in response.todos.yearly) {
        thisYearTodos.add(element);
      }
    } on DioError catch (e) {
      log("error: ${e.response}");
    }
  }

  List<Todo> getSortedList(
    TodoStatus todoStatus,
    bool? isGoal,
    List<Todo> listOfTodos,
  ) {
    List<Todo> result = [];
    if (isGoal != null) {
      for (var element in listOfTodos) {
        if (element.status == todoStatus && element.isGoal == isGoal) {
          result.add(element);
        }
      }
    } else {
      for (var element in listOfTodos) {
        if (element.status == todoStatus) {
          result.add(element);
        }
      }
    }

    return result;
  }

  Future<void> createTask(Todo todo) async {
    try {
      await _agendaRepository.createAgendaTodo(todo);
      showGetSnackBar(message: taskCreated.tr);
    } on DioError catch (e) {
      log("Error in creation: ${e.response}");
    }
  }

  Future<void> editTask(Todo task) async {
    try {
      log('task is ${task.toString()}');
      await _agendaRepository.updateAgendaTodo(task);
      showGetSnackBar(message: taskEdited.tr);
    } on DioError catch (e) {
      log('Error: ${e.response}');
    }
  }

  Future<void> deleteTask(Todo task) async {
    try {
      await _agendaRepository.deleteTask(task);
      showGetSnackBar(message: taskDeleted.tr);
    } on DioError catch (e) {
      log('Error: ${e.response}');
    }
  }
}

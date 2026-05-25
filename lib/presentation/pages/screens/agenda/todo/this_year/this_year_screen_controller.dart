import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/data/repositories/agenda/agenda_repository.dart';
import 'package:morphzing/di/di_config.dart';

class ThisYearScreenController extends GetxController {
  final _agendaRepository = getIt<AgendaRepository>();
  RxList<Todo> yearTodos = RxList();
  RxBool pageLoading = true.obs;
  int lastFocusedYear = DateTime.now().year;

  //-------- for tab bar children
  RxBool allPageEmpty = true.obs;
  RxBool todoPageEmpty = true.obs;
  RxBool goalPageEmpty = true.obs;
  RxBool donePageEmpty = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await getThisYearTodos(DateTime.now().year);
    pageLoading.value = false;
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
      yearTodos.clear();
      for (var element in response.todos.yearly) {
        yearTodos.add(element);
      }
      checkIfTabBarChildEmpty(yearTodos);
    } on DioError catch (e) {
      log("error: ${e.response}");
    }
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

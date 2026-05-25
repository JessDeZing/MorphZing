import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/repositories/agenda/agenda_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/calendar/model/cell_events_todos.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreenController extends GetxController {
  final _agendaRepository = getIt<AgendaRepository>();
  Rx<DateTime> focusedDay = DateTime.now().obs;
  Rx<DateTime> selectedDay = DateTime.now().obs;
  DateTime startTime = DateTime.now().subtract(90.days);
  DateTime endTime = DateTime.now().add((365 * 3).days);
  RxBool pageLoading = true.obs;
  RxMap<int, List<CellEventsTodos>> calendarData = RxMap({});

  late PageController pageController;

  @override
  void onInit() async {
    super.onInit();
    pageController = PageController();
    await getCalendarMonth(focusedDay.value);
    pageLoading.value = false;
  }

  void selectDay(DateTime time) {
    selectedDay.value = time;
  }

  Future<void> changeFocusedDay(DateTime time) async {
    focusedDay.value = time;
  }

  Future<void> getCalendarMonth(DateTime month) async {
    try {
      calendarData.clear();
      final response = await _agendaRepository.getAgendaCalendarPerMonth(
        DateTime(month.year, month.month, 1),
        DateTime(month.year, month.month + 1, 0),
      );
      var list = [
        for (var i = 1; i <= DateTime(month.year, month.month + 1, 0).day; i++)
          i
      ];
      for (var day in list) {
        calendarData.addAll({day: []});
      }
      for (var day in calendarData.keys) {
        List<CellEventsTodos> events = [];
        for (var event in response.events) {
          if (isSameDay(
              CommonFunctions.getParsedTime(
                event.date,
                event.startTime!,
              ),
              DateTime(month.year, month.month, day))) {
            events.add(CellEventsTodos(
              name: event.eventName,
              color: getCorrectColor(event.categoryId),
            ));
          }
        }
        for (var todo in response.todos.daily) {
          if (isSameDay(
              todo.todayTime, DateTime(month.year, month.month, day))) {
            events.add(CellEventsTodos(
              name: todo.taskName,
              color: todayColor,
            ));
          }
        }
        calendarData.addAll({day: events});
      }
    } on Object catch (_) {
      showErrorSnackBar(
          message: 'Could not fetch events and todos for this month');
    }
  }

  //if month is 31 days, then return will be 25, if 30 then 24, if 29 then 23, if 28 then 22
  int getTheStartLastSevenCalendarDays(DateTime month) {
    final time = DateTime(month.year, month.month + 1, 0).day;
    if (time == 31) {
      return 25;
    } else if (time == 30) {
      return 24;
    } else if (time == 28) {
      return 22;
    } else {
      return 23;
    }
  }

  Color? getCorrectColor(int categoryId) {
    switch (categoryId) {
      case 1:
        return workColor;
      case 2:
        return financeColor;
      case 3:
        return travelColor;
      case 4:
        return selfCareColor;
      case 6:
        return meetUpColor;
      default:
        return null;
    }
  }

  int getTheListLength(int? length) {
    if (length == null) {
      return 0;
    }
    if (length > 5) {
      return 5;
    } else {
      return length;
    }
  }
}

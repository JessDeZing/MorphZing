import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/dashboard/advice.dart';
import 'package:morphzing/data/models/dashboard/advice_list.dart';
import 'package:morphzing/data/repositories/dashboard/dashboard_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/model/event_with_participants.dart';
import 'package:morphzing/utils/show_error.dart';

class SelfCareController extends GetxController {
  final _agendaController = Get.find<AgendaController>();
  final _dash = getIt<DashboardRepository>();
  RxList<EventWithParticipants> selfCareEventsList = RxList([]);
  Rx<AdviceList> adviceList = Rx(AdviceList([]));
  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  RxBool pageLoading = true.obs;
  DateTime startDay = DateTime.now().add(-180.days);
  DateTime endDay = DateTime.now().add((365 * 3).days);
  PageController pageController = PageController();

  @override
  void onInit() async {
    super.onInit();
    await getSelfCareEvents(
      startTime: focusedDay.value,
      endTime: focusedDay.value,
    );
    await getAdvices(selectedDay.value);
    pageLoading.value = false;
  }

  Future<void> changeFocusedDay(DateTime newFocusedDay) async {
    selectedDay.value = newFocusedDay;
    focusedDay.value = newFocusedDay;
    await getSelfCareEvents(
      startTime: selectedDay.value,
      endTime: selectedDay.value,
    );
    await getAdvices(selectedDay.value);
  }

  Future<void> getSelfCareEvents({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    List<EventWithParticipants> result = [];
    final events = await _agendaController.getAgendaEvents(
      startTime: startTime,
      endTime: endTime,
      categoryId: _agendaController.listOfAgendaNames[3].id,
    );
    for (Event event in events) {
      final participants =
          await _agendaController.getEventParticipants(eventId: event.id!);
      result
          .add(EventWithParticipants(event: event, participants: participants));
    }
    selfCareEventsList.value = result;
  }

  Future<void> getAdvices(DateTime day) async {
    try {
      final response = await _dash.getSelfCareSuggestions(
        startTime: DateFormat("yyyy-MM-dd").format(day),
        endTime: DateFormat("yyyy-MM-dd").format(day),
      );
      adviceList.value = response;
    } on Object catch (_) {}
  }
}

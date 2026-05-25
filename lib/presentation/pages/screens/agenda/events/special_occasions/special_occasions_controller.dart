import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/model/event_with_participants.dart';

class SpecialOccasionsController extends GetxController {
  final _agendaController = Get.find<AgendaController>();
  RxList<EventWithParticipants> specialOccasionEventsList = RxList();
  Rx<DateTime> selectedDay = DateTime
      .now()
      .obs;
  Rx<DateTime> focusedDay = DateTime
      .now()
      .obs;
  RxBool pageLoading = true.obs;
  DateTime startDay = DateTime.now().add(-180.days);
  DateTime endDay = DateTime.now().add((365 * 3).days);
  PageController pageController = PageController();

  @override
  void onInit() async {
    super.onInit();
    await getSpecialOccasionEvents(
      startTime: focusedDay.value,
      endTime: focusedDay.value,
    );
    pageLoading.value = false;
  }

  Future<void> changeFocusedDay(DateTime newFocusedDay) async {
    selectedDay.value = newFocusedDay;
    focusedDay.value = newFocusedDay;
    await getSpecialOccasionEvents(
      startTime: selectedDay.value,
      endTime: selectedDay.value,
    );
  }

  Future<void> getSpecialOccasionEvents({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    List<EventWithParticipants> result = [];
    final events = await _agendaController.getAgendaEvents(
      startTime: startTime,
      endTime: endTime,
      categoryId: _agendaController.listOfAgendaNames[4].id,
    );
    for (Event event in events) {
      final participants =
      await _agendaController.getEventParticipants(eventId: event.id!);
      result
          .add(EventWithParticipants(event: event, participants: participants));
    }
    specialOccasionEventsList.value = result;
  }
}
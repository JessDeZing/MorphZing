import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/model/event_with_participants.dart';

class WorkController extends GetxController {
  final _agendaController = Get.find<AgendaController>();
  RxList<EventWithParticipants> workEventList = RxList([]);
  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  RxBool pageLoading = true.obs;
  DateTime startDay = DateTime.now().add(-180.days);
  DateTime endDay = DateTime.now().add((365 * 3).days);
  PageController pageController = PageController();

  @override
  void onInit() async {
    super.onInit();
    await getWorkEvents(
      startTime: focusedDay.value,
      endTime: focusedDay.value,
    );
    pageLoading.value = false;
  }

  Future<void> changeFocusedDay(DateTime newFocusedDay) async {
    selectedDay.value = newFocusedDay;
    focusedDay.value = newFocusedDay;
    await getWorkEvents(
      startTime: selectedDay.value,
      endTime: selectedDay.value,
    );
  }

  Future<void> getWorkEvents({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    List<EventWithParticipants> result = [];
    final events = await _agendaController.getAgendaEvents(
      startTime: startTime,
      endTime: endTime,
      categoryId: _agendaController.listOfAgendaNames.first.id,
    );
/*    final event = Event(
      id: 3,
      eventName: "First testing event",
      startTime: DateTime.parse("2023-01-23T07:00:00Z"),
      endTime: DateTime.parse("2023-01-23T07:10:00Z"),
      reminder: null,
      place: "43 abuklea rd",
      notes: "First description for first event",
      recurrences:
          "RRULE:FREQ=WEEKLY;INTERVAL=3;UNTIL=20230118T000000Z;BYDAY=TU,WE",
      categoryId: 1,
    );
    final participants =
        await _agendaController.getEventParticipants(eventId: event.id!);
    result.add(EventWithParticipants(
      event: event,
      participants: participants,
    ));*/
    for (Event event in events) {
      final participants =
          await _agendaController.getEventParticipants(eventId: event.id!);
      result
          .add(EventWithParticipants(event: event, participants: participants));
    }
    if (result.isEmpty) {
      workEventList.value = [];
    } else {
      workEventList.value = result;
    }
  }
}

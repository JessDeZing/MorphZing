import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/agenda/travel/agenda_photos.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/repositories/agenda/agenda_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/model/event_with_participants.dart';
import 'package:morphzing/utils/show_error.dart';

class TravelController extends GetxController {
  final _agendaController = Get.find<AgendaController>();
  RxList<EventWithParticipants> travelEventsList = RxList();
  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;
  RxBool pageLoading = true.obs;
  DateTime startDay = DateTime.now().add(-180.days);
  DateTime endDay = DateTime.now().add((365 * 3).days);
  PageController pageController = PageController();
  Map<int, List<String>> eventImages = {};

  @override
  void onInit() async {
    super.onInit();
    await getTravelEvents(
      startTime: focusedDay.value,
      endTime: focusedDay.value,
    );
    pageLoading.value = false;
  }

  Future<void> changeFocusedDay(DateTime newFocusedDay) async {
    selectedDay.value = newFocusedDay;
    focusedDay.value = newFocusedDay;
    await getTravelEvents(
      startTime: selectedDay.value,
      endTime: selectedDay.value,
    );
  }

  Future<void> getTravelEvents({
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    List<EventWithParticipants> result = [];
    final events = await _agendaController.getAgendaEvents(
      startTime: startTime,
      endTime: endTime,
      categoryId: _agendaController.listOfAgendaNames[2].id,
    );
    for (Event event in events) {
      final participants =
          await _agendaController.getEventParticipants(eventId: event.id!);
      result
          .add(EventWithParticipants(event: event, participants: participants));
      final photos = await _agendaController.getPhotos(event.id!);
      final List<String> eventPhotos = [];
      if (photos.isNotEmpty) {
        for (var element in photos) {
          if (element.images.isNotEmpty) {
            for (var img in element.images) {
              eventPhotos.add(img.image);
            }
          }
        }
      }
      eventImages.addAll({event.id!: eventPhotos});
    }
/*    final event = Event(
      eventName: 'Test travel',
      categoryId: 3,
      startTime: DateTime(2023, 1, 15, 19, 30),
      endTime: DateTime(2023, 1, 15, 21, 30),
      user: 2,
      reminder: 30,
      recurrences: '',
      id: 3,
      isEventDone: false,
      notes: 'Check if long text will fit and soft wrap the text',
    );
    result.add(EventWithParticipants(event: event, participants: []));*/
    travelEventsList.value = result;
  }
}

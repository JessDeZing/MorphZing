import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:morphzing/data/models/agenda/agenda_calendar.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/event_edit_request.dart';
import 'package:morphzing/data/models/agenda/participant.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/data/models/agenda/todos.dart';
import 'package:morphzing/data/models/agenda/travel/agenda_photos.dart';
import 'package:morphzing/data/models/dashboard/single_agenda_name.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:morphzing/data/repositories/agenda/agenda_repository.dart';
import 'package:morphzing/data/repositories/dashboard/dashboard_repository.dart';
import 'package:morphzing/data/repositories/user/user_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/dynamic_deeplink_service.dart';
import 'package:morphzing/utils/show_error.dart';

class AgendaController extends GetxController {
  final _agendaRepository = getIt<AgendaRepository>();
  final _dashboardRepository = getIt<DashboardRepository>();
  final _userRepository = getIt<UserRepository>();
  List<SingleAgendaName> listOfAgendaNames = [];
  User? user;
  RxBool pageLoading = true.obs;
  Rx<AgendaCalendar> agendaCalendar = Rx(AgendaCalendar(
      todos: Todos(
        daily: [],
        monthly: [],
        yearly: [],
        weekly: [],
      ),
      events: []));
  RxList<Todo> allTodos = RxList();

  @override
  void onInit() async {
    super.onInit();
    await getAgendaNames();
    await getAgendaCalendar();
    pageLoading.value = false;
    user = await getUserInfo();
  }

  Future<User?> getUserInfo() async {
    try {
      final response = await _userRepository.getUserInfo();
      return response;
    } on dio.DioError catch (e) {
      log('fetch user info: ${e.response}');
    }
    return null;
  }

  Future<void> getAgendaNames() async {
    try {
      final response = await _dashboardRepository.getDashboardAgendaNames();
      response.results.sort((a, b) => a.id.compareTo(b.id));
      listOfAgendaNames = response.results;
    } on dio.DioError catch (_) {
      return;
    }
  }

  Future<void> getAgendaCalendar() async {
    try {
      agendaCalendar.value = await _agendaRepository.getAgendaCalendar(
        DateTime.now(),
        DateTime.now(),
      );
      allTodos.clear();
      for (var element in agendaCalendar.value.todos.daily) {
        allTodos.add(element);
      }
    } on dio.DioError catch (_) {}
  }

  /// events

  Future<List<Event>> getAgendaEvents({
    required DateTime startTime,
    required DateTime endTime,
    required int categoryId,
  }) async {
    try {
      final response = await _agendaRepository.getAgendaCalendar(
        startTime,
        endTime,
      );
      List<Event> sortedEvents = [];
      for (var element in response.events) {
        if (element.categoryId == categoryId) {
          sortedEvents.add(element);
        }
      }
      return sortedEvents;
    } on Object catch (_) {
      return [];
    }
  }

  Future<List<Participant>> getEventParticipants({required int eventId}) async {
    try {
      return await _agendaRepository.getEventParticipants(eventId);
    } on Object catch (_) {
      return [];
    }
  }

  Future<Event?> createEvent(Event event) async {
    try {
      final uuid = DateTime.now().microsecondsSinceEpoch;
      final link = await DynamicDeepLinkService.createDynamicLink(uuid);
      final response = await _agendaRepository.createAgendaEvent(
        event.copyWith(
          url: link,
          uuid: uuid.toString(),
        ),
      );
      showGetSnackBar(message: eventCreated.tr);
      return response;
    } on dio.DioError catch (_) {
      showErrorSnackBar(message: eventCreateFailed.tr);
    }
    return null;
  }

  Future<Event?> editEvent(Event event, int eventId) async {
    try {
      final response = await _agendaRepository.editEvent(event, eventId);
      showGetSnackBar(message: eventEdited.tr);
      return response;
    } on dio.DioError catch (e) {
      showErrorSnackBar(message: eventEditFailed.tr);
    }
    return null;
  }

  Future<Event?> getEvent(int eventId) async {
    try {
      final response = await _agendaRepository.getEvent(eventId);
      return response;
    } on dio.DioError catch (e) {}
    return null;
  }

  Future<Event?> getEventByUUID(int uuid) async {
    try {
      final response = await _agendaRepository.getEventByUUID(uuid);
      return response;
    } on dio.DioError catch (e) {}
    return null;
  }

  Future<EventEdit?> editEventStatus({
    required int eventId,
    required String date,
    required bool status,
  }) async {
    try {
      final response = await _agendaRepository.editEventStatus(
        eventId: eventId,
        date: date,
        status: status,
      );
      showGetSnackBar(message: eventStatusChanged.tr);
      return response;
    } on dio.DioError catch (e) {
      showErrorSnackBar(message: eventStatusFailed.tr);
    }
    return null;
  }

  Future<void> addParticipantsToEvent(List<Participant> participants) async {
    if (participants.isEmpty) {
      return;
    }
    try {
      await _agendaRepository.addParticipantsToEvent(participants);
    } on dio.DioError catch (e) {
      showErrorSnackBar(message: participantAddFailed.tr);
    }
  }

  Future<void> editParticipantsOfEvent(List<Participant> participants,
      {int? eventId}) async {
    if (participants.isEmpty) {
      await _agendaRepository
          .editParticipantsOfEvent([Participant(eventId: eventId!)]);
      return;
    }
    try {
      await _agendaRepository.editParticipantsOfEvent(participants);
    } on dio.DioError catch (_) {
      showErrorSnackBar(message: participantChangeFailed.tr);
    }
  }

  Future<void> deleteEvent(int eventId) async {
    try {
      await _agendaRepository.deleteEvent(eventId);
      showGetSnackBar(message: eventDeleted.tr);
    } on dio.DioError catch (e) {
      showErrorSnackBar(message: eventDeleteFailed.tr);
    }
  }

  //travel only
  Future<void> uploadTravelPhotos(
    List<File> images,
    int eventId,
    int userId,
  ) async {
    if (images.isEmpty) {
      return;
    }
    try {
      /*final timeToRunTheLoop = images.length / 5;
      int timesAlreadyRun = 0;
      while(timesAlreadyRun <= timeToRunTheLoop) {
      }*/
      await _agendaRepository.uploadTravelPhotos(images, userId, eventId);
    } on Object catch (_) {
      showErrorSnackBar(message: imageUploadFailed.tr);
    }
  }

  Future<List<AgendaPhotos>> getPhotos(int eventId) async {
    try {
      return await _agendaRepository.getTravelPhotos(eventId);
    } on dio.DioError catch (e) {
      print('error ${e.response} - ${e.error}');
      showErrorSnackBar(message: travelPicturesFailed.tr);
    }
    return [];
  }

  //// events

  Future<void> changeTodoStatus(RxList<Todo> listOfTodos, Todo todo) async {
    try {
      await _agendaRepository
          .updateAgendaTodo(todo.copyWith(status: TodoStatus.done));
      int index = listOfTodos.indexOf(todo);
      listOfTodos[index] = listOfTodos[index].copyWith(status: TodoStatus.done);
    } on dio.DioError catch (e) {
      showErrorSnackBar(message: taskStatusFailed.tr);
    }
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/api/agenda_api.dart';
import 'package:morphzing/data/models/agenda/agenda_calendar.dart';
import 'package:morphzing/data/models/agenda/event_edit_request.dart';
import 'package:morphzing/data/models/agenda/invitation_change_status.dart';
import 'package:morphzing/data/models/agenda/travel/agenda_photos.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/participant.dart';
import 'package:morphzing/data/models/agenda/todo.dart';

@singleton
class AgendaRepository {
  final AgendaApi _agendaApi;

  AgendaRepository(this._agendaApi);

  Future<AgendaCalendar> getAgendaCalendar(
      DateTime startDate, DateTime endDate) async {
    try {
      return await _agendaApi.getAgendaCalendar(
        DateFormat("yyyy-MM-dd").format(startDate),
        DateFormat("yyyy-MM-dd").format(endDate),
      );
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<List<Event>> getPendingInvitations() async {
    try {
      return await _agendaApi.getPendingInvitations();
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<void> acceptOrDeclineInvitation(
      {required InvitationChangeStatus invitationChangeStatus}) async {
    try {
      return await _agendaApi.acceptOrDeclineInvitation(invitationChangeStatus);
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<AgendaCalendar> getAgendaCalendarPerMonth(
      DateTime startDate, DateTime endDate) async {
    try {
      return await _agendaApi.getAgendaCalendarPerMonth(
        DateFormat("yyyy-MM-dd").format(startDate),
        DateFormat("yyyy-MM-dd").format(endDate),
      );
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<Event> createAgendaEvent(Event event) async {
    try {
      return await _agendaApi.createAgendaEvent(event: event);
    } on DioError catch (e) {
      //handle error
      rethrow;
    }
  }

  Future<EventEdit> editEventStatus({
    required int eventId,
    required String date,
    required bool status,
  }) async {
    try {
      return await _agendaApi.editEventStatus(
          editRequest: EventEdit(
        event: eventId,
        date: date,
        status: status,
      ));
    } on DioError catch (_) {
      //handle error
      rethrow;
    }
  }

  Future<Event> editEvent(Event event, int eventId) async {
    try {
      return await _agendaApi.editEvent(event: event, eventId: eventId);
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<Event> getEvent(int eventId) async {
    try {
      return await _agendaApi.getSingleEvent(eventId: eventId);
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<Event> getEventByUUID(int uuid) async {
    try {
      return await _agendaApi.getEventByUUID(uuid: uuid);
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<void> addParticipantsToEvent(List<Participant> participants) async {
    try {
      return await _agendaApi.addParticipantsToEvent(participants);
    } on DioError catch (_) {
      //handle error
      rethrow;
    }
  }

  Future<void> editParticipantsOfEvent(List<Participant> participants) async {
    try {
      return await _agendaApi.editParticipantsOfEvent(participants);
    } on DioError catch (_) {
      //handle error
      rethrow;
    }
  }

  Future<List<Participant>> getEventParticipants(int eventId) async {
    try {
      final response =
          await _agendaApi.getParticipantsOfEvent(eventId: eventId);
      return response.results;
    } on DioError catch (_) {
      //handle error
      rethrow;
    }
  }

  Future<List<AgendaPhotos>> getTravelPhotos(int eventId) async {
    try {
      return await _agendaApi.getTravelPhotos(eventId);
    } on DioError catch (e) {
      //handle error
      rethrow;
    }
  }

  Future<void> uploadTravelPhotos(List<File> files, int user, int event) async {
    try {
      return await _agendaApi.uploadTravelPhotos(files, user, event);
    } on DioError catch (e) {
      //handle error
      rethrow;
    }
  }

  Future<void> createAgendaTodo(Todo todo) async {
    try {
      return await _agendaApi.createAgendaTodo(todo: todo);
    } on DioError catch (e) {
      //handle error
      rethrow;
    }
  }

  Future<void> updateAgendaTodo(Todo todo) async {
    try {
      return await _agendaApi.updateTodoPartially(
        todo: todo,
        id: todo.id ?? -1,
      );
    } on DioError catch (e) {
      //handle error
      rethrow;
    }
  }

  Future<void> deleteTask(Todo todo) async {
    try {
      return await _agendaApi.deleteTodo(id: todo.id ?? -1);
    } on DioError catch (e) {
      //handle error
      rethrow;
    }
  }

  Future<void> deleteEvent(int eventId) async {
    try {
      return await _agendaApi.deleteEvent(id: eventId);
    } on DioError catch (e) {
      //handle error
      rethrow;
    }
  }
}

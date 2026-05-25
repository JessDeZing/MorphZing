import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:morphzing/data/models/agenda/agenda_calendar.dart';
import 'package:morphzing/data/models/agenda/event_edit_request.dart';
import 'package:morphzing/data/models/agenda/invitation_change_status.dart';
import 'package:morphzing/data/models/agenda/travel/agenda_photos.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/participants.dart';
import 'package:morphzing/data/models/agenda/participant.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:retrofit/http.dart';

part 'agenda_api.g.dart';

@singleton
@RestApi()
abstract class AgendaApi {
  @factoryMethod
  factory AgendaApi(Dio dio) = _AgendaApi;

  @POST("/agenda/event/")
  Future<Event> createAgendaEvent({@Body() required Event event});

  @POST("/agenda/event-status")
  Future<EventEdit> editEventStatus({@Body() required EventEdit editRequest});

  @PATCH("/agenda/event/{id}/")
  Future<Event> editEvent({
    @Body() required Event event,
    @Path('id') required int eventId,
  });

  @GET("/agenda/event/{id}/")
  Future<Event> getSingleEvent({
    @Path('id') required int eventId,
  });

  @GET("/agenda/event/uuid/")
  Future<Event> getEventByUUID({
    @Query('uuid') required int uuid,
  });

  @GET("/agenda/event/participant")
  Future<Participants> getParticipantsOfEvent(
      {@Query('event_id') required int eventId});

  @POST("/agenda/event/participant")
  Future<void> addParticipantsToEvent(@Body() List<Participant> participants);

  @POST("/agenda/event/participant-update")
  Future<void> editParticipantsOfEvent(@Body() List<Participant> participants);

  @DELETE("/agenda/event/{id}/")
  Future<void> deleteEvent({@Path("id") required int id});

  @POST("/agenda/todo/")
  Future<void> createAgendaTodo({@Body() required Todo todo});

  @PUT("/agenda/todo/{id}/")
  Future<void> updateTodo({
    @Body() required Todo todo,
    @Path("id") required int id,
  });

  @PATCH("/agenda/todo/{id}/")
  Future<void> updateTodoPartially({
    @Body() required Todo todo,
    @Path("id") required int id,
  });

  @DELETE("/agenda/todo/{id}/")
  Future<void> deleteTodo({@Path("id") required int id});

  @GET("/agenda/calendar")
  Future<AgendaCalendar> getAgendaCalendar(
    @Query("start_date") String startDate,
    @Query("end_date") String endDate,
  );

  @GET("/agenda/calendar-monthly")
  Future<AgendaCalendar> getAgendaCalendarPerMonth(
    @Query("start_date") String startDate,
    @Query("end_date") String endDate,
  );

  @GET("/agenda/photos/")
  Future<List<AgendaPhotos>> getTravelPhotos(@Query("event_id") int eventId);

  @POST("/agenda/photos/")
  @MultiPart()
  Future<void> uploadTravelPhotos(
    @Part() List<File> photos,
    @Part() int user,
    @Part() int event,
  );

  @GET("/agenda/event/pending-invitation")
  Future<List<Event>> getPendingInvitations();

  @POST("/agenda/event/pending-invitation")
  Future<void> acceptOrDeclineInvitation(
      @Body() InvitationChangeStatus invitationChangeStatus);
}

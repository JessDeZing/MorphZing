// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_calendar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgendaCalendar _$AgendaCalendarFromJson(Map<String, dynamic> json) =>
    AgendaCalendar(
      todos: Todos.fromJson(json['todos'] as Map<String, dynamic>),
      events: (json['events'] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgendaCalendarToJson(AgendaCalendar instance) =>
    <String, dynamic>{
      'todos': instance.todos,
      'events': instance.events,
    };

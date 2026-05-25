import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/todos.dart';

part 'agenda_calendar.g.dart';
@JsonSerializable()
class AgendaCalendar {
  final Todos todos;
  final List<Event> events;

  AgendaCalendar({
    required this.todos,
    required this.events,
  });

  factory AgendaCalendar.fromJson(Map<String, dynamic> json) =>
      _$AgendaCalendarFromJson(json);

  Map<String, dynamic> toJson() => _$AgendaCalendarToJson(this);
}

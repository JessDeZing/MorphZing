import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/agenda/event.dart';

part 'agenda_event.g.dart';

@JsonSerializable()
class AgendaEvent {
  final int count;
  final String? next;
  final String? previous;

  @JsonKey(defaultValue: [])
  final List<Event> results;

  AgendaEvent({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });

  factory AgendaEvent.fromJson(Map<String, dynamic> json) =>
      _$AgendaEventFromJson(json);

  Map<String, dynamic> toJson() => _$AgendaEventToJson(this);

  @override
  String toString() {
    return 'AgendaEvent{count: $count, next: $next, previous: $previous, results: $results}';
  }
}

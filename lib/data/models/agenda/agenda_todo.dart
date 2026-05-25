import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/agenda/todo.dart';

part 'agenda_todo.g.dart';

@JsonSerializable()
class AgendaTodo {
  final int count;
  final String? next;
  final String? previous;

  @JsonKey(defaultValue: [])
  final List<Todo> results;

  AgendaTodo({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });

  factory AgendaTodo.fromJson(Map<String, dynamic> json) =>
      _$AgendaTodoFromJson(json);

  Map<String, dynamic> toJson() => _$AgendaTodoToJson(this);

  @override
  String toString() {
    return 'AgendaTodo{count: $count, next: $next, previous: $previous, results: $results}';
  }
}

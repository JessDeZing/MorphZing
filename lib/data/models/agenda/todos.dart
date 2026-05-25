import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/agenda/todo.dart';

part 'todos.g.dart';

@CopyWith()
@JsonSerializable()
class Todos {
  @JsonKey(name: 'today')
  final List<Todo> daily;
  final List<Todo> weekly;
  final List<Todo> monthly;
  final List<Todo> yearly;

  Todos({
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.yearly,
  });

  factory Todos.fromJson(Map<String, dynamic> json) => _$TodosFromJson(json);

  Map<String, dynamic> toJson() => _$TodosToJson(this);
}

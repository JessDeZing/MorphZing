import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/utils/enum_map.dart';
import 'package:morphzing/utils/style/colors.dart';

part 'todo.g.dart';

@CopyWith()
@JsonSerializable(includeIfNull: false)
class Todo {
  Todo({
    required this.taskName,
    required this.status,
    required this.isGoal,
    required this.todoType,
    required this.notes,
    this.todayReminder,
    this.isMonthlyReminderOn = false,
    this.isYearlyReminderOn = false,
    this.id,
    this.todayTime,
    this.monthTime,
    this.yearTime,
  });

  final int? id;

  @JsonKey(name: "task_name")
  final String taskName;

  @JsonKey(fromJson: _fromJsonToStatus, toJson: _fromStatusToJson)
  final TodoStatus? status;

  @JsonKey(name: "is_goal", defaultValue: false)
  final bool isGoal;

  @JsonKey(name: "todo_type", fromJson: _fromJsonToType, toJson: _fromTypeToJson)
  final TodoType? todoType;

  @JsonKey(fromJson: _dateFromJson, toJson: _todayDateToJson, name: "today_time")
  final DateTime? todayTime;

  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson, name: "month_time")
  final DateTime? monthTime;

  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson, name: "year_time")
  final DateTime? yearTime;

  final String notes;

  @JsonKey(name: 'is_monthly')
  final bool isMonthlyReminderOn;

  @JsonKey(name: 'is_yearly')
  final bool isYearlyReminderOn;

  @JsonKey(name: 'reminder')
  final int? todayReminder;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Color? getBgColor() {
    if (todoType == TodoType.daily) {
      return todayColor;
    } else if (todoType == TodoType.monthly && monthTime != null) {
      return thisMonthColor;
    } else if (todoType == TodoType.yearly && yearTime != null) {
      return thisYearColor;
    }
    return null;
  }

  @override
  String toString() {
    return 'Todo{id: $id, taskName: $taskName, status: $status, isGoal: $isGoal, todoType: $todoType, todayTime: $todayTime, monthTime: $monthTime, yearTime: $yearTime, notes: $notes}';
  }
}

DateTime? _dateFromJson(dynamic json) {
  return (json as String?) == null ? null : DateTime.parse(json as String);
}

String? _dateToJson(DateTime? value) {
  return value == null ? null : DateFormat("yyyy-MM-dd").format(value);
}

String? _todayDateToJson(DateTime? value) {
  return value?.toIso8601String();
}

enum TodoStatus {
  todo,
  done,
}

final _todoValues = EnumValues({
  'todo': TodoStatus.todo,
  'done': TodoStatus.done,
});

TodoStatus? _fromJsonToStatus(String? key) => _todoValues.map[key];

String? _fromStatusToJson(TodoStatus? todoStatus) => _todoValues.reverse[todoStatus];

enum TodoType {
  daily,
  monthly,
  yearly,
}

final _todoType = EnumValues({
  'daily': TodoType.daily,
  'monthly': TodoType.monthly,
  'yearly': TodoType.yearly,
});

TodoType? _fromJsonToType(String? key) => _todoType.map[key];

String? _fromTypeToJson(TodoType? todoType) => _todoType.reverse[todoType];

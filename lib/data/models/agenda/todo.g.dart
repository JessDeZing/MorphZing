// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TodoCWProxy {
  Todo id(int? id);

  Todo isGoal(bool isGoal);

  Todo isMonthlyReminderOn(bool isMonthlyReminderOn);

  Todo isYearlyReminderOn(bool isYearlyReminderOn);

  Todo monthTime(DateTime? monthTime);

  Todo notes(String notes);

  Todo status(TodoStatus? status);

  Todo taskName(String taskName);

  Todo todayReminder(int? todayReminder);

  Todo todayTime(DateTime? todayTime);

  Todo todoType(TodoType? todoType);

  Todo yearTime(DateTime? yearTime);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Todo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Todo(...).copyWith(id: 12, name: "My name")
  /// ````
  Todo call({
    int? id,
    bool? isGoal,
    bool? isMonthlyReminderOn,
    bool? isYearlyReminderOn,
    DateTime? monthTime,
    String? notes,
    TodoStatus? status,
    String? taskName,
    int? todayReminder,
    DateTime? todayTime,
    TodoType? todoType,
    DateTime? yearTime,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTodo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTodo.copyWith.fieldName(...)`
class _$TodoCWProxyImpl implements _$TodoCWProxy {
  final Todo _value;

  const _$TodoCWProxyImpl(this._value);

  @override
  Todo id(int? id) => this(id: id);

  @override
  Todo isGoal(bool isGoal) => this(isGoal: isGoal);

  @override
  Todo isMonthlyReminderOn(bool isMonthlyReminderOn) =>
      this(isMonthlyReminderOn: isMonthlyReminderOn);

  @override
  Todo isYearlyReminderOn(bool isYearlyReminderOn) =>
      this(isYearlyReminderOn: isYearlyReminderOn);

  @override
  Todo monthTime(DateTime? monthTime) => this(monthTime: monthTime);

  @override
  Todo notes(String notes) => this(notes: notes);

  @override
  Todo status(TodoStatus? status) => this(status: status);

  @override
  Todo taskName(String taskName) => this(taskName: taskName);

  @override
  Todo todayReminder(int? todayReminder) => this(todayReminder: todayReminder);

  @override
  Todo todayTime(DateTime? todayTime) => this(todayTime: todayTime);

  @override
  Todo todoType(TodoType? todoType) => this(todoType: todoType);

  @override
  Todo yearTime(DateTime? yearTime) => this(yearTime: yearTime);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Todo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Todo(...).copyWith(id: 12, name: "My name")
  /// ````
  Todo call({
    Object? id = const $CopyWithPlaceholder(),
    Object? isGoal = const $CopyWithPlaceholder(),
    Object? isMonthlyReminderOn = const $CopyWithPlaceholder(),
    Object? isYearlyReminderOn = const $CopyWithPlaceholder(),
    Object? monthTime = const $CopyWithPlaceholder(),
    Object? notes = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? taskName = const $CopyWithPlaceholder(),
    Object? todayReminder = const $CopyWithPlaceholder(),
    Object? todayTime = const $CopyWithPlaceholder(),
    Object? todoType = const $CopyWithPlaceholder(),
    Object? yearTime = const $CopyWithPlaceholder(),
  }) {
    return Todo(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int?,
      isGoal: isGoal == const $CopyWithPlaceholder() || isGoal == null
          ? _value.isGoal
          // ignore: cast_nullable_to_non_nullable
          : isGoal as bool,
      isMonthlyReminderOn:
          isMonthlyReminderOn == const $CopyWithPlaceholder() ||
                  isMonthlyReminderOn == null
              ? _value.isMonthlyReminderOn
              // ignore: cast_nullable_to_non_nullable
              : isMonthlyReminderOn as bool,
      isYearlyReminderOn: isYearlyReminderOn == const $CopyWithPlaceholder() ||
              isYearlyReminderOn == null
          ? _value.isYearlyReminderOn
          // ignore: cast_nullable_to_non_nullable
          : isYearlyReminderOn as bool,
      monthTime: monthTime == const $CopyWithPlaceholder()
          ? _value.monthTime
          // ignore: cast_nullable_to_non_nullable
          : monthTime as DateTime?,
      notes: notes == const $CopyWithPlaceholder() || notes == null
          ? _value.notes
          // ignore: cast_nullable_to_non_nullable
          : notes as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as TodoStatus?,
      taskName: taskName == const $CopyWithPlaceholder() || taskName == null
          ? _value.taskName
          // ignore: cast_nullable_to_non_nullable
          : taskName as String,
      todayReminder: todayReminder == const $CopyWithPlaceholder()
          ? _value.todayReminder
          // ignore: cast_nullable_to_non_nullable
          : todayReminder as int?,
      todayTime: todayTime == const $CopyWithPlaceholder()
          ? _value.todayTime
          // ignore: cast_nullable_to_non_nullable
          : todayTime as DateTime?,
      todoType: todoType == const $CopyWithPlaceholder()
          ? _value.todoType
          // ignore: cast_nullable_to_non_nullable
          : todoType as TodoType?,
      yearTime: yearTime == const $CopyWithPlaceholder()
          ? _value.yearTime
          // ignore: cast_nullable_to_non_nullable
          : yearTime as DateTime?,
    );
  }
}

extension $TodoCopyWith on Todo {
  /// Returns a callable class that can be used as follows: `instanceOfTodo.copyWith(...)` or like so:`instanceOfTodo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TodoCWProxy get copyWith => _$TodoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
      taskName: json['task_name'] as String,
      status: _fromJsonToStatus(json['status'] as String?),
      isGoal: json['is_goal'] as bool? ?? false,
      todoType: _fromJsonToType(json['todo_type'] as String?),
      notes: json['notes'] as String,
      todayReminder: json['reminder'] as int?,
      isMonthlyReminderOn: json['is_monthly'] as bool? ?? false,
      isYearlyReminderOn: json['is_yearly'] as bool? ?? false,
      id: json['id'] as int?,
      todayTime: _dateFromJson(json['today_time']),
      monthTime: _dateFromJson(json['month_time']),
      yearTime: _dateFromJson(json['year_time']),
    );

Map<String, dynamic> _$TodoToJson(Todo instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['task_name'] = instance.taskName;
  writeNotNull('status', _fromStatusToJson(instance.status));
  val['is_goal'] = instance.isGoal;
  writeNotNull('todo_type', _fromTypeToJson(instance.todoType));
  writeNotNull('today_time', _todayDateToJson(instance.todayTime));
  writeNotNull('month_time', _dateToJson(instance.monthTime));
  writeNotNull('year_time', _dateToJson(instance.yearTime));
  val['notes'] = instance.notes;
  val['is_monthly'] = instance.isMonthlyReminderOn;
  val['is_yearly'] = instance.isYearlyReminderOn;
  writeNotNull('reminder', instance.todayReminder);
  return val;
}

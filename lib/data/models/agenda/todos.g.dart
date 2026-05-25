// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TodosCWProxy {
  Todos daily(List<Todo> daily);
  Todos weekly(List<Todo> weekly);

  Todos monthly(List<Todo> monthly);

  Todos yearly(List<Todo> yearly);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Todos(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Todos(...).copyWith(id: 12, name: "My name")
  /// ````
  Todos call({
    List<Todo>? daily,
    List<Todo>? monthly,
    List<Todo>? yearly,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTodos.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTodos.copyWith.fieldName(...)`
class _$TodosCWProxyImpl implements _$TodosCWProxy {
  final Todos _value;

  const _$TodosCWProxyImpl(this._value);

  @override
  Todos daily(List<Todo> daily) => this(daily: daily);
  @override
  Todos weekly(List<Todo> weekly) => this(weekly: weekly);


  @override
  Todos monthly(List<Todo> monthly) => this(monthly: monthly);

  @override
  Todos yearly(List<Todo> yearly) => this(yearly: yearly);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Todos(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Todos(...).copyWith(id: 12, name: "My name")
  /// ````
  Todos call({
    Object? daily = const $CopyWithPlaceholder(),
    Object? monthly = const $CopyWithPlaceholder(),
    Object? yearly = const $CopyWithPlaceholder(),
    Object? weekly= const $CopyWithPlaceholder(),

  }) {
    return Todos(
      daily: daily == const $CopyWithPlaceholder() || daily == null
          ? _value.daily
          // ignore: cast_nullable_to_non_nullable
          : daily as List<Todo>,
      monthly: monthly == const $CopyWithPlaceholder() || monthly == null
          ? _value.monthly
          // ignore: cast_nullable_to_non_nullable
          : monthly as List<Todo>,
      yearly: yearly == const $CopyWithPlaceholder() || yearly == null
          ? _value.yearly
          // ignore: cast_nullable_to_non_nullable
          : weekly as List<Todo>, weekly: [],
    );
  }
}

extension $TodosCopyWith on Todos {
  /// Returns a callable class that can be used as follows: `instanceOfTodos.copyWith(...)` or like so:`instanceOfTodos.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TodosCWProxy get copyWith => _$TodosCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todos _$TodosFromJson(Map<String, dynamic> json) => Todos(
      // daily: (json['today'] as List<dynamic>)
      //     .map((e) => Todo.fromJson(e as Map<String, dynamic>))
      //     .toList(),
      // weekly: (json['weekly'] as List<dynamic>)
      // .map((e) => Todo.fromJson(e as Map<String, dynamic>))
      // .toList(),
      daily: (json['today'] as List<dynamic>?)
          ?.map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      weekly: (json['weekly'] as List<dynamic>?)
          ?.map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      monthly: (json['monthly'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList(),
      yearly: (json['yearly'] as List<dynamic>)
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TodosToJson(Todos instance) => <String, dynamic>{
      'today': instance.daily,
      'monthly': instance.monthly,
      'yearly': instance.yearly,
      'weekly': instance.weekly
    };

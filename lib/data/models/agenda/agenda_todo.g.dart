// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgendaTodo _$AgendaTodoFromJson(Map<String, dynamic> json) => AgendaTodo(
      count: json['count'] as int,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => Todo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      next: json['next'] as String?,
      previous: json['previous'] as String?,
    );

Map<String, dynamic> _$AgendaTodoToJson(AgendaTodo instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };

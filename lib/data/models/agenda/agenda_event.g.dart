// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgendaEvent _$AgendaEventFromJson(Map<String, dynamic> json) => AgendaEvent(
      count: json['count'] as int,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      next: json['next'] as String?,
      previous: json['previous'] as String?,
    );

Map<String, dynamic> _$AgendaEventToJson(AgendaEvent instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };

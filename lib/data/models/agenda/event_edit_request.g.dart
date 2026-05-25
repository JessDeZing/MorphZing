// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_edit_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventEdit _$EventEditFromJson(Map<String, dynamic> json) => EventEdit(
      event: json['event'] as int,
      date: json['date'] as String,
      status: json['status'] as bool,
    );

Map<String, dynamic> _$EventEditToJson(EventEdit instance) => <String, dynamic>{
      'event': instance.event,
      'date': instance.date,
      'status': instance.status,
    };

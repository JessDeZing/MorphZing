// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_names.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgendaNames _$AgendaNamesFromJson(Map<String, dynamic> json) => AgendaNames(
      results: (json['results'] as List<dynamic>)
          .map((e) => SingleAgendaName.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgendaNamesToJson(AgendaNames instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

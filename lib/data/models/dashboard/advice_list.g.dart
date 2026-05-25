// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advice_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdviceList _$AdviceListFromJson(Map<String, dynamic> json) => AdviceList(
      (json['results'] as List<dynamic>)
          .map((e) => Advice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdviceListToJson(AdviceList instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

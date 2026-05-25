// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiPagination<T> _$ApiPaginationFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiPagination<T>(
      total: json['count'] as int,
      data: (json['results'] as List<dynamic>).map(fromJsonT).toList(),
    );

Map<String, dynamic> _$ApiPaginationToJson<T>(
  ApiPagination<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'count': instance.total,
      'results': instance.data.map(toJsonT).toList(),
    };

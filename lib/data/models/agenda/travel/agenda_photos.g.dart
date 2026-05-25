// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_photos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgendaPhotos _$AgendaPhotosFromJson(Map<String, dynamic> json) => AgendaPhotos(
      (json['images'] as List<dynamic>)
          .map((e) => AgendaPhotoResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AgendaPhotosToJson(AgendaPhotos instance) =>
    <String, dynamic>{
      'images': instance.images,
    };

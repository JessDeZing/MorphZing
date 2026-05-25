import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/agenda/travel/agenda_photo_response.dart';

part 'agenda_photos.g.dart';

@JsonSerializable()
class AgendaPhotos {

  final List<AgendaPhotoResponse> images;

  AgendaPhotos(this.images);

  Map<String, dynamic> toJson() => _$AgendaPhotosToJson(this);

  factory AgendaPhotos.fromJson(Map<String, dynamic> json) =>
      _$AgendaPhotosFromJson(json);
}
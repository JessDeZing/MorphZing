import 'package:json_annotation/json_annotation.dart';

part 'agenda_photo_response.g.dart';

@JsonSerializable()
class AgendaPhotoResponse {

  @JsonKey(name: 'image_url', defaultValue: '')
  final String image;

  const AgendaPhotoResponse({required this.image});

  Map<String, dynamic> toJson() => _$AgendaPhotoResponseToJson(this);

  factory AgendaPhotoResponse.fromJson(Map<String, dynamic> json) =>
      _$AgendaPhotoResponseFromJson(json);
}

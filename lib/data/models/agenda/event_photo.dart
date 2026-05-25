import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/utils/style/colors.dart';

part 'event_photo.g.dart';

@CopyWith()
@JsonSerializable(includeIfNull: false)
class EventPhoto {
  EventPhoto({
    required this.images,
  });

  @JsonKey(name: 'images', defaultValue: [])
  final List<Photo> images;

  factory EventPhoto.fromJson(Map<String, dynamic> json) => _$EventPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$EventPhotoToJson(this);
}

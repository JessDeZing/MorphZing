import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/agenda/event_photo.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/utils/style/colors.dart';

part 'event.g.dart';

@CopyWith()
@JsonSerializable(includeIfNull: false)
class Event {
  Event({
    required this.eventName,
    required this.categoryId,
    required this.eventPhotos,
    this.isParticipant = false,
    this.id,
    this.reminder,
    this.place,
    this.notes,
    this.user,
    this.startTime,
    this.endTime,
    this.recurrences,
    this.date,
    this.isEventDone = false,
    this.url = '',
    this.uuid = '',
  });

  final int? id;

  @JsonKey(name: "event_name", defaultValue: "")
  final String eventName;

  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson, name: "start_time")
  final DateTime? startTime;

  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson, name: "end_time")
  final DateTime? endTime;

  final int? reminder;

  final String url;

  final String uuid;

  final String? place;

  final String? notes;

  @JsonKey(fromJson: _ignoreNoneWord)
  final String? recurrences;

  final int? user;

  @JsonKey(name: 'category', defaultValue: -1)
  final int categoryId;

  @JsonKey(name: 'status')
  final bool isEventDone;

  @JsonKey(name: 'is_participant', defaultValue: false)
  final bool isParticipant;

  final String? date;

  @JsonKey(name: 'event_photos', defaultValue: [])
  final List<EventPhoto> eventPhotos;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

  Color? getBgColor() {
    switch (categoryId) {
      case 1:
        return workColor;
      case 2:
        return financeColor;
      case 3:
        return travelColor;
      case 4:
        return selfCareColor;
      case 5:
        return null;
      default:
        return meetUpColor;
    }
  }

  @override
  String toString() {
    return 'Event{id: $id, eventName: $eventName, startTime: $startTime, endTime: $endTime, reminder: $reminder, place: $place, notes: $notes, user: $user}';
  }
}

DateTime? _dateFromJson(dynamic json) {
  return (json as String?) == null ? null : DateTime.parse(json as String);
}

String _dateToJson(DateTime? value) {
  return value!.toString();
}

String? _ignoreNoneWord(String? key) {
  if (key == 'None') {
    return null;
  }
  return key;
}

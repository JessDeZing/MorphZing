import 'package:json_annotation/json_annotation.dart';

part 'event_edit_request.g.dart';

@JsonSerializable(includeIfNull: false)
class EventEdit {
  final int event;
  final String date;
  final bool status;

  const EventEdit({
    required this.event,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toJson() => _$EventEditToJson(this);

  factory EventEdit.fromJson(Map<String, dynamic> json) =>
      _$EventEditFromJson(json);
}

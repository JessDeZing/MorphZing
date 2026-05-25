// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
      status: _fromJsonToStatus(json['status'] as String?),
      contactId: json['contact_id'] as String?,
      phoneNumber: json['phone_number'] as String?,
      eventId: json['event'] as int,
    );

Map<String, dynamic> _$ParticipantToJson(Participant instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('status', _fromStatusToJson(instance.status));
  writeNotNull('contact_id', instance.contactId);
  writeNotNull('phone_number', instance.phoneNumber);
  val['event'] = instance.eventId;
  return val;
}

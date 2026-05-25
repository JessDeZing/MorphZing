import 'package:json_annotation/json_annotation.dart';

part 'participant.g.dart';

@JsonSerializable(includeIfNull: false)
class Participant {
  @JsonKey(
    fromJson: _fromJsonToStatus,
    toJson: _fromStatusToJson,
  )
  final ParticipantStatus? status;

  @JsonKey(name: 'contact_id')
  final String? contactId;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  @JsonKey(name: 'event')
  final int eventId;

  Participant({
    this.status,
    this.contactId,
    this.phoneNumber,
    required this.eventId,
  });

  @override
  String toString() {
    return 'Participant{status: $status, contactId: $contactId, phoneNumber: $phoneNumber, eventId: $eventId}';
  }

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}

ParticipantStatus? _fromJsonToStatus(String? key) => key?.toParticipantStatus();

String? _fromStatusToJson(ParticipantStatus? participantStatus) =>
    participantStatus?.value;

enum ParticipantStatus {
  pending('pending'),
  declined('decline'),
  accepted('accedped');

  final String value;

  const ParticipantStatus(this.value);
}

extension ParticipantStatusExtension on String {
  ParticipantStatus toParticipantStatus() {
    if (this == ParticipantStatus.accepted.value) {
      return ParticipantStatus.accepted;
    } else if (this == ParticipantStatus.declined.value) {
      return ParticipantStatus.declined;
    } else {
      return ParticipantStatus.pending;
    }
  }
}

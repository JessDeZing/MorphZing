import 'package:json_annotation/json_annotation.dart';

part 'invitation_change_status.g.dart';

@JsonSerializable()
class InvitationChangeStatus {
  final int event;
  final String status;

  const InvitationChangeStatus({
    required this.event,
    required this.status,
  });

  Map<String, dynamic> toJson() => _$InvitationChangeStatusToJson(this);

  factory InvitationChangeStatus.fromJson(Map<String, dynamic> json) =>
      _$InvitationChangeStatusFromJson(json);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation_change_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvitationChangeStatus _$InvitationChangeStatusFromJson(
        Map<String, dynamic> json) =>
    InvitationChangeStatus(
      event: json['event'] as int,
      status: json['status'] as String,
    );

Map<String, dynamic> _$InvitationChangeStatusToJson(
        InvitationChangeStatus instance) =>
    <String, dynamic>{
      'event': instance.event,
      'status': instance.status,
    };

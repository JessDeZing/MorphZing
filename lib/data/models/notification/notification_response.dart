import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_response.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationResponse {
  const NotificationResponse({
    required this.id,
    required this.notification,
    required this.smsMessage,
  });

  final int id;
  final bool notification;
  final bool smsMessage;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}

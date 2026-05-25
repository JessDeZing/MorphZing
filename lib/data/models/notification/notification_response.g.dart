// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NotificationResponseCWProxy {
  NotificationResponse id(int id);

  NotificationResponse notification(bool notification);

  NotificationResponse smsMessage(bool smsMessage);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationResponse call({
    int? id,
    bool? notification,
    bool? smsMessage,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNotificationResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNotificationResponse.copyWith.fieldName(...)`
class _$NotificationResponseCWProxyImpl
    implements _$NotificationResponseCWProxy {
  final NotificationResponse _value;

  const _$NotificationResponseCWProxyImpl(this._value);

  @override
  NotificationResponse id(int id) => this(id: id);

  @override
  NotificationResponse notification(bool notification) =>
      this(notification: notification);

  @override
  NotificationResponse smsMessage(bool smsMessage) =>
      this(smsMessage: smsMessage);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NotificationResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NotificationResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  NotificationResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? notification = const $CopyWithPlaceholder(),
    Object? smsMessage = const $CopyWithPlaceholder(),
  }) {
    return NotificationResponse(
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      notification:
          notification == const $CopyWithPlaceholder() || notification == null
              ? _value.notification
              // ignore: cast_nullable_to_non_nullable
              : notification as bool,
      smsMessage:
          smsMessage == const $CopyWithPlaceholder() || smsMessage == null
              ? _value.smsMessage
              // ignore: cast_nullable_to_non_nullable
              : smsMessage as bool,
    );
  }
}

extension $NotificationResponseCopyWith on NotificationResponse {
  /// Returns a callable class that can be used as follows: `instanceOfNotificationResponse.copyWith(...)` or like so:`instanceOfNotificationResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NotificationResponseCWProxy get copyWith =>
      _$NotificationResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResponse _$NotificationResponseFromJson(
        Map<String, dynamic> json) =>
    NotificationResponse(
      id: json['id'] as int,
      notification: json['notification'] as bool,
      smsMessage: json['sms_message'] as bool,
    );

Map<String, dynamic> _$NotificationResponseToJson(
        NotificationResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'notification': instance.notification,
      'sms_message': instance.smsMessage,
    };

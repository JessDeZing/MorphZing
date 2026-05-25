// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChangePasswordResponseCWProxy {
  ChangePasswordResponse isSuccess(bool isSuccess);

  ChangePasswordResponse message(String? message);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChangePasswordResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChangePasswordResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  ChangePasswordResponse call({
    bool? isSuccess,
    String? message,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChangePasswordResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChangePasswordResponse.copyWith.fieldName(...)`
class _$ChangePasswordResponseCWProxyImpl
    implements _$ChangePasswordResponseCWProxy {
  final ChangePasswordResponse _value;

  const _$ChangePasswordResponseCWProxyImpl(this._value);

  @override
  ChangePasswordResponse isSuccess(bool isSuccess) =>
      this(isSuccess: isSuccess);

  @override
  ChangePasswordResponse message(String? message) => this(message: message);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChangePasswordResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChangePasswordResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  ChangePasswordResponse call({
    Object? isSuccess = const $CopyWithPlaceholder(),
    Object? message = const $CopyWithPlaceholder(),
  }) {
    return ChangePasswordResponse(
      isSuccess: isSuccess == const $CopyWithPlaceholder() || isSuccess == null
          ? _value.isSuccess
          // ignore: cast_nullable_to_non_nullable
          : isSuccess as bool,
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
    );
  }
}

extension $ChangePasswordResponseCopyWith on ChangePasswordResponse {
  /// Returns a callable class that can be used as follows: `instanceOfChangePasswordResponse.copyWith(...)` or like so:`instanceOfChangePasswordResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChangePasswordResponseCWProxy get copyWith =>
      _$ChangePasswordResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordResponse _$ChangePasswordResponseFromJson(
        Map<String, dynamic> json) =>
    ChangePasswordResponse(
      isSuccess: json['success'] as bool,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ChangePasswordResponseToJson(
        ChangePasswordResponse instance) =>
    <String, dynamic>{
      'success': instance.isSuccess,
      'message': instance.message,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_password_provider.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CheckPasswordProviderCWProxy {
  CheckPasswordProvider newPassword(String newPassword);

  CheckPasswordProvider oldPassword(String oldPassword);

  CheckPasswordProvider userId(int userId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CheckPasswordProvider(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CheckPasswordProvider(...).copyWith(id: 12, name: "My name")
  /// ````
  CheckPasswordProvider call({
    String? newPassword,
    String? oldPassword,
    int? userId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCheckPasswordProvider.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCheckPasswordProvider.copyWith.fieldName(...)`
class _$CheckPasswordProviderCWProxyImpl
    implements _$CheckPasswordProviderCWProxy {
  final CheckPasswordProvider _value;

  const _$CheckPasswordProviderCWProxyImpl(this._value);

  @override
  CheckPasswordProvider newPassword(String newPassword) =>
      this(newPassword: newPassword);

  @override
  CheckPasswordProvider oldPassword(String oldPassword) =>
      this(oldPassword: oldPassword);

  @override
  CheckPasswordProvider userId(int userId) => this(userId: userId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CheckPasswordProvider(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CheckPasswordProvider(...).copyWith(id: 12, name: "My name")
  /// ````
  CheckPasswordProvider call({
    Object? newPassword = const $CopyWithPlaceholder(),
    Object? oldPassword = const $CopyWithPlaceholder(),
    Object? userId = const $CopyWithPlaceholder(),
  }) {
    return CheckPasswordProvider(
      newPassword:
          newPassword == const $CopyWithPlaceholder() || newPassword == null
              ? _value.newPassword
              // ignore: cast_nullable_to_non_nullable
              : newPassword as String,
      oldPassword:
          oldPassword == const $CopyWithPlaceholder() || oldPassword == null
              ? _value.oldPassword
              // ignore: cast_nullable_to_non_nullable
              : oldPassword as String,
      userId: userId == const $CopyWithPlaceholder() || userId == null
          ? _value.userId
          // ignore: cast_nullable_to_non_nullable
          : userId as int,
    );
  }
}

extension $CheckPasswordProviderCopyWith on CheckPasswordProvider {
  /// Returns a callable class that can be used as follows: `instanceOfCheckPasswordProvider.copyWith(...)` or like so:`instanceOfCheckPasswordProvider.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CheckPasswordProviderCWProxy get copyWith =>
      _$CheckPasswordProviderCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckPasswordProvider _$CheckPasswordProviderFromJson(
        Map<String, dynamic> json) =>
    CheckPasswordProvider(
      userId: json['user_id'] as int,
      oldPassword: json['old_password'] as String,
      newPassword: json['new_password'] as String,
    );

Map<String, dynamic> _$CheckPasswordProviderToJson(
        CheckPasswordProvider instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'old_password': instance.oldPassword,
      'new_password': instance.newPassword,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_provider.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ResetPasswordProviderCWProxy {
  ResetPasswordProvider confirmPassword(String? confirmPassword);

  ResetPasswordProvider password(String? password);

  ResetPasswordProvider secret(String? secret);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResetPasswordProvider(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResetPasswordProvider(...).copyWith(id: 12, name: "My name")
  /// ````
  ResetPasswordProvider call({
    String? confirmPassword,
    String? password,
    String? secret,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfResetPasswordProvider.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfResetPasswordProvider.copyWith.fieldName(...)`
class _$ResetPasswordProviderCWProxyImpl
    implements _$ResetPasswordProviderCWProxy {
  final ResetPasswordProvider _value;

  const _$ResetPasswordProviderCWProxyImpl(this._value);

  @override
  ResetPasswordProvider confirmPassword(String? confirmPassword) =>
      this(confirmPassword: confirmPassword);

  @override
  ResetPasswordProvider password(String? password) => this(password: password);

  @override
  ResetPasswordProvider secret(String? secret) => this(secret: secret);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ResetPasswordProvider(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ResetPasswordProvider(...).copyWith(id: 12, name: "My name")
  /// ````
  ResetPasswordProvider call({
    Object? confirmPassword = const $CopyWithPlaceholder(),
    Object? password = const $CopyWithPlaceholder(),
    Object? secret = const $CopyWithPlaceholder(),
  }) {
    return ResetPasswordProvider(
      confirmPassword: confirmPassword == const $CopyWithPlaceholder()
          ? _value.confirmPassword
          // ignore: cast_nullable_to_non_nullable
          : confirmPassword as String?,
      password: password == const $CopyWithPlaceholder()
          ? _value.password
          // ignore: cast_nullable_to_non_nullable
          : password as String?,
      secret: secret == const $CopyWithPlaceholder()
          ? _value.secret
          // ignore: cast_nullable_to_non_nullable
          : secret as String?,
    );
  }
}

extension $ResetPasswordProviderCopyWith on ResetPasswordProvider {
  /// Returns a callable class that can be used as follows: `instanceOfResetPasswordProvider.copyWith(...)` or like so:`instanceOfResetPasswordProvider.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ResetPasswordProviderCWProxy get copyWith =>
      _$ResetPasswordProviderCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPasswordProvider _$ResetPasswordProviderFromJson(
        Map<String, dynamic> json) =>
    ResetPasswordProvider(
      secret: json['secret'] as String?,
      password: json['password'] as String?,
      confirmPassword: json['confirm_password'] as String?,
    );

Map<String, dynamic> _$ResetPasswordProviderToJson(
        ResetPasswordProvider instance) =>
    <String, dynamic>{
      'secret': instance.secret,
      'password': instance.password,
      'confirm_password': instance.confirmPassword,
    };

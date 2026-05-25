// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_password_provider.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$RecoveryPasswordProviderCWProxy {
  RecoveryPasswordProvider phone(String? phone);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecoveryPasswordProvider(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecoveryPasswordProvider(...).copyWith(id: 12, name: "My name")
  /// ````
  RecoveryPasswordProvider call({
    String? phone,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfRecoveryPasswordProvider.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfRecoveryPasswordProvider.copyWith.fieldName(...)`
class _$RecoveryPasswordProviderCWProxyImpl
    implements _$RecoveryPasswordProviderCWProxy {
  final RecoveryPasswordProvider _value;

  const _$RecoveryPasswordProviderCWProxyImpl(this._value);

  @override
  RecoveryPasswordProvider phone(String? phone) => this(phone: phone);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `RecoveryPasswordProvider(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// RecoveryPasswordProvider(...).copyWith(id: 12, name: "My name")
  /// ````
  RecoveryPasswordProvider call({
    Object? phone = const $CopyWithPlaceholder(),
  }) {
    return RecoveryPasswordProvider(
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String?,
    );
  }
}

extension $RecoveryPasswordProviderCopyWith on RecoveryPasswordProvider {
  /// Returns a callable class that can be used as follows: `instanceOfRecoveryPasswordProvider.copyWith(...)` or like so:`instanceOfRecoveryPasswordProvider.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$RecoveryPasswordProviderCWProxy get copyWith =>
      _$RecoveryPasswordProviderCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryPasswordProvider _$RecoveryPasswordProviderFromJson(
        Map<String, dynamic> json) =>
    RecoveryPasswordProvider(
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$RecoveryPasswordProviderToJson(
        RecoveryPasswordProvider instance) =>
    <String, dynamic>{
      'phone': instance.phone,
    };

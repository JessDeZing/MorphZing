// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_phone_provider.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ChangePhoneProviderCWProxy {
  ChangePhoneProvider phone(String phone);

  ChangePhoneProvider secret(String secret);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChangePhoneProvider(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChangePhoneProvider(...).copyWith(id: 12, name: "My name")
  /// ````
  ChangePhoneProvider call({
    String? phone,
    String? secret,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfChangePhoneProvider.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfChangePhoneProvider.copyWith.fieldName(...)`
class _$ChangePhoneProviderCWProxyImpl implements _$ChangePhoneProviderCWProxy {
  final ChangePhoneProvider _value;

  const _$ChangePhoneProviderCWProxyImpl(this._value);

  @override
  ChangePhoneProvider phone(String phone) => this(phone: phone);

  @override
  ChangePhoneProvider secret(String secret) => this(secret: secret);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ChangePhoneProvider(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ChangePhoneProvider(...).copyWith(id: 12, name: "My name")
  /// ````
  ChangePhoneProvider call({
    Object? phone = const $CopyWithPlaceholder(),
    Object? secret = const $CopyWithPlaceholder(),
  }) {
    return ChangePhoneProvider(
      phone: phone == const $CopyWithPlaceholder() || phone == null
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      secret: secret == const $CopyWithPlaceholder() || secret == null
          ? _value.secret
          // ignore: cast_nullable_to_non_nullable
          : secret as String,
    );
  }
}

extension $ChangePhoneProviderCopyWith on ChangePhoneProvider {
  /// Returns a callable class that can be used as follows: `instanceOfChangePhoneProvider.copyWith(...)` or like so:`instanceOfChangePhoneProvider.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ChangePhoneProviderCWProxy get copyWith =>
      _$ChangePhoneProviderCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePhoneProvider _$ChangePhoneProviderFromJson(Map<String, dynamic> json) =>
    ChangePhoneProvider(
      secret: json['secret'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$ChangePhoneProviderToJson(
        ChangePhoneProvider instance) =>
    <String, dynamic>{
      'secret': instance.secret,
      'phone': instance.phone,
    };

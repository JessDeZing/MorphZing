// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SocialCWProxy {
  Social accessToken(String? accessToken);

  Social email(String? email);

  Social refreshToken(String? refreshToken);

  Social secretKey(String? secretKey);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Social(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Social(...).copyWith(id: 12, name: "My name")
  /// ````
  Social call({
    String? accessToken,
    String? email,
    String? refreshToken,
    String? secretKey,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSocial.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSocial.copyWith.fieldName(...)`
class _$SocialCWProxyImpl implements _$SocialCWProxy {
  final Social _value;

  const _$SocialCWProxyImpl(this._value);

  @override
  Social accessToken(String? accessToken) => this(accessToken: accessToken);

  @override
  Social email(String? email) => this(email: email);

  @override
  Social refreshToken(String? refreshToken) => this(refreshToken: refreshToken);

  @override
  Social secretKey(String? secretKey) => this(secretKey: secretKey);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Social(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Social(...).copyWith(id: 12, name: "My name")
  /// ````
  Social call({
    Object? accessToken = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? refreshToken = const $CopyWithPlaceholder(),
    Object? secretKey = const $CopyWithPlaceholder(),
  }) {
    return Social(
      accessToken: accessToken == const $CopyWithPlaceholder()
          ? _value.accessToken
          // ignore: cast_nullable_to_non_nullable
          : accessToken as String?,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      refreshToken: refreshToken == const $CopyWithPlaceholder()
          ? _value.refreshToken
          // ignore: cast_nullable_to_non_nullable
          : refreshToken as String?,
      secretKey: secretKey == const $CopyWithPlaceholder()
          ? _value.secretKey
          // ignore: cast_nullable_to_non_nullable
          : secretKey as String?,
    );
  }
}

extension $SocialCopyWith on Social {
  /// Returns a callable class that can be used as follows: `instanceOfSocial.copyWith(...)` or like so:`instanceOfSocial.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SocialCWProxy get copyWith => _$SocialCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Social _$SocialFromJson(Map<String, dynamic> json) => Social(
      accessToken: json['access'] as String?,
      refreshToken: json['refresh'] as String?,
      secretKey: json['secret'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$SocialToJson(Social instance) => <String, dynamic>{
      'access': instance.accessToken,
      'refresh': instance.refreshToken,
      'secret': instance.secretKey,
      'email': instance.email,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserCWProxy {
  User email(String email);

  User fullName(String fullName);

  User id(int id);

  User imageUrl(String imageUrl);

  User paymentStatus(SubscriptionType paymentStatus);

  User phone(String phone);

  User templateCounter(int templateCounter);

  User userSubscription(UserSubscription userSubscription);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `User(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// User(...).copyWith(id: 12, name: "My name")
  /// ````
  User call({
    String? email,
    String? fullName,
    int? id,
    String? imageUrl,
    SubscriptionType? paymentStatus,
    String? phone,
    int? templateCounter,
    UserSubscription? userSubscription,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUser.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUser.copyWith.fieldName(...)`
class _$UserCWProxyImpl implements _$UserCWProxy {
  final User _value;

  const _$UserCWProxyImpl(this._value);

  @override
  User email(String email) => this(email: email);

  @override
  User fullName(String fullName) => this(fullName: fullName);

  @override
  User id(int id) => this(id: id);

  @override
  User imageUrl(String imageUrl) => this(imageUrl: imageUrl);

  @override
  User paymentStatus(SubscriptionType paymentStatus) =>
      this(paymentStatus: paymentStatus);

  @override
  User phone(String phone) => this(phone: phone);

  @override
  User templateCounter(int templateCounter) =>
      this(templateCounter: templateCounter);

  @override
  User userSubscription(UserSubscription userSubscription) =>
      this(userSubscription: userSubscription);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `User(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// User(...).copyWith(id: 12, name: "My name")
  /// ````
  User call({
    Object? email = const $CopyWithPlaceholder(),
    Object? fullName = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? imageUrl = const $CopyWithPlaceholder(),
    Object? paymentStatus = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? templateCounter = const $CopyWithPlaceholder(),
    Object? userSubscription = const $CopyWithPlaceholder(),
  }) {
    return User(
      email: email == const $CopyWithPlaceholder() || email == null
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
      fullName: fullName == const $CopyWithPlaceholder() || fullName == null
          ? _value.fullName
          // ignore: cast_nullable_to_non_nullable
          : fullName as String,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      imageUrl: imageUrl == const $CopyWithPlaceholder() || imageUrl == null
          ? _value.imageUrl
          // ignore: cast_nullable_to_non_nullable
          : imageUrl as String,
      paymentStatus:
          paymentStatus == const $CopyWithPlaceholder() || paymentStatus == null
              ? _value.paymentStatus
              // ignore: cast_nullable_to_non_nullable
              : paymentStatus as SubscriptionType,
      phone: phone == const $CopyWithPlaceholder() || phone == null
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      templateCounter: templateCounter == const $CopyWithPlaceholder() ||
              templateCounter == null
          ? _value.templateCounter
          // ignore: cast_nullable_to_non_nullable
          : templateCounter as int,
      userSubscription: userSubscription == const $CopyWithPlaceholder() ||
              userSubscription == null
          ? _value.userSubscription
          // ignore: cast_nullable_to_non_nullable
          : userSubscription as UserSubscription,
    );
  }
}

extension $UserCopyWith on User {
  /// Returns a callable class that can be used as follows: `instanceOfUser.copyWith(...)` or like so:`instanceOfUser.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserCWProxy get copyWith => _$UserCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      paymentStatus: json['payment_status'] == null
          ? SubscriptionType.free
          : SubscriptionType.fromValue(json['payment_status'] as String?),
      userSubscription: UserSubscription.fromJson(
          json['user_subscription'] as Map<String, dynamic>),
      templateCounter: json['template_counter'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'full_name': instance.fullName,
      'image_url': instance.imageUrl,
      'payment_status': _$SubscriptionTypeEnumMap[instance.paymentStatus]!,
      'user_subscription': instance.userSubscription,
      'template_counter': instance.templateCounter,
    };

const _$SubscriptionTypeEnumMap = {
  SubscriptionType.free: 'free',
  SubscriptionType.basic: 'basic',
  SubscriptionType.premium: 'premium',
  SubscriptionType.familyShare: 'familyShare',
};

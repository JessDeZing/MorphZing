// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSubscription _$UserSubscriptionFromJson(Map<String, dynamic> json) =>
    UserSubscription(
      id: json['id'] as int,
      paymentStatus: json['tariff_type'] == null
          ? SubscriptionType.free
          : SubscriptionType.fromValue(json['tariff_type'] as String?),
      revenuecatId: json['revenuecat_id'] as String? ?? '',
      price: json['price'] as String? ?? '',
      startDate: _dateFromJson(json['start_date']),
      endDate: _dateFromJson(json['end_date']),
    );

Map<String, dynamic> _$UserSubscriptionToJson(UserSubscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tariff_type': _$SubscriptionTypeEnumMap[instance.paymentStatus]!,
      'start_date': instance.startDate?.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'revenuecat_id': instance.revenuecatId,
      'price': instance.price,
    };

const _$SubscriptionTypeEnumMap = {
  SubscriptionType.free: 'free',
  SubscriptionType.basic: 'basic',
  SubscriptionType.premium: 'premium',
  SubscriptionType.familyShare: 'familyShare',
};

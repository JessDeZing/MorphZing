import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';

part 'user_subscription.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserSubscription {
  const UserSubscription({
    required this.id,
    required this.paymentStatus,
    required this.revenuecatId,
    required this.price,
    this.startDate,
    this.endDate,
  });

  final int id;
  @JsonKey(
    defaultValue: SubscriptionType.free,
    fromJson: SubscriptionType.fromValue,
    name: 'tariff_type',
  )
  final SubscriptionType paymentStatus;

  @JsonKey(fromJson: _dateFromJson)
  final DateTime? startDate;

  @JsonKey(fromJson: _dateFromJson)
  final DateTime? endDate;

  @JsonKey(defaultValue: '')
  final String revenuecatId;

  @JsonKey(defaultValue: '')
  final String price;

  factory UserSubscription.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionFromJson(json);
}

DateTime? _dateFromJson(dynamic json) {
  return (json as String?) == null
      ? DateTime.now()
      : DateTime.parse(json as String);
}

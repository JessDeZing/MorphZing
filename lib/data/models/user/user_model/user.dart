import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/core/enum/auth_provider.dart';
import 'package:morphzing/data/models/user/user_model/user_subscription.dart';

part 'user.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.imageUrl,
    required this.paymentStatus,
    required this.userSubscription,
    required this.templateCounter,
  });

  final int id;
  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: '')
  final String phone;
  @JsonKey(defaultValue: '')
  final String fullName;
  @JsonKey(defaultValue: '')
  final String imageUrl;
  @JsonKey(defaultValue: null, fromJson: SubscriptionType.fromValue)
  final SubscriptionType paymentStatus;
  final UserSubscription userSubscription;
  final int templateCounter;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{id: $id}';
  }

   String getPrice() {
    return userSubscription.price; // Access the price from the UserSubscription
  }
}

enum SubscriptionType {
  free(value: 'free'),
  basic(value: 'basic'),
  premium(value: 'premium'),
  //клиент может предоставлять подписку бесплатно своим родным
  familyShare(value: 'family_share');
  

  final String? value;

  const SubscriptionType({this.value = 'free'});

  factory SubscriptionType.fromValue(String? value) =>
      SubscriptionType.values.firstWhere((element) => element.value == value);
}

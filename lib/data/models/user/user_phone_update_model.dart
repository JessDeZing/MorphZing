import 'dart:convert';

UserPhoneUpdateModel userVerificationFromJson(String str) =>
    UserPhoneUpdateModel.fromJson(json.decode(str));

String userVerificationToJson(UserPhoneUpdateModel data) =>
    json.encode(data.toJson());

class UserPhoneUpdateModel {
  UserPhoneUpdateModel({
    required this.phone,
    required this.secret,
  });

  String phone;
  String secret;

  factory UserPhoneUpdateModel.fromJson(Map<String, dynamic> json) =>
      UserPhoneUpdateModel(
        phone: json["phone"],
        secret: json["secret"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "secret": secret,
      };
}

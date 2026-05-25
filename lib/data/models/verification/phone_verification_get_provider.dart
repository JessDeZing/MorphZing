// To parse this JSON data, do
//
//     final phoneVerificationGet = phoneVerificationGetFromJson(jsonString);

import 'dart:convert';

PhoneVerificationGet phoneVerificationGetFromJson(String str) => PhoneVerificationGet.fromJson(json.decode(str));

String phoneVerificationGetToJson(PhoneVerificationGet data) => json.encode(data.toJson());

class PhoneVerificationGet {
  PhoneVerificationGet({
    required this.success,
    required this.phone,
    required this.message,
  });

  bool? success;
  String? phone;
  String? message;

  factory PhoneVerificationGet.fromJson(Map<String, dynamic> json) => PhoneVerificationGet(
    success: json["success"],
    phone: json["phone"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "phone": phone,
    "message": message,
  };
}

// To parse this JSON data, do
//
//     final phoneVerificationPost = phoneVerificationPostFromJson(jsonString);

import 'dart:convert';

PhoneVerificationPost phoneVerificationPostFromJson(String str) => PhoneVerificationPost.fromJson(json.decode(str));

String phoneVerificationPostToJson(PhoneVerificationPost data) => json.encode(data.toJson());

class PhoneVerificationPost {
  PhoneVerificationPost({
    required this.phone,
  });

  String phone;

  factory PhoneVerificationPost.fromJson(Map<String, dynamic> json) => PhoneVerificationPost(
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
  };
}

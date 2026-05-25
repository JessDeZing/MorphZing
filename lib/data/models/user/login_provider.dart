// To parse this JSON data, do
//
//     final loginProvider = loginProviderFromJson(jsonString);

import 'dart:convert';

LoginProvider loginProviderFromJson(String str) => LoginProvider.fromJson(json.decode(str));

String loginProviderToJson(LoginProvider data) => json.encode(data.toJson());

class LoginProvider {
  LoginProvider({
    required this.phone,
    required this.password,
  });

  String phone;
  String password;

  factory LoginProvider.fromJson(Map<String, dynamic> json) => LoginProvider(
    phone: json["phone"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "password": password,
  };
}

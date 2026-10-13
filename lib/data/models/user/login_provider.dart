// To parse this JSON data, do
//
//     final loginProvider = loginProviderFromJson(jsonString);

import 'dart:convert';

LoginProvider loginProviderFromJson(String str) => LoginProvider.fromJson(json.decode(str));

String loginProviderToJson(LoginProvider data) => json.encode(data.toJson());

class LoginProvider {
  LoginProvider({
    this.phone,
    this.email,
    required this.password,
  });

  // Log in with phone OR email (the server accepts either)
  String? phone;
  String? email;
  String password;

  factory LoginProvider.fromJson(Map<String, dynamic> json) => LoginProvider(
    phone: json["phone"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    if (phone != null) "phone": phone,
    if (email != null) "email": email,
    "password": password,
  };
}

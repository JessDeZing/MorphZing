// To parse this JSON data, do
//
//     final fullSignUpProvider = fullSignUpProviderFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

// FullSignUpProvider fullSignUpProviderFromJson(String str) => FullSignUpProvider.fromJson(json.decode(str));
//
// String fullSignUpProviderToJson(FullSignUpProvider data) => json.encode(data.toJson());

part 'sign_up_provider.g.dart';

@JsonSerializable()
class FullSignUpProvider {
  FullSignUpProvider({
    required this.secret,
    required this.fullName,
    required this.bio,
    required this.birthDate,
    required this.sex,
    required this.timeZone,
    this.email,
    this.phone,
    this.password,
  });

  @JsonKey(name: 'secret')
  String secret;
  @JsonKey(name: 'full_name')
  String fullName;
  @JsonKey(name: 'bio')
  String bio;
  @JsonKey(name: 'birth_date')
  String birthDate;
  @JsonKey(name: 'sex')
  String sex;
  @JsonKey(name: 'time_zone')
  String timeZone;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'phone')
  String? phone;
  @JsonKey(name: 'password')
  String? password;

  // factory FullSignUpProvider.fromJson(Map<String, dynamic> json) => _$FullSignUpProviderFromJson(json);
  //
  // Map<String, dynamic> toJson() => _$FullSignUpProviderToJson(this);

  factory FullSignUpProvider.fromJson(Map<String, dynamic> json) => FullSignUpProvider(
        secret: json["secret"],
        fullName: json["full_name"],
        bio: json["bio"],
        birthDate: json["birth_date"],
        sex: json["sex"],
        timeZone: json["time_zone"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "secret": secret,
        "full_name": fullName,
        "bio": bio,
        "birth_date": birthDate,
        "sex": sex,
        "time_zone": timeZone,
        "email": email,
        "phone": phone,
        "password": password,
      };
}

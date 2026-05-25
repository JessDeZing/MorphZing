// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullSignUpProvider _$FullSignUpProviderFromJson(Map<String, dynamic> json) =>
    FullSignUpProvider(
      secret: json['secret'] as String,
      fullName: json['full_name'] as String,
      bio: json['bio'] as String,
      birthDate: json['birth_date'] as String,
      sex: json['sex'] as String,
      timeZone: json['time_zone'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$FullSignUpProviderToJson(FullSignUpProvider instance) =>
    <String, dynamic>{
      'secret': instance.secret,
      'full_name': instance.fullName,
      'bio': instance.bio,
      'birth_date': instance.birthDate,
      'sex': instance.sex,
      'time_zone': instance.timeZone,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
    };

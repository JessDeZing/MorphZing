import 'dart:convert';
import 'dart:io';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'change_phone_provider.g.dart';

@CopyWith()
@JsonSerializable()
class ChangePhoneProvider {
  ChangePhoneProvider({
    required this.secret,
    required this.phone,
  });

  @JsonKey(name: 'secret')
  final String secret;
  @JsonKey(name: 'phone')
  final String phone;

  factory ChangePhoneProvider.fromJson(Map<String, dynamic> json) => _$ChangePhoneProviderFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePhoneProviderToJson(this);
}

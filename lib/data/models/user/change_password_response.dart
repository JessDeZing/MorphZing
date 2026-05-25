import 'dart:convert';
import 'dart:io';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'change_password_response.g.dart';

@CopyWith()
@JsonSerializable()
class ChangePasswordResponse {
  ChangePasswordResponse({
    required this.isSuccess,
    required this.message,
  });

  @JsonKey(name: 'success')
  final bool isSuccess;
  @JsonKey(name: 'message')
  final String? message;

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) => _$ChangePasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordResponseToJson(this);
}

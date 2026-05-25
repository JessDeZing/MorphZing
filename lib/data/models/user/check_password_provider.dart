import 'dart:convert';
import 'dart:io';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'check_password_provider.g.dart';

@CopyWith()
@JsonSerializable()
class CheckPasswordProvider {
  CheckPasswordProvider({
    required this.userId,
    required this.oldPassword,
    required this.newPassword,
  });

  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'old_password')
  final String oldPassword;
  @JsonKey(name: 'new_password')
  final String newPassword;

  factory CheckPasswordProvider.fromJson(Map<String, dynamic> json) => _$CheckPasswordProviderFromJson(json);

  Map<String, dynamic> toJson() => _$CheckPasswordProviderToJson(this);
}

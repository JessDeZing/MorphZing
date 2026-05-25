import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reset_password_provider.g.dart';

@CopyWith()
@JsonSerializable()
class ResetPasswordProvider {
  ResetPasswordProvider({
    required this.secret,
    required this.password,
    required this.confirmPassword,
  });

  @JsonKey(name: 'secret')
  final String? secret;
  @JsonKey(name: 'password')
  final String? password;
  @JsonKey(name: 'confirm_password')
  final String? confirmPassword;

  factory ResetPasswordProvider.fromJson(Map<String, dynamic> json) => _$ResetPasswordProviderFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordProviderToJson(this);
}

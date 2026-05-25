import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recovery_password_provider.g.dart';

@CopyWith()
@JsonSerializable()
class RecoveryPasswordProvider {
  RecoveryPasswordProvider({
    required this.phone,
  });

  @JsonKey(name: 'phone')
  final String? phone;

  factory RecoveryPasswordProvider.fromJson(Map<String, dynamic> json) => _$RecoveryPasswordProviderFromJson(json);

  Map<String, dynamic> toJson() => _$RecoveryPasswordProviderToJson(this);
}

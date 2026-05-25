import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'social.g.dart';

@CopyWith()
@JsonSerializable()
class Social {
  Social({
    this.accessToken,
    this.refreshToken,
    this.secretKey,
    this.email,
  });

  @JsonKey(name: 'access')
  final String? accessToken;
  @JsonKey(name: 'refresh')
  final String? refreshToken;
  @JsonKey(name: 'secret')
  final String? secretKey;
  @JsonKey(name: 'email')
  final String? email;

  factory Social.fromJson(Map<String, dynamic> json) => _$SocialFromJson(json);

  Map<String, dynamic> toJson() => _$SocialToJson(this);

  @override
  String toString() {
    return secretKey.toString();
  }
}

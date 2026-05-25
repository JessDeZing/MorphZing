import 'package:json_annotation/json_annotation.dart';

part 'banner.g.dart';

@JsonSerializable()
class Banner {
  const Banner({this.id, this.image});

  final String? image;
  @JsonKey(defaultValue: 0)
  final int? id;

  factory Banner.fromJson(Map<String, dynamic> json) => _$BannerFromJson(json);
}

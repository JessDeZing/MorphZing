import 'package:json_annotation/json_annotation.dart';

part 'advice.g.dart';

@JsonSerializable(includeIfNull: false)
class Advice {
  final int? id;
  final String name;
  final bool status;

  const Advice({this.id, required this.name, required this.status});

  factory Advice.fromJson(Map<String, dynamic> json) => _$AdviceFromJson(json);

  Map<String, dynamic> toJson() => _$AdviceToJson(this);

}

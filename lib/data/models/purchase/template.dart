import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'template.g.dart';

@CopyWith()
@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class Template {
  const Template({
    required this.id,
    required this.image,
    required this.name,
    this.categoryId = '',
    this.isPurchased = true,
    this.isPremium = false,
  });

  final int id;
  final String image;
  final String name;
  final String categoryId;
  final bool isPurchased;
  final bool isPremium;

  factory Template.fromJson(Map<String, dynamic> json) => _$TemplateFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateToJson(this);
}

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/data/models/disclaimer/disclaimer_model/about_app_model.dart';

part 'faqs.g.dart';

@CopyWith()
@JsonSerializable()
class FAQs {
  FAQs({
    required this.results,
  });
  @JsonKey(defaultValue: [])
  final List<AboutAppModel> results;

  factory FAQs.fromJson(Map<String, dynamic> json) =>
      _$FAQsFromJson(json);

  Map<String, dynamic> toJson() => _$FAQsToJson(this);
}

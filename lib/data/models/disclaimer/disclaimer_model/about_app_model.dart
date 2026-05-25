import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/localization/locale_enum.dart';

part 'about_app_model.g.dart';

@CopyWith()
@JsonSerializable(fieldRename: FieldRename.snake)
class AboutAppModel {
  AboutAppModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.questionSpanish,
    required this.answerSpanish,
  });

  @JsonKey(defaultValue: -1)
  final int id;
  @JsonKey(defaultValue: '')
  final String question;
  @JsonKey(defaultValue: '')
  final String answer;

  @JsonKey(defaultValue: '')
  final String questionSpanish;
  @JsonKey(defaultValue: '')
  final String answerSpanish;

  factory AboutAppModel.fromJson(Map<String, dynamic> json) =>
      _$AboutAppModelFromJson(json);

  Map<String, dynamic> toJson() => _$AboutAppModelToJson(this);
}

extension LocalizedName on AboutAppModel {
  String localeAnswer() {
    return Get.locale == LocaleEnum.es.getLocale() ? answerSpanish : answer;
  }

  String localQuestion() {
    return Get.locale == LocaleEnum.es.getLocale() ? questionSpanish : question;
  }
}

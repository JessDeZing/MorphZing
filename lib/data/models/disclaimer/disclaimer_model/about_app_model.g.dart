// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about_app_model.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AboutAppModelCWProxy {
  AboutAppModel answer(String answer);

  AboutAppModel answerSpanish(String answerSpanish);

  AboutAppModel id(int id);

  AboutAppModel question(String question);

  AboutAppModel questionSpanish(String questionSpanish);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AboutAppModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AboutAppModel(...).copyWith(id: 12, name: "My name")
  /// ````
  AboutAppModel call({
    String? answer,
    String? answerSpanish,
    int? id,
    String? question,
    String? questionSpanish,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAboutAppModel.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAboutAppModel.copyWith.fieldName(...)`
class _$AboutAppModelCWProxyImpl implements _$AboutAppModelCWProxy {
  final AboutAppModel _value;

  const _$AboutAppModelCWProxyImpl(this._value);

  @override
  AboutAppModel answer(String answer) => this(answer: answer);

  @override
  AboutAppModel answerSpanish(String answerSpanish) =>
      this(answerSpanish: answerSpanish);

  @override
  AboutAppModel id(int id) => this(id: id);

  @override
  AboutAppModel question(String question) => this(question: question);

  @override
  AboutAppModel questionSpanish(String questionSpanish) =>
      this(questionSpanish: questionSpanish);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AboutAppModel(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AboutAppModel(...).copyWith(id: 12, name: "My name")
  /// ````
  AboutAppModel call({
    Object? answer = const $CopyWithPlaceholder(),
    Object? answerSpanish = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? question = const $CopyWithPlaceholder(),
    Object? questionSpanish = const $CopyWithPlaceholder(),
  }) {
    return AboutAppModel(
      answer: answer == const $CopyWithPlaceholder() || answer == null
          ? _value.answer
          // ignore: cast_nullable_to_non_nullable
          : answer as String,
      answerSpanish:
          answerSpanish == const $CopyWithPlaceholder() || answerSpanish == null
              ? _value.answerSpanish
              // ignore: cast_nullable_to_non_nullable
              : answerSpanish as String,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      question: question == const $CopyWithPlaceholder() || question == null
          ? _value.question
          // ignore: cast_nullable_to_non_nullable
          : question as String,
      questionSpanish: questionSpanish == const $CopyWithPlaceholder() ||
              questionSpanish == null
          ? _value.questionSpanish
          // ignore: cast_nullable_to_non_nullable
          : questionSpanish as String,
    );
  }
}

extension $AboutAppModelCopyWith on AboutAppModel {
  /// Returns a callable class that can be used as follows: `instanceOfAboutAppModel.copyWith(...)` or like so:`instanceOfAboutAppModel.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AboutAppModelCWProxy get copyWith => _$AboutAppModelCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AboutAppModel _$AboutAppModelFromJson(Map<String, dynamic> json) =>
    AboutAppModel(
      id: json['id'] as int? ?? -1,
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      questionSpanish: json['question_spanish'] as String? ?? '',
      answerSpanish: json['answer_spanish'] as String? ?? '',
    );

Map<String, dynamic> _$AboutAppModelToJson(AboutAppModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'question_spanish': instance.questionSpanish,
      'answer_spanish': instance.answerSpanish,
    };

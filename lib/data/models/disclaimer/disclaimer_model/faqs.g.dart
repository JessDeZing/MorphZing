// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faqs.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FAQsCWProxy {
  FAQs results(List<AboutAppModel> results);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FAQs(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FAQs(...).copyWith(id: 12, name: "My name")
  /// ````
  FAQs call({
    List<AboutAppModel>? results,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFAQs.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFAQs.copyWith.fieldName(...)`
class _$FAQsCWProxyImpl implements _$FAQsCWProxy {
  final FAQs _value;

  const _$FAQsCWProxyImpl(this._value);

  @override
  FAQs results(List<AboutAppModel> results) => this(results: results);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FAQs(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FAQs(...).copyWith(id: 12, name: "My name")
  /// ````
  FAQs call({
    Object? results = const $CopyWithPlaceholder(),
  }) {
    return FAQs(
      results: results == const $CopyWithPlaceholder() || results == null
          ? _value.results
          // ignore: cast_nullable_to_non_nullable
          : results as List<AboutAppModel>,
    );
  }
}

extension $FAQsCopyWith on FAQs {
  /// Returns a callable class that can be used as follows: `instanceOfFAQs.copyWith(...)` or like so:`instanceOfFAQs.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FAQsCWProxy get copyWith => _$FAQsCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FAQs _$FAQsFromJson(Map<String, dynamic> json) => FAQs(
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => AboutAppModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$FAQsToJson(FAQs instance) => <String, dynamic>{
      'results': instance.results,
    };

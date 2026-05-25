// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TemplateCWProxy {
  Template categoryId(String categoryId);

  Template id(int id);

  Template image(String image);

  Template isPremium(bool isPremium);

  Template isPurchased(bool isPurchased);

  Template name(String name);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Template(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Template(...).copyWith(id: 12, name: "My name")
  /// ````
  Template call({
    String? categoryId,
    int? id,
    String? image,
    bool? isPremium,
    bool? isPurchased,
    String? name,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTemplate.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTemplate.copyWith.fieldName(...)`
class _$TemplateCWProxyImpl implements _$TemplateCWProxy {
  final Template _value;

  const _$TemplateCWProxyImpl(this._value);

  @override
  Template categoryId(String categoryId) => this(categoryId: categoryId);

  @override
  Template id(int id) => this(id: id);

  @override
  Template image(String image) => this(image: image);

  @override
  Template isPremium(bool isPremium) => this(isPremium: isPremium);

  @override
  Template isPurchased(bool isPurchased) => this(isPurchased: isPurchased);

  @override
  Template name(String name) => this(name: name);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Template(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Template(...).copyWith(id: 12, name: "My name")
  /// ````
  Template call({
    Object? categoryId = const $CopyWithPlaceholder(),
    Object? id = const $CopyWithPlaceholder(),
    Object? image = const $CopyWithPlaceholder(),
    Object? isPremium = const $CopyWithPlaceholder(),
    Object? isPurchased = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
  }) {
    return Template(
      categoryId:
          categoryId == const $CopyWithPlaceholder() || categoryId == null
              ? _value.categoryId
              // ignore: cast_nullable_to_non_nullable
              : categoryId as String,
      id: id == const $CopyWithPlaceholder() || id == null
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      image: image == const $CopyWithPlaceholder() || image == null
          ? _value.image
          // ignore: cast_nullable_to_non_nullable
          : image as String,
      isPremium: isPremium == const $CopyWithPlaceholder() || isPremium == null
          ? _value.isPremium
          // ignore: cast_nullable_to_non_nullable
          : isPremium as bool,
      isPurchased:
          isPurchased == const $CopyWithPlaceholder() || isPurchased == null
              ? _value.isPurchased
              // ignore: cast_nullable_to_non_nullable
              : isPurchased as bool,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
    );
  }
}

extension $TemplateCopyWith on Template {
  /// Returns a callable class that can be used as follows: `instanceOfTemplate.copyWith(...)` or like so:`instanceOfTemplate.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TemplateCWProxy get copyWith => _$TemplateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Template _$TemplateFromJson(Map<String, dynamic> json) => Template(
      id: json['id'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
      categoryId: json['category_id'] as String? ?? '',
      isPurchased: json['is_purchased'] as bool? ?? true,
      isPremium: json['is_premium'] as bool? ?? false,
    );

Map<String, dynamic> _$TemplateToJson(Template instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'name': instance.name,
      'category_id': instance.categoryId,
      'is_purchased': instance.isPurchased,
      'is_premium': instance.isPremium,
    };

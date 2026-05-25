// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_photo.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$EventPhotoCWProxy {
  EventPhoto images(List<Photo> images);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EventPhoto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EventPhoto(...).copyWith(id: 12, name: "My name")
  /// ````
  EventPhoto call({
    List<Photo>? images,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfEventPhoto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfEventPhoto.copyWith.fieldName(...)`
class _$EventPhotoCWProxyImpl implements _$EventPhotoCWProxy {
  final EventPhoto _value;

  const _$EventPhotoCWProxyImpl(this._value);

  @override
  EventPhoto images(List<Photo> images) => this(images: images);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `EventPhoto(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// EventPhoto(...).copyWith(id: 12, name: "My name")
  /// ````
  EventPhoto call({
    Object? images = const $CopyWithPlaceholder(),
  }) {
    return EventPhoto(
      images: images == const $CopyWithPlaceholder() || images == null
          ? _value.images
          // ignore: cast_nullable_to_non_nullable
          : images as List<Photo>,
    );
  }
}

extension $EventPhotoCopyWith on EventPhoto {
  /// Returns a callable class that can be used as follows: `instanceOfEventPhoto.copyWith(...)` or like so:`instanceOfEventPhoto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$EventPhotoCWProxy get copyWith => _$EventPhotoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventPhoto _$EventPhotoFromJson(Map<String, dynamic> json) => EventPhoto(
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => Photo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$EventPhotoToJson(EventPhoto instance) =>
    <String, dynamic>{
      'images': instance.images,
    };

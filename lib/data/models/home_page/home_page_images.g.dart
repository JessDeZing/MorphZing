// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomePageImages _$HomePageImagesFromJson(Map<String, dynamic> json) =>
    HomePageImages(
      id: json['id'] as int?,
      phoneImage: json['phone_image'] as String?,
      zingArtImage: json['zingart_image'] == null
          ? null
          : ZingArtImage.fromJson(
              json['zingart_image'] as Map<String, dynamic>),
      quoteImage: json['quota_image'] as String?,
    );

Map<String, dynamic> _$HomePageImagesToJson(HomePageImages instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone_image': instance.phoneImage,
      'zingart_image': instance.zingArtImage,
      'quota_image': instance.quoteImage,
    };

ZingArtImage _$ZingArtImageFromJson(Map<String, dynamic> json) => ZingArtImage(
      json['image'] as String?,
      json['zingart_url'] as String?,
    );

Map<String, dynamic> _$ZingArtImageToJson(ZingArtImage instance) =>
    <String, dynamic>{
      'image': instance.image,
      'zingart_url': instance.url,
    };

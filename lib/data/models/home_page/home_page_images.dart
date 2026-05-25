import 'package:json_annotation/json_annotation.dart';

part 'home_page_images.g.dart';

@JsonSerializable()
class HomePageImages {
  const HomePageImages({
    this.id,
    this.phoneImage,
    this.zingArtImage,
    this.quoteImage,
  });

  final int? id;

  @JsonKey(name: 'phone_image')
  final String? phoneImage;

  @JsonKey(name: 'zingart_image')
  final ZingArtImage? zingArtImage;

  @JsonKey(name: 'quota_image')
  final String? quoteImage;

  factory HomePageImages.fromJson(Map<String, dynamic> json) =>
      _$HomePageImagesFromJson(json);
}

@JsonSerializable()
class ZingArtImage {
  const ZingArtImage(
    this.image,
    this.url,
  );

  final String? image;

  @JsonKey(name: 'zingart_url')
  final String? url;

  factory ZingArtImage.fromJson(Map<String, dynamic> json) =>
      _$ZingArtImageFromJson(json);
}

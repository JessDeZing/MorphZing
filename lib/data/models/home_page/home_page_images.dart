import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morphzing/localization/locale_enum.dart';

part 'home_page_images.g.dart';

@JsonSerializable()
class HomePageImages {
  const HomePageImages({
    this.id,
    this.phoneImage,
    this.zingArtImage,
    this.quoteImage,
    this.quote,
  });

  final int? id;

  @JsonKey(name: 'phone_image')
  final String? phoneImage;

  @JsonKey(name: 'zingart_image')
  final ZingArtImage? zingArtImage;

  @JsonKey(name: 'quota_image')
  final String? quoteImage;

  final Quote? quote;

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

@JsonSerializable()
class Quote {
  const Quote({this.text, this.textEs, this.author});

  final String? text;

  @JsonKey(name: 'text_es')
  final String? textEs;

  final String? author;

  /// Spanish when the app is in Spanish and a translation exists, else English.
  String displayText() {
    final es = textEs?.trim() ?? '';
    if (Get.locale == LocaleEnum.es.getLocale() && es.isNotEmpty) return es;
    return text?.trim() ?? '';
  }

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}

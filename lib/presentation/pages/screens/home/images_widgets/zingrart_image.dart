import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ZingArtImage extends StatelessWidget {
  final String? url;
  final String? imageUrl;

  const ZingArtImage({
    Key? key,
    this.url,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (url == null) {
          showAttentionSnackBar(message: 'No url to open ZingArt');
        } else {
          await launchUrlString(
            url!,
            mode: LaunchMode.externalApplication,
          );
        }
      },
      child: Container(
        height: 150,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: FadeInImage(
          fadeInDuration: 100.milliseconds,
          fadeOutDuration: 100.milliseconds,
          fit: BoxFit.fill,
          placeholderFit: BoxFit.cover,
          placeholder: const AssetImage("assets/images/placeholder_photo.jpg"),
          image: NetworkImage(imageUrl ?? ''),
          imageErrorBuilder: (_, __, ___) => Image.asset(
            "assets/images/placeholder_photo.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

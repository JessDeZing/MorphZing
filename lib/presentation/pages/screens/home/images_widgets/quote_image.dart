import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuoteImage extends StatelessWidget {
  final String? imageUrl;

  const QuoteImage({
    Key? key,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

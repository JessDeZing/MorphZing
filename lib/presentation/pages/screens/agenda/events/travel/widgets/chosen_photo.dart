import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_gallery/photo_gallery.dart';

class ChosenPhoto extends StatelessWidget {
  final String mediumId;
  final MediumType? mediumType;

  const ChosenPhoto({
    Key? key,
    required this.mediumId,
    required this.mediumType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
      ),
      child: FadeInImage(
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 100),
        fadeOutDuration: const Duration(milliseconds: 100),
        placeholder:
            const AssetImage("assets/images/placeholder_photo.jpg"),
        image: ThumbnailProvider(
          mediumId: mediumId,
          mediumType: mediumType,
          highQuality: true,
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:photo_gallery/photo_gallery.dart';

class GridViewChildPhoto extends StatelessWidget {
  final bool isChosen;
  final String mediumId;
  final MediumType? mediumType;

  const GridViewChildPhoto({
    Key? key,
    required this.isChosen,
    required this.mediumId,
    this.mediumType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: (MediaQuery.of(context).size.width / 3),
          height: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: isChosen ? travelColor : whiteColor,
            ),
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
        ),
        Positioned(
          child: Container(
            height: 24.w,
            width: 24.w,
            decoration: BoxDecoration(
              color: isChosen ? travelColor : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: isChosen
                ? const Icon(
                    CupertinoIcons.checkmark_alt,
                    color: whiteColor,
                  )
                : const SizedBox.shrink(),
          ),
          top: 7.w,
          right: 7.w,
        ),
      ],
    );
  }
}

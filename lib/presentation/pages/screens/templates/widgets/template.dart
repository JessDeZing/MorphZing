import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/style/colors.dart';

const _imageSize = 155 / 360;

class Template extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isPurchased;
  final bool chosen;

  const Template({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.isPurchased,
    this.chosen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: _imageSize * width,
              width: _imageSize * width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: 2,
                  color: chosen ? blueColor : Colors.transparent,
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 100),
                  fadeOutDuration: const Duration(milliseconds: 100),
                  placeholder:
                      const AssetImage("assets/images/placeholder_photo.jpg"),
                  image: NetworkImage(imageUrl),
                ),
              ),
            ),
            if (!isPurchased)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? darkBgColor : whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: SvgPicture.asset('assets/icons/ic_lock.svg'),
                ),
              ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Get.toNamed(standardView, arguments: imageUrl),
                child: Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? darkBgColor : whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Icon(
                    Icons.remove_red_eye,
                    color: isDark ? Colors.white : blackTextColor,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 4),
            Text(
              name,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: customTextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : blackTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ],
    );
  }
}

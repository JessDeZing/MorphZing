import 'package:flutter/material.dart';
import 'package:morphzing/utils/style/colors.dart';

class AgendaMenuItem extends StatelessWidget {
  final Color? bgColor;
  final String iconImage;
  final String title;
  final String route;
  final BuildContext ctx;

  const AgendaMenuItem({
    Key? key,
    this.bgColor,
    required this.iconImage,
    required this.title,
    required this.route,
    required this.ctx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        gradient: bgColor == null ? specialOccasionGradient : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: AssetImage(iconImage),
            height: 52,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(
              color: bgColor?.value == workColor.value
                  ? blackTextColor
                  : whiteColor,
              fontFamily: 'SF Pro Display',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

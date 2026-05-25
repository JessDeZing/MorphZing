import 'package:flutter/material.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/utils/style/colors.dart';

class TitleRoundedContainer extends StatelessWidget {
  final String title;
  final String body;

  const TitleRoundedContainer({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: customTextStyle(
            fontSize: 15,
            color: isDark ? Colors.white : blackTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: isDark ? darkBgColor : bgColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(
            body,
            style: customTextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : blackTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

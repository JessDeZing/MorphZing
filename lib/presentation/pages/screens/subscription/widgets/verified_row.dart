import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/utils/style/colors.dart';

class VerifiedRow extends StatelessWidget {
  final String text;

  const VerifiedRow({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        SvgPicture.asset('assets/icons/ic_verified.svg'),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: customTextStyle(
              fontSize: 15,
              color: isDark ? Colors.white : blackTextColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

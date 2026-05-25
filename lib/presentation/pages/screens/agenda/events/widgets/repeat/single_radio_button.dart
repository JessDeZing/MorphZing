import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/utils/style/colors.dart';

class SingleRadioButton extends StatelessWidget {
  final String text;
  final bool isChosen;
  final Color? color;

  const SingleRadioButton({
    Key? key,
    required this.text,
    required this.isChosen,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 15.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? darkBgColor : bgColor,
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: customTextStyle(
              fontSize: 15.sp,
              color: isDark ? whiteColor : blackTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            height: 20.w,
            width: 20.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isChosen ? color : whiteColor,
              gradient:
                  isChosen && color == null ? specialOccasionGradient : null,
              border: Border.all(
                color: isChosen
                    ? (color ?? Colors.transparent)
                    : isDark
                        ? whiteColor
                        : dividerColor,
                width: 1.5.sp,
              ),
            ),
            child: isChosen
                ? Container(
                    height: 20.w,
                    width: 20.w,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.all(Radius.circular(20.w)),
                      gradient: color == null ? specialOccasionGradient : null,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/ic_check.svg',
                      color: isDark ? blackTextColor : whiteColor,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

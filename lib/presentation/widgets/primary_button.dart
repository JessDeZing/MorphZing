import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/utils/style/colors.dart';

class PrimaryButton extends StatelessWidget {
  final Color? buttonColor;
  final Color textColor;
  final String buttonText;
  final VoidCallback onPressed;

  const PrimaryButton({
    Key? key,
    required this.buttonColor,
    required this.buttonText,
    required this.onPressed,
    this.textColor = whiteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.w))),
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          height: 48,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
            gradient: buttonColor == null ? specialOccasionGradient : null,
          ),
          child: Center(
            child: Text(
              buttonText,
              style: customTextStyle(
                fontSize: 16.sp,
                color: textColor,
                fontWeight: FontWeight.w600,
              ).copyWith(height: (20 / 16).sp),
            ),
          ),
        ),
      ),
    );
  }
}

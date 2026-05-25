import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/utils/style/colors.dart';

class DateContainer extends StatelessWidget {
  final String date;

  const DateContainer({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? darkBgColor : whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
      ),
      child: Center(
        child: Text(
          date,
          style: customTextStyle(
            fontSize: 14.sp,
            color: isDark ? whiteColor : blackTextColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

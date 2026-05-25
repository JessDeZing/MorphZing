import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/utils/style/colors.dart';

class SingleParticipant extends StatelessWidget {
  final String initials;
  final String name;
  final String phone;
  final bool isChosen;
  final Color? color;

  const SingleParticipant({
    Key? key,
    required this.initials,
    required this.name,
    required this.phone,
    required this.isChosen,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          Container(
            height: 30.w,
            width: 30.w,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              gradient: color == null ? specialOccasionGradient : null,
            ),
            child: Center(
              child: Text(
                initials,
                style: customTextStyle(
                  fontSize: 13.sp,
                  color: whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: customTextStyle(
                    fontSize: 13.sp,
                    color: isDark ? whiteColor : blackTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  phone,
                  style: customTextStyle(
                    fontSize: 11.sp,
                    color: isDark ? whiteColor : greyTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: color == null ? specialOccasionGradient : null,
              color: color,
            ),
            child: Icon(
              isChosen ? Icons.remove : Icons.add,
              color: isDark ? blackTextColor : whiteColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

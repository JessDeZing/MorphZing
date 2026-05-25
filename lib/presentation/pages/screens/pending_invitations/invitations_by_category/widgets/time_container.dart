import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/start_and_finish_date/date_container.dart';
import 'package:morphzing/utils/style/colors.dart';

class TimeContainer extends StatelessWidget {
  final String start;
  final String end;

  const TimeContainer({
    Key? key,
    required this.start,
    required this.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          startFinishDate.tr,
          style: customTextStyle(
            fontSize: 15.sp,
            color: isDark ? Colors.white : blackTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isDark ? darkBgColor : bgColor,
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              start.isEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectStartEndTime.tr,
                        style: customTextStyle(
                          fontSize: 15.sp,
                          color: isDark ? Colors.white : greyTextColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DateContainer(date: start),
                        SizedBox(height: 8.h),
                        DateContainer(date: end),
                      ],
                    ),
              SizedBox.square(
                dimension: 20.w,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: isDark ? Colors.white : blackTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

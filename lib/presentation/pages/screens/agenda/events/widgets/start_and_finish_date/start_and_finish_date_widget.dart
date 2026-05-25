import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/start_and_finish_date/date_container.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/start_and_finish_date/indexed_stack_dialog.dart';
import 'package:morphzing/utils/style/colors.dart';

class StartAndFinishDateWidget extends StatelessWidget {
  final DateTime chosenTime;
  final String start;
  final String end;
  final Function(DateTime) changeStartDate;
  final Function(DateTime) changeEndDate;
  final Color? color;

  const StartAndFinishDateWidget({
    Key? key,
    required this.chosenTime,
    required this.start,
    required this.end,
    required this.changeStartDate,
    required this.changeEndDate,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    print('chosen day is ${chosenTime.toString()}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          startFinishDate.tr,
          style: customTextStyle(
            fontSize: 15.sp,
            color: isDark ? whiteColor : blackTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: () async {
            final result = await showDialog(
              context: context,
              builder: (_) => Center(
                child: IndexedStackDialog(
                  color: color,
                  chosenTime: chosenTime,
                ),
              ),
            );
            if (result != null && result is List<DateTime>) {
              changeStartDate(result.first);
              changeEndDate(result.last);
            }
          },
          child: Container(
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
                            color: isDark ? whiteColor : greyTextColor,
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
                    color: isDark ? whiteColor : blackTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

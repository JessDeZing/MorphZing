import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart' as t;
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/start_and_finish_date/time_picker_spinner.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';

class ChooseStartAndEndTime extends StatefulWidget {
  final Color? color;
  final DateTime selectedDay;

  const ChooseStartAndEndTime({
    Key? key,
    required this.color,
    required this.selectedDay,
  }) : super(key: key);

  @override
  State<ChooseStartAndEndTime> createState() => _ChooseStartAndEndTimeState();
}

class _ChooseStartAndEndTimeState extends State<ChooseStartAndEndTime>
    with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Material(
            color: isDark ? darkBgColor : whiteColor,
            type: MaterialType.card,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100.r))),
            clipBehavior: Clip.antiAlias,
            child: Container(
              height: 36.h,
              decoration: BoxDecoration(
                color: isDark ? darkBgColor : bgColor,
                borderRadius: BorderRadius.all(Radius.circular(100.r)),
              ),
              child: TabBar(
                padding: EdgeInsets.all(2.w),
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.r)),
                  color: widget.color,
                  gradient:
                      widget.color == null ? specialOccasionGradient : null,
                ),
                labelColor: isDark ? whiteColor : whiteColor,
                unselectedLabelColor: isDark ? whiteColor : greyTextColor,
                labelStyle: customTextStyle(
                  fontSize: 12.sp,
                  color: isDark ? whiteColor : whiteColor,
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: customTextStyle(
                  fontSize: 12.sp,
                  color: isDark ? whiteColor : greyTextColor,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    child: Text(t.startTime.tr),
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    child: Text(
                      t.finishTime.tr,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          height: 280.h,
          child: TabBarView(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TimePickerSpinner(
                    is24HourMode: false,
                    itemHeight: 40,
                    highlightedTextStyle: customTextStyle(
                      fontSize: 25.sp,
                      color: isDark ? whiteColor : blackTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                    normalTextStyle: customTextStyle(
                      fontSize: 25.sp,
                      color: isDark ? whiteColor : greyTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                    fadedTextStyle: customTextStyle(
                      fontSize: 25.sp,
                      color:
                          isDark ? whiteColor : greyTextColor.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                    onTimeChange: (time) {
                      startTime = time;
                    },
                  ),
                  SizedBox(height: 40.h),
                  PrimaryButton(
                    buttonColor: widget.color,
                    buttonText: t.continueKey.tr,
                    onPressed: () => _tabController.animateTo(1),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TimePickerSpinner(
                    is24HourMode: false,
                    itemHeight: 40,
                    highlightedTextStyle: customTextStyle(
                      fontSize: 25.sp,
                      color: isDark ? whiteColor : blackTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                    normalTextStyle: customTextStyle(
                      fontSize: 25.sp,
                      color: isDark ? whiteColor : greyTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                    fadedTextStyle: customTextStyle(
                      fontSize: 25.sp,
                      color:
                          isDark ? whiteColor : greyTextColor.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                    onTimeChange: (time) {
                      endTime = time;
                    },
                  ),
                  SizedBox(height: 40.h),
                  PrimaryButton(
                    buttonColor: widget.color,
                    buttonText: t.save.tr,
                    onPressed: () {
                      final actualStartTime = DateTime(
                        widget.selectedDay.year,
                        widget.selectedDay.month,
                        widget.selectedDay.day,
                        startTime.hour,
                        startTime.minute,
                      );
                      final actualEndTime = DateTime(
                        widget.selectedDay.year,
                        widget.selectedDay.month,
                        widget.selectedDay.day,
                        endTime.hour,
                        endTime.minute,
                      );

                      if (actualStartTime.isAfter(actualEndTime) ||
                          actualEndTime.difference(actualStartTime) <
                              Duration(minutes: 1)) {
                        showAttentionSnackBar(message: t.startEarlierEnd.tr);
                      } else {
                        Navigator.pop(
                          context,
                          [
                            actualStartTime,
                            actualEndTime,
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
            controller: _tabController,
          ),
        ),
      ],
    );
  }
}

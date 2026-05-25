import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_year/this_year_screen_controller.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class YearPickerWidget extends StatelessWidget {
  YearPickerWidget({Key? key}) : super(key: key);

  final _pageController = PageController();
  final _duration = const Duration(milliseconds: 300);
  final _curve = Curves.bounceIn;
  final time = DateTime.now();
  final List<int> _possibleYearsToChoose = [
    DateTime.now().year,
    DateTime.now().year + 1,
    DateTime.now().year + 2,
    DateTime.now().year + 3,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 22.h),
      decoration: BoxDecoration(
        color: thisYearColor.withOpacity(.1),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 28.w,
            width: 28.w,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _pageController.previousPage(
                duration: _duration,
                curve: _curve,
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: thisYearColor,
              ),
            ),
          ),
          SizedBox(
            height: 28.h,
            width: 90.w,
            child: PageView(
              controller: _pageController,
              physics: const ClampingScrollPhysics(),
              onPageChanged: (indexOfYear) async {
                LoadingOverlay.show(context);
                await Get.find<ThisYearScreenController>()
                    .getThisYearTodos(_possibleYearsToChoose[indexOfYear]);
                Get.find<ThisYearScreenController>().lastFocusedYear =
                    _possibleYearsToChoose[indexOfYear];
                LoadingOverlay.hide();
              },
              children: List.generate(
                _possibleYearsToChoose.length,
                (index) {
                  return Center(
                    child: Text(
                      "${_possibleYearsToChoose[index]}",
                      style: customTextStyle(
                        fontSize: 16.sp,
                        color: thisYearColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 28.w,
            width: 28.w,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _pageController.nextPage(
                duration: _duration,
                curve: _curve,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: thisYearColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

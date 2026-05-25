import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/style/colors.dart';

class ChooseMonthDialog extends StatefulWidget {
  const ChooseMonthDialog({Key? key}) : super(key: key);

  static Future show({required BuildContext context}) =>
      showDialog(context: context, builder: (_) => const ChooseMonthDialog());

  @override
  State<ChooseMonthDialog> createState() => _ChooseMonthDialogState();
}

class _ChooseMonthDialogState extends State<ChooseMonthDialog> {
  final PageController _pageController = PageController();
  late final FixedExtentScrollController _scrollController;
  int currentMonth = DateTime.now().month - 1;
  final allMonths = <Widget>[];
  final years = <Widget>[];
  int currentYear = DateTime.now().year;

  void _populateMonth() {
    for (int i = 1; i < 13; i++) {
      allMonths.add(
        Text(
          DateFormat.MMMM(Get.locale?.languageCode)
              .format(DateTime(DateTime.now().year, i, 1)),
        ),
      );
    }
  }

  void _populateYear() {
    for (int i = 0; i < 4; i++) {
      years.add(
        Center(
          child: Text(
            "${currentYear + i}",
            style: customTextStyle(
              fontSize: 16.sp,
              color: thisMonthColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (currentMonth == 11) {
      currentYear = currentYear + 1;
      currentMonth = 0;
      _scrollController = FixedExtentScrollController(initialItem: 0);
    } else {
      _scrollController =
          FixedExtentScrollController(initialItem: DateTime.now().month);
      currentMonth++;
    }
    _populateMonth();
    _populateYear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      content: Container(
        decoration: BoxDecoration(
          color: isDark ? darkBgColor : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            Text(
              months.tr,
              style: customTextStyle(
                fontSize: 16.sp,
                color: isDark ? whiteColor : blackTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceIn,
                  ),
                  child: SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: thisMonthColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.h,
                  width: 60.w,
                  child: PageView(
                    physics: const BouncingScrollPhysics(),
                    controller: _pageController,
                    children: years,
                  ),
                ),
                GestureDetector(
                  onTap: () => _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceIn,
                  ),
                  child: SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: thisMonthColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            SizedBox(
              height: 150.h,
              width: 200.w,
              child: CupertinoPicker(
                itemExtent: 30,
                onSelectedItemChanged: (index) {
                  currentMonth = index;
                },
                scrollController: _scrollController,
                children: allMonths,
                squeeze: 1,
                selectionOverlay: Container(
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                          horizontal: BorderSide(
                              width: 0.sp,
                              color: isDark ? whiteColor : dividerColor))),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: PrimaryButton(
                buttonColor: thisMonthColor,
                buttonText: save.tr,
                onPressed: () {
                  debugPrint(
                      "chosen month is $currentMonth - ${_pageController.page}");
                  int _month = currentMonth + 1;
                  int _year = _pageController.page == 0.0
                      ? DateTime.now().year
                      : DateTime.now().year + _pageController.page!.toInt();
                  debugPrint("final date time ${DateTime(_year, _month)}");
                  if (_year == DateTime.now().year &&
                      _month <= DateTime.now().month) {
                    Get.defaultDialog(
                        title: startDateCannotBeEarlier.tr,
                        middleText: chooseDifferentDate.tr);
                  } else {
                    Navigator.of(context).pop(DateTime(_year, _month));
                  }
                },
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}

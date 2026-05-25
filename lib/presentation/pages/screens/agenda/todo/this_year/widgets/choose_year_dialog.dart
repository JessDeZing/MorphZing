import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/style/colors.dart';

class ChooseYearDialog extends StatefulWidget {
  const ChooseYearDialog({Key? key}) : super(key: key);

  static Future show({required BuildContext context}) =>
      showDialog(context: context, builder: (_) => const ChooseYearDialog());

  @override
  State<ChooseYearDialog> createState() => _ChooseYearDialogState();
}

class _ChooseYearDialogState extends State<ChooseYearDialog> {
  int _currentIndex = 0;
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 0);
  final time = DateTime.now().year;
  late List<int> years;

  @override
  void initState() {
    super.initState();
    years = [time + 1, time + 2, time + 3];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      content: Container(
        //height: 200.h,
        decoration: BoxDecoration(
          color: isDark ? darkBgColor : Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16.h),
            Text(
              year.tr,
              style: customTextStyle(
                fontSize: 16.sp,
                color: isDark ? whiteColor : blackTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              height: 150.h,
              width: 200.w,
              child: CupertinoPicker(
                itemExtent: 30,
                onSelectedItemChanged: (index) {
                  _currentIndex = index;
                },
                scrollController: _scrollController,
                children: [for (var item in years) Text("$item")],
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
                buttonColor: thisYearColor,
                buttonText: save.tr,
                onPressed: () {
                  int _year = years[_currentIndex];
                  debugPrint("final date time ${DateTime(_year)}");
                  Navigator.of(context).pop(DateTime(_year));
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

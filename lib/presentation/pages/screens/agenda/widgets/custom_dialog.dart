import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';

class CustomDialogs extends StatelessWidget {
  const CustomDialogs({
    Key? key,
    required this.title,
    required this.leftButton,
    required this.rightButton,
    required this.onPressLeftButton,
    required this.onPressRightButton,
    this.subtitle,
  }) : super(key: key);

  final VoidCallback onPressLeftButton;
  final VoidCallback onPressRightButton;
  final String title;
  final String? subtitle;
  final String leftButton;
  final String rightButton;

  static Future show({
    required BuildContext context,
    required String title,
    required VoidCallback onPressLeftButton,
    required VoidCallback onPressRightButton,
    String? subtitle,
    String? leftButton,
    String? rightButton,
  }) async {
    await showDialog(
        context: context,
        builder: (_) => CustomDialogs(
              title: title,
              leftButton: leftButton ?? cancel.tr,
              rightButton: rightButton ?? submit.tr,
              subtitle: subtitle,
              onPressLeftButton: onPressLeftButton,
              onPressRightButton: onPressRightButton,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.w)),
      ),
      content: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: customTextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).textTheme.bodyMedium?.color ??
                      blackTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: customTextStyle(
                    fontSize: 12.sp,
                    color: Theme.of(context).textTheme.bodyMedium?.color ??
                        blackTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
            SizedBox(height: 39.h),
            const Divider(
              color: dividerColor,
              height: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: onPressLeftButton,
                  child: Text(
                    leftButton,
                    style: customTextStyle(
                      fontSize: 18.sp,
                      color: errorColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 53.h,
                  child: const VerticalDivider(
                    color: dividerColor,
                  ),
                ),
                GestureDetector(
                  onTap: onPressRightButton,
                  child: Text(
                    rightButton,
                    style: customTextStyle(
                      fontSize: 18.sp,
                      color: blueColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

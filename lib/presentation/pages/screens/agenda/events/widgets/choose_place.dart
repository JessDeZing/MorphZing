import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';

class ChoosePlace extends StatelessWidget {
  final TextEditingController placeController;
  final bool absorb;

  const ChoosePlace({
    Key? key,
    required this.placeController,
    this.absorb = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          place.tr,
          style: customTextStyle(
            fontSize: 15.sp,
            color: isDark ? whiteColor : blackTextColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: isDark ? darkBgColor : bgColor,
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
          ),
          child: TextField(
            controller: placeController,
            readOnly: absorb,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: selectAddress.tr,
              hintStyle: customTextStyle(
                fontSize: 15.sp,
                color: isDark ? whiteColor : greyTextColor,
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

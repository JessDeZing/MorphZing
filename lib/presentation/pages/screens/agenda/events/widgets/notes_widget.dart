import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';

class NotesWidget extends StatelessWidget {
  final TextEditingController notesController;
  final bool absorb;

  const NotesWidget({
    Key? key,
    required this.notesController,
    required this.absorb,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description.tr,
            style: customTextStyle(
              fontSize: 15.sp,
              color: isDark ? whiteColor : blackTextColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: notesController,
            maxLines: 4,
            maxLength: 2000,
            textCapitalization: TextCapitalization.sentences,
            readOnly: absorb,
            style: customTextStyle(
              fontSize: 15.sp,
              color: isDark ? whiteColor : blackTextColor,
              fontWeight: FontWeight.w400,
            ).copyWith(height: (21 / 14).sp),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? darkBgColor : bgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.w)),
                borderSide: BorderSide.none,
              ),
              counterText: "",
              hintText: pleaseEnterDescription.tr,
              hintStyle: customTextStyle(
                fontSize: 15.sp,
                color: isDark ? whiteColor : greyTextColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ]);
  }
}

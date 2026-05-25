import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/dashboard/advice.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/self_care/widgets/advice_container.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/utils/style/colors.dart';

class AdvicesList extends StatelessWidget {
  final List<Advice> adviceList;

  const AdvicesList({
    Key? key,
    required this.adviceList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return adviceList.isEmpty
        ? Center(
      child: Text(
        noSuggestionsForThisDay.tr,
        style: customTextStyle(
          fontSize: 16.sp,
          color: greyTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    )
        : ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (_, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                CommonFunctions.getCorrectEventQuantity(
                    adviceList.length),
                style: customTextStyle(
                  fontSize: 12.sp,
                  color: greyTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16.h),
              AdviceContainer(advice: adviceList[index]),
            ],
          );
        }
        return AdviceContainer(advice: adviceList[index]);
      },
      itemCount: adviceList.length,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/participants/single_stack_item.dart';
import 'package:morphzing/utils/style/colors.dart';

class StackedImages extends StatelessWidget {
  final List<Widget> listOfInviteeImages;
  final Color? color;
  final bool inEditMode;

  const StackedImages({
    Key? key,
    required this.listOfInviteeImages,
    required this.color,
    this.inEditMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listLength =
        listOfInviteeImages.length > 6 ? 6 : listOfInviteeImages.length;
    return SizedBox(
      height: 40.w,
      child: listLength == 0
          ? Align(
              alignment: Alignment.centerLeft,
              child: Text(
                inEditMode ? noInviteesAdded.tr : selectInvitees.tr,
                style: customTextStyle(
                  fontSize: 15.sp,
                  color: greyTextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          : Stack(
              children: [
                for (int i = 0; i < listLength; i++) ...[
                  Positioned(
                    left: i * 33.w,
                    child: listOfInviteeImages.length > 6 && i == listLength - 1
                        ? _exceedingNumberWidget(listOfInviteeImages.length - 5)
                        : SingleStackItem(child: listOfInviteeImages[i]),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _exceedingNumberWidget(int exceedingNumber) {
    return Container(
      height: 40.w,
      width: 40.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40.w)),
        border: Border.all(
          color: dividerColor,
          width: 2,
        ),
        color: color,
        gradient: color == null ? specialOccasionGradient : null,
      ),
      child: Center(
        child: Text(
          '+$exceedingNumber',
          style: customTextStyle(
            fontSize: 13.sp,
            color: whiteColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/presentation/widgets/primary_button.dart';
import 'package:morphzing/utils/style/colors.dart';

class BottomSheetBottomButtons extends StatelessWidget {
  const BottomSheetBottomButtons({
    Key? key,
    required this.buttonColor,
    required this.onPressSave,
    required this.onPressDelete,
    required this.showDeleteButton,
    required this.showSaveButton,
    required this.text,
  }) : super(key: key);
  final Color? buttonColor;
  final VoidCallback onPressSave;
  final VoidCallback onPressDelete;
  final bool showDeleteButton;
  final bool showSaveButton;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showDeleteButton) ...[
          Flexible(
            flex: 1,
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.w))),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  CustomDialogs.show(
                    context: context,
                    title: text,
                    onPressLeftButton: () => Navigator.pop(context),
                    onPressRightButton: onPressDelete,
                    leftButton: no.tr,
                    rightButton: yes.tr,
                  );
                },
                child: Ink(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 13.h,
                  ),
                  color: errorColor.withOpacity(.15),
                  child: SvgPicture.asset("assets/icons/delete.svg"),
                ),
              ),
            ),
          ),
          if (showSaveButton) SizedBox(width: 10.w),
        ],
        if (showSaveButton) ...[
          Expanded(
            flex: 3,
            child: PrimaryButton(
              buttonColor: buttonColor,
              buttonText: showDeleteButton ? save.tr : create.tr,
              onPressed: onPressSave,
            ),
          ),
        ],
      ],
    );
  }
}

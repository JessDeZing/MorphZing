import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/special_occasions/widgets/gradient_maker.dart';
import 'package:morphzing/utils/style/colors.dart';

class EveryWeekWidget extends StatefulWidget {
  final bool isChosen;
  final Function(List<int>, int) onChooseEveryWeek;
  final Color? color;

  const EveryWeekWidget({
    Key? key,
    required this.isChosen,
    required this.onChooseEveryWeek,
    required this.color,
  }) : super(key: key);

  @override
  State<EveryWeekWidget> createState() => _EveryWeekWidgetState();
}

class _EveryWeekWidgetState extends State<EveryWeekWidget> {
  final textController = TextEditingController(text: '1');
  int _numberOfWeeksToRepeat = 1;
  List<int> idOfWeekDays = const [7, 1, 2, 3, 4, 5, 6];
  List<int> chosenWeekDays = [];
  List<String> initialsOfWeekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  List<String> initialsOfWeekDaysSpanish = ['S', 'D', 'L', 'M', 'M', 'J', 'V'];

  void _chooseWeekDay(int id) {
    if (chosenWeekDays.contains(id)) {
      chosenWeekDays.remove(id);
    } else {
      chosenWeekDays.add(id);
    }
    widget.onChooseEveryWeek(chosenWeekDays, _numberOfWeeksToRepeat);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 15.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? darkBgColor : bgColor,
        borderRadius: BorderRadius.all(Radius.circular(12.w)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                everyWeek.tr,
                style: customTextStyle(
                  fontSize: 15.sp,
                  color: isDark ? whiteColor : blackTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                height: 20.w,
                width: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isChosen ? widget.color : whiteColor,
                  gradient: widget.isChosen && widget.color == null
                      ? specialOccasionGradient
                      : null,
                  border: Border.all(
                    color: widget.isChosen
                        ? (widget.color ?? Colors.transparent)
                        : isDark
                            ? whiteColor
                            : dividerColor,
                    width: 1.5.sp,
                  ),
                ),
                child: widget.isChosen
                    ? Container(
                        height: 20.w,
                        width: 20.w,
                        decoration: BoxDecoration(
                          color: widget.color,
                          borderRadius: BorderRadius.all(Radius.circular(20.w)),
                          gradient: widget.color == null
                              ? specialOccasionGradient
                              : null,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/ic_check.svg',
                          color: isDark ? blackTextColor : whiteColor,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          AnimatedSize(
            child: widget.isChosen
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          idOfWeekDays.length,
                          (index) => GestureDetector(
                            onTap: () => _chooseWeekDay(idOfWeekDays[index]),
                            child: widget.color == null
                                ? DecoratedBox(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: whiteColor,
                                      gradient: chosenWeekDays
                                              .contains(idOfWeekDays[index])
                                          ? specialOccasionGradient
                                          : null,
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.all(1.w),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 11.w,
                                        vertical: 7.h,
                                      ),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: whiteColor,
                                      ),
                                      child: chosenWeekDays
                                              .contains(idOfWeekDays[index])
                                          ? GradientMaker(
                                              child: Text(
                                                Get.locale?.languageCode == 'es'
                                                    ? initialsOfWeekDaysSpanish[
                                                        index]
                                                    : initialsOfWeekDays[index],
                                                style: customTextStyle(
                                                  fontSize: 15.sp,
                                                  color: isDark
                                                      ? whiteColor
                                                      : greyTextColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              Get.locale?.languageCode == 'es'
                                                  ? initialsOfWeekDaysSpanish[
                                                      index]
                                                  : initialsOfWeekDays[index],
                                              style: customTextStyle(
                                                fontSize: 15.sp,
                                                color: isDark
                                                    ? whiteColor
                                                    : greyTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 8.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: whiteColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: chosenWeekDays
                                                .contains(idOfWeekDays[index])
                                            ? widget.color!
                                            : whiteColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      Get.locale?.languageCode == 'es'
                                          ? initialsOfWeekDaysSpanish[index]
                                          : initialsOfWeekDays[index],
                                      style: customTextStyle(
                                        fontSize: 15.sp,
                                        color: chosenWeekDays
                                                .contains(idOfWeekDays[index])
                                            ? widget.color!
                                            : isDark
                                                ? whiteColor
                                                : greyTextColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            duration: 300.milliseconds,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/core/enum/search_type_enum.dart';
import 'package:morphzing/utils/style/colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final SearchTypeEnum searchTypeEnum;

  const FilterBottomSheet({Key? key, required this.searchTypeEnum})
      : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(10),
      height: 0.6.sh,
      decoration: BoxDecoration(
          color: isDark ? darkBgColor : whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Filter',
                    style: staticTextStyle(
                      20,
                      isDark ? Colors.white : blackTextColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back(result: SearchTypeEnum.task);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isDark ? darkBorderColor : bgColor,
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.clear,
                        size: 18,
                        color: isDark ? Colors.white : blackTextColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          _initItem(
              searchTypeEnum: SearchTypeEnum.task,
              iconPath: 'assets/icons/filter_task.svg',
              title: 'Tasks',
              onPressedItem: () {
                Get.back(result: SearchTypeEnum.task);
              }),
          SizedBox(height: 8),
          _initItem(
              searchTypeEnum: SearchTypeEnum.event,
              iconPath: 'assets/icons/filter_event.svg',
              title: 'Events',
              onPressedItem: () {
                Get.back(result: SearchTypeEnum.event);
              }),
          SizedBox(height: 8),
          _initItem(
              searchTypeEnum: SearchTypeEnum.journey,
              iconPath: 'assets/icons/new_filter_journey.svg',
              title: 'Journey',
              onPressedItem: () {
                Get.back(result: SearchTypeEnum.journey);
              }),
          SizedBox(height: 8),
          _initItem(
              searchTypeEnum: SearchTypeEnum.note,
              iconPath: 'assets/icons/filter_note.svg',
              title: 'Note',
              onPressedItem: () {
                Get.back(result: SearchTypeEnum.note);
              }),
          SizedBox(height: 10),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Get.back(result: SearchTypeEnum.initial);
            },
            child: Text('Clear filter'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? darkBorderColor : bgColor,
              foregroundColor: errorColor,
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _initItem({
    required SearchTypeEnum searchTypeEnum,
    required String iconPath,
    required String title,
    required VoidCallback onPressedItem,
  }) {
    bool isChosen = searchTypeEnum == widget.searchTypeEnum;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isChosen
          ? blueColor
          : isDark
              ? darkBorderColor
              : bgColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          onPressedItem();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Container(
            padding: const EdgeInsets.all(14),
            height: 50,
            width: Get.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: SvgPicture.asset(
                    iconPath,
                    color: isChosen
                        ? whiteColor
                        : isDark
                            ? Colors.white
                            : blackTextColor,
                  ),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: staticTextStyle(
                      17,
                      isChosen
                          ? whiteColor
                          : isDark
                              ? Colors.white
                              : blackTextColor,
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.forward,
                  size: 20,
                  color: isChosen
                      ? whiteColor
                      : isDark
                          ? Colors.white
                          : blackTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

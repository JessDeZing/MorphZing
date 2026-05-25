import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/dashboard/advice.dart';
import 'package:morphzing/utils/style/colors.dart';

class AdviceContainer extends StatelessWidget {
  final Advice advice;

  const AdviceContainer({
    Key? key,
    required this.advice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: selfCareColor,
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              advice.name,
              style: customTextStyle(
                fontSize: 15.sp,
                color: whiteColor,
                fontWeight: FontWeight.w500,
                textDecoration: advice.status
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

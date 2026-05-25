import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:morphzing/utils/style/colors.dart';

class SingleStackItem extends StatelessWidget {
  final Widget child;

  const SingleStackItem({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.w,
      width: 40.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40.w)),
        border: Border.all(
          color: dividerColor,
          width: 2,
        ),
      ),
      child: child,
    );
  }
}

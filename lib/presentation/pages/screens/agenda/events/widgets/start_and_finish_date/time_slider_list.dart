import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class TimeSliderList extends StatelessWidget {
  final List<int> timeFrame;

  const TimeSliderList({
    Key? key,
    required this.timeFrame
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400.h,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: ItemScrollPhysics(itemHeight: 60),
        itemCount: timeFrame.length,
        itemBuilder: (_, index) {
          return SizedBox(height: 100.h, child: Text('${timeFrame[index]}'),);
        },
      ),
    );
  }
}

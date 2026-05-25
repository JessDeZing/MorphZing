import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HeaderForCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final Color color;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;

  const HeaderForCalendar({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat(
      "MMMM yyyy",
      Get.locale?.languageCode,
    ).format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            child: Icon(
              Icons.chevron_left,
              color: color,
            ),
            onTap: onLeftArrowTap,
          ),
          Text(
            headerText,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            child: Icon(
              Icons.chevron_right,
              color: color,
            ),
            onTap: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}

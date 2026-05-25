import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/presentation/pages/screens/journal/journey_screen.dart';
import 'package:morphzing/presentation/widgets/journal/journal_info_widget.dart';
import 'package:morphzing/utils/style/colors.dart';

class JournalCalendarWidget extends StatelessWidget {
  final DateTime dateTime;
  final VoidCallback onPressedDateTime;

  const JournalCalendarWidget(
      {Key? key, required this.dateTime, required this.onPressedDateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      //margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: isDark
            ? null
            : Border.all(
                width: 1,
                color: greyTextColor.withOpacity(0.3),
              ),
        color: isDark
            ? Colors.black.withOpacity(0.7)
            : whiteColor.withOpacity(0.7),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat.jm().format(dateTime),
                style: staticTextStyle(
                  12,
                  isDark ? Colors.white : greyTextColor,
                ),
              ),
              Text(
                '${DateFormat.MMMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)}',
                style: staticTextStyle(
                  16,
                  isDark ? Colors.white : blackTextColor,
                ),
              ),
            ],
          ),
          // const Spacer(),
          // Padding(
          //   padding: const EdgeInsets.only(right: 10.0),
          //   child: SizedBox(
          //     width: 40,
          //     height: 40,
          //     child: IconButton(
          //       onPressed: () {
          //         onPressedDateTime();
          //       },
          //       icon: const Icon(
          //         Icons.event_note,
          //         color: blueColor,
          //         size: 28,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

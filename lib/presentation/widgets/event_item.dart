import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/utils/style/colors.dart';

class EventItem extends StatelessWidget {
  final Event eventItem;
  final VoidCallback onPressedItem;

  const EventItem({
    Key? key,
    required this.eventItem,
    required this.onPressedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? bgColor = eventItem.getBgColor();
    return InkWell(
      onTap: () => onPressedItem(),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          gradient: bgColor == null ? specialOccasionGradient : null,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    eventItem.eventName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  '${DateFormat.MMMEd().format(eventItem.startTime!)} - ${DateFormat.MMMEd().format(eventItem.endTime!)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: whiteColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '${eventItem.notes}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: whiteColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

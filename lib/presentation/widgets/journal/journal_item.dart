import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/utils/style/colors.dart';

class JournalItem extends StatelessWidget {
  final JournalModel journalItem;
  final VoidCallback onPressedItem;

  const JournalItem({
    Key? key,
    required this.journalItem,
    required this.onPressedItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? greyTextColor : bgColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => onPressedItem(),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E().format(journalItem.journeyTime!),
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00C9BC),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    DateFormat.d().format(journalItem.journeyTime!),
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF00C9BC),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    DateFormat.jm().format(journalItem.journeyTime!),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF00C9BC),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      journalItem.noteName,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : blackTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${journalItem.description}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white : hintTextColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              journalItem.images != null && journalItem.images!.isNotEmpty
                  ? SizedBox(
                      width: 60,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: Image.network(
                          journalItem.images?[0].imageUrl ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

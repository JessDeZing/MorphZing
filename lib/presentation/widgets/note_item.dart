import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/journal/note.dart';
import 'package:morphzing/utils/style/colors.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;
  final VoidCallback? onPinPressed;
  final VoidCallback onDoublePressed;
  final bool isPinned;

  const NoteItem({
    Key? key,
    required this.note,
    required this.onPressed,
    required this.onLongPressed,
    this.onPinPressed,
    this.isPinned = false,
    required this.onDoublePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        onPressed();
      },
      onDoubleTap: () {
        onDoublePressed();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   '${DateFormat.MMMd().format(note.updatedTime!)}, ${DateFormat.y().format(note.updatedTime!)}  ${DateFormat.jm().format(note.updatedTime!)}',
          //   maxLines: 1,
          //   overflow: TextOverflow.ellipsis,
          // ),
          // 10.verticalSpace,
          Container(
            width: 1.sw,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: note.drawUrl != null
                  ? null
                  : Border.all(width: 1, color: dividerColor),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: note.drawUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.network(note.drawUrl!),
                        )
                      : Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.noteName ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark ? Colors.white : blackTextColor,
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Expanded(
                                child: Text(
                                  note.noteDescription ?? '',
                                  maxLines: 7,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        isDark ? Colors.white : greyTextColor,
                                    fontFamily: 'SF Pro Display',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                note.isChecked
                    ? Positioned(
                        top: 12,
                        left: 12,
                        child: SvgPicture.asset('assets/icons/checked.svg'),
                      )
                    : const SizedBox(),
                if (onPinPressed != null && !note.isChecked)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: onPinPressed,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isPinned
                              ? blueColor
                              : Colors.grey.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                note.folderId != null
                    ? Positioned(
                        right: 12,
                        bottom: 12,
                        child: Icon(
                          Icons.folder,
                          color: blueColor,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

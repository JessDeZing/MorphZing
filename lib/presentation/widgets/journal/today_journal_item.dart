import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/presentation/widgets/journal/journal_paint_widget.dart';
import 'package:morphzing/presentation/widgets/journal/multiple_image_widget.dart';
import 'package:morphzing/utils/app_functions.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TodayJournalItem extends StatelessWidget {
  final JournalModel journalItem;
  final String formatTime;
  final VoidCallback onPressedItem;
  final VoidCallback onPressedMore;
  final VoidCallback onPressedPlay;
  final VoidCallback onPressedDoc;
  final Function(double value) onChangeSlider;

  const TodayJournalItem({
    Key? key,
    required this.journalItem,
    required this.onPressedItem,
    required this.onPressedMore,
    required this.formatTime,
    required this.onPressedPlay,
    required this.onPressedDoc,
    required this.onChangeSlider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => onPressedItem(),
      child: Container(
        decoration: BoxDecoration(
            image: journalItem.templateUrl != null
                ? DecorationImage(
                    image: NetworkImage(journalItem.templateUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
            color: isDark ? darkBgColor : whiteColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: Get.width,
              color: isDark ? darkBgColor : whiteColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.event_note,
                        color: blueColor,
                        size: 28,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.jm().format(journalItem.journeyTime!),
                        style: staticTextStyle(
                          12,
                          isDark ? whiteColor : greyTextColor,
                        ),
                      ),
                      Text(
                        '${DateFormat.MMMMd().format(journalItem.journeyTime!)}, ${DateFormat.y().format(journalItem.journeyTime!)}',
                        style: staticTextStyle(
                          16,
                          isDark ? whiteColor : blackTextColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      onPressedMore();
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: blueColor,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Divider(
                height: 1,
                color: greyTextColor,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: isDark
                    ? darkBgColor.withOpacity(0.7)
                    : whiteColor.withOpacity(0.7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    journalItem.noteName,
                    style: TextStyle(
                      color: isDark ? Colors.white : blackTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    journalItem.description ?? '',
                    style: TextStyle(
                      color: isDark ? Colors.white : blackTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (journalItem.images != null && journalItem.images!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: MultipleImageViewWidget(
                  photos: journalItem.images!,
                  isPost: true,
                  onPressed: () {},
                  onMore: () {},
                ),
              ),
            if (journalItem.drawUrl != null) ...[
              8.verticalSpace,
              JournalPaintWidget(
                drawPath: journalItem.drawUrl!,
                loading: false,
                onPressedDelete: () {},
              ),
            ],
            if (journalItem.documentUrl != null) ...[
              ...[
                8.verticalSpace,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _initBgContainer(
                    onPressedItem: () => onPressedDoc(),
                    context: context,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 20,
                        child: Icon(
                          Icons.file_download_outlined,
                          color: isDark ? Colors.white : Colors.white,
                        ),
                      ),
                      title: Text(
                        journalItem.documentName ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      subtitle: Text(
                        journalItem.documentDescription ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF676A8B),
                        ),
                      ),
                      trailing: Text(
                        getFileSizeString(
                            bytes: journalItem.documentSize ?? 0, decimals: 2),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xFF676A8B),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ],
            // if (journalItem.audioUrl != null && journalItem.audioUrl!.isNotEmpty) ...{
            //   ...[
            //     Container(
            //       padding: const EdgeInsets.symmetric(horizontal: 16),
            //       alignment: Alignment.centerRight,
            //       child: Row(
            //         children: [
            //           Column(
            //             children: [
            //               CupertinoButton(
            //                 onPressed: () {
            //                   onPressedPlay();
            //                 },
            //                 padding: const EdgeInsets.all(0),
            //                 child: CircleAvatar(
            //                   radius: 16,
            //                   child: Icon(
            //                     journalItem.isPlaying ? Icons.pause : Icons.play_arrow,
            //                   ),
            //                 ),
            //               ),
            //               const SizedBox(height: 4),
            //               Text(formatTime),
            //             ],
            //           ),
            //           Expanded(
            //             child: Slider(
            //               min: 0,
            //               max: journalItem.duration.inSeconds.toDouble(),
            //               value: journalItem.duration.inSeconds.toDouble(),
            //               onChanged: (double value) {
            //                 onChangeSlider(value);
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ]
            // },
            if (journalItem.location != null &&
                journalItem.location!.isNotEmpty) ...[
              8.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: _initBgContainer(
                  context: context,
                  child: Text(
                    journalItem.location!,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: blueColor,
                      decoration: isValidUrl(journalItem.location!)
                          ? TextDecoration.underline
                          : null,
                    ),
                  ),
                  onPressedItem: isValidUrl(journalItem.location!)
                      ? () => launchUrl(Uri.parse(journalItem.location!))
                      : null,
                ),
              )
            ],
            if (journalItem.webLink != null &&
                journalItem.webLink!.isNotEmpty) ...[
              8.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: _initBgContainer(
                  context: context,
                  child: Text(
                    journalItem.webLink!,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: blueColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onPressedItem: () =>
                      launchUrl(Uri.parse(journalItem.webLink!)),
                ),
              )
            ],
            32.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _initBgContainer({
    required Widget child,
    required VoidCallback? onPressedItem,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: isDark ? darkBgColor : whiteColor.withOpacity(0.7),
      child: InkWell(
        onTap: onPressedItem != null ? () => onPressedItem() : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: greyTextColor.withOpacity(0.3),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

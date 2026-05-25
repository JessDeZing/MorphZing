import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';

class TravelEvent extends StatelessWidget {
  final Event event;
  final List<String> pictures;
  final Future Function() onRefreshCalendar;

  const TravelEvent({
    Key? key,
    required this.event,
    required this.onRefreshCalendar,
    required this.pictures,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: travelColor,
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: event.isParticipant
                    ? SvgPicture.asset(
                        'assets/icons/participant_event_icon.svg')
                    : Checkbox(
                        value: event.isEventDone,
                        onChanged: (value) async {
                          if (!event.isEventDone) {
                            CustomDialogs.show(
                              leftButton: no.tr,
                              rightButton: yes.tr,
                              context: context,
                              title: completeEvent.tr,
                              onPressLeftButton: () => Navigator.pop(context),
                              onPressRightButton: () async {
                                LoadingOverlay.show(context);
                                await Get.find<AgendaController>()
                                    .editEventStatus(
                                  eventId: event.id!,
                                  date: event.date ??
                                      DateFormat("yyyy-MM-dd")
                                          .format(event.startTime!),
                                  status: true,
                                );
                                await onRefreshCalendar();
                                LoadingOverlay.hide();
                                Navigator.pop(context);
                              },
                            );
                          } else {
                            showAttentionSnackBar(
                                message: eventStatusAlreadyChanged.tr);
                          }
                        },
                        side: BorderSide(
                          color: Theme.of(context).cardColor,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.w))),
                      ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  event.eventName,
                  style: customTextStyle(
                    fontSize: 15.sp,
                    color: Theme.of(context).textTheme.bodyLarge?.color ??
                        blackTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                event.startTime == null
                    ? noStartTimeSpecified.tr
                    : CommonFunctions.getCorrectStartTimeOfEvent(
                        event.startTime!),
                style: customTextStyle(
                  fontSize: 15.sp,
                  color: Theme.of(context).textTheme.bodyLarge?.color ??
                      blackTextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          if (pictures.isNotEmpty ||
              (event.notes != null && event.notes!.isNotEmpty)) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 30.w),
                Expanded(
                    child: Text(
                  event.notes ?? '',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: customTextStyle(
                    fontSize: 12.sp,
                    color: Theme.of(context).textTheme.bodyLarge?.color ??
                        blackTextColor,
                    fontWeight: FontWeight.w400,
                  ).copyWith(height: 15.6.h / 12.sp),
                )),
                if (pictures.isNotEmpty) ...[
                  const SizedBox(width: 10),
                  Container(
                    height: 65.w,
                    width: 65.w,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.w))),
                    child: FadeInImage(
                      fadeInDuration: 100.milliseconds,
                      fadeOutDuration: 100.milliseconds,
                      fit: BoxFit.fill,
                      placeholderFit: BoxFit.cover,
                      placeholder: const AssetImage(
                          "assets/images/placeholder_photo.jpg"),
                      image: NetworkImage(pictures.first),
                      //image: AssetImage('assets/images/25721.jpeg'),
                      imageErrorBuilder: (_, __, ___) => Image.asset(
                        "assets/images/placeholder_photo.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ]
        ],
      ),
    );
  }
}

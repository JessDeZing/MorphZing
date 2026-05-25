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

class ListTileEvent extends StatelessWidget {
  final Event event;
  final Color? color;
  final Future Function() onRefreshCalendar;
  final Gradient? gradient;

  const ListTileEvent({
    Key? key,
    required this.color,
    required this.event,
    required this.onRefreshCalendar,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: gradient != null ? null : color,
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
        gradient: gradient,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: event.isParticipant
                ? SvgPicture.asset('assets/icons/participant_event_icon.svg')
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
                            await Get.find<AgendaController>().editEventStatus(
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
                        borderRadius: BorderRadius.all(Radius.circular(6.w))),
                  ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              event.eventName,
              style: customTextStyle(
                fontSize: 15.sp,
                color: whiteColor,
                fontWeight: FontWeight.w500,
                textDecoration: event.isEventDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            event.startTime == null
                ? noStartTimeSpecified.tr
                : CommonFunctions.getCorrectStartTimeOfEvent(event.startTime!),
            style: customTextStyle(
              fontSize: 15.sp,
              color: whiteColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

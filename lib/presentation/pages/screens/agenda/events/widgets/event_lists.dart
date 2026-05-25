import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/create_or_edit_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/list_tile_event.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/model/event_with_participants.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/participant_event_details.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class EventLists extends StatelessWidget {
  final Color? color;
  final RxList<EventWithParticipants> eventList;
  final Gradient? gradient;
  final Future Function() onRefreshCalendar;

  const EventLists({
    Key? key,
    required this.color,
    required this.eventList,
    this.gradient,
    required this.onRefreshCalendar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      return eventList.isEmpty
          ? Center(
              child: Text(
                noEventsYet.tr,
                style: customTextStyle(
                  fontSize: 16.sp,
                  color: isDark ? whiteColor : greyTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (_, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        CommonFunctions.getCorrectEventQuantity(
                            eventList.length),
                        style: customTextStyle(
                          fontSize: 12.sp,
                          color: isDark ? whiteColor : greyTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () async {
                          if (eventList[index].event.isParticipant) {
                            await ParticipantEventDetails.show(
                              context: context,
                              event: eventList[index].event,
                            );
                            return;
                          }
                          final result =
                              await CreateOrEditBottomSheet.editEvent(
                            context: context,
                            eventWithParticipants: eventList[index],
                            color: color,
                            categoryId: eventList[index].event.categoryId,
                            chosenTime: CommonFunctions.getParsedTime(
                                eventList[index].event.date,
                                eventList[index].event.startTime!)!,
                          );
                          if (result == true) {
                            LoadingOverlay.show(context);
                            await onRefreshCalendar();
                            LoadingOverlay.hide();
                          }
                        },
                        child: ListTileEvent(
                          color: color,
                          event: eventList[index].event,
                          gradient: gradient,
                          onRefreshCalendar: onRefreshCalendar,
                        ),
                      ),
                    ],
                  );
                }
                return GestureDetector(
                  onTap: () async {
                    if (eventList[index].event.isParticipant) {
                      await ParticipantEventDetails.show(
                        context: context,
                        event: eventList[index].event,
                      );
                      return;
                    }
                    final result = await CreateOrEditBottomSheet.editEvent(
                      context: context,
                      eventWithParticipants: eventList[index],
                      color: color,
                      categoryId: eventList[index].event.categoryId,
                      chosenTime: CommonFunctions.getParsedTime(
                          eventList[index].event.date,
                          eventList[index].event.startTime!)!,
                    );
                    if (result == true) {
                      LoadingOverlay.show(context);
                      await onRefreshCalendar();
                      LoadingOverlay.hide();
                    }
                  },
                  child: ListTileEvent(
                    color: color,
                    event: eventList[index].event,
                    gradient: gradient,
                    onRefreshCalendar: onRefreshCalendar,
                  ),
                );
              },
              itemCount: eventList.length,
            );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/travel_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/widgets/travel_event.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/create_or_edit_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/custom_calendar.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/participant_event_details.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class TravelScreen extends StatelessWidget {
  const TravelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TravelController();
    final agenda = Get.find<AgendaController>().listOfAgendaNames[2];
    return Scaffold(
      appBar: StaticAppBar.searchAppBar(
        context,
        agenda.name,
        false,
        '',
        color: travelColor,
      ),
      body: GetX<TravelController>(
        init: controller,
        builder: (controller) {
          return controller.pageLoading.value
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Column(
                  children: [
                    CustomCalendar(
                      firstDay: controller.startDay,
                      lastDay: controller.endDay,
                      selectedDay: controller.selectedDay,
                      focusedDay: controller.focusedDay,
                      changeFocusedDay: controller.changeFocusedDay,
                      pageController: controller.pageController,
                      onPageChanged: (date) {
                        controller.focusedDay.value = date;
                      },
                      primaryColor: travelColor,
                    ),
                    Expanded(
                      child: controller.travelEventsList.isEmpty
                          ? Center(
                              child: Text(
                                noEventsYet.tr,
                                style: customTextStyle(
                                  fontSize: 16.sp,
                                  color: greyTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 10.h),
                              itemCount: controller.travelEventsList.length,
                              itemBuilder: (_, index) {
                                if (index == 0) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        CommonFunctions.getCorrectEventQuantity(
                                            controller.travelEventsList.length),
                                        style: customTextStyle(
                                          fontSize: 12.sp,
                                          color: greyTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                      GestureDetector(
                                        onTap: () async {
                                          if (controller.travelEventsList[index]
                                              .event.isParticipant) {
                                            await ParticipantEventDetails.show(
                                                context: context,
                                                event: controller
                                                    .travelEventsList[index]
                                                    .event,
                                                travelPictures: controller
                                                        .eventImages[
                                                    controller
                                                        .travelEventsList[index]
                                                        .event
                                                        .id!]);
                                            return;
                                          }
                                          final result =
                                              await CreateOrEditBottomSheet
                                                  .editEvent(
                                            context: context,
                                            isTravel: true,
                                            eventWithParticipants: controller
                                                .travelEventsList[index],
                                            color: travelColor,
                                            categoryId: controller
                                                .travelEventsList[index]
                                                .event
                                                .categoryId,
                                            travelPictures: controller
                                                        .eventImages[
                                                    controller
                                                        .travelEventsList[index]
                                                        .event
                                                        .id!] ??
                                                [],
                                            chosenTime:
                                                controller.selectedDay.value,
                                          );
                                          if (result == true) {
                                            LoadingOverlay.show(context);
                                            await controller.getTravelEvents(
                                              startTime:
                                                  controller.selectedDay.value,
                                              endTime:
                                                  controller.selectedDay.value,
                                            );
                                            LoadingOverlay.hide();
                                          }
                                        },
                                        child: TravelEvent(
                                          event: controller
                                              .travelEventsList[index].event,
                                          onRefreshCalendar: () async {
                                            await controller.getTravelEvents(
                                              startTime:
                                                  controller.selectedDay.value,
                                              endTime:
                                                  controller.selectedDay.value,
                                            );
                                          },
                                          pictures: controller.eventImages[
                                                  controller
                                                      .travelEventsList[index]
                                                      .event
                                                      .id!] ??
                                              [],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return GestureDetector(
                                  onTap: () async {
                                    if (controller.travelEventsList[index].event
                                        .isParticipant) {
                                      await ParticipantEventDetails.show(
                                          context: context,
                                          event: controller
                                              .travelEventsList[index].event,
                                          travelPictures:
                                              controller.eventImages[controller
                                                  .travelEventsList[index]
                                                  .event
                                                  .id!]);
                                      return;
                                    }
                                    final result =
                                        await CreateOrEditBottomSheet.editEvent(
                                      context: context,
                                      eventWithParticipants:
                                          controller.travelEventsList[index],
                                      color: travelColor,
                                      isTravel: true,
                                      categoryId: controller
                                          .travelEventsList[index]
                                          .event
                                          .categoryId,
                                      travelPictures: controller.eventImages[
                                              controller.travelEventsList[index]
                                                  .event.id!] ??
                                          [],
                                      chosenTime: controller.selectedDay.value,
                                    );
                                    if (result == true) {
                                      LoadingOverlay.show(context);
                                      await controller.getTravelEvents(
                                        startTime: controller.selectedDay.value,
                                        endTime: controller.selectedDay.value,
                                      );
                                      LoadingOverlay.hide();
                                    }
                                  },
                                  child: TravelEvent(
                                    event: controller
                                        .travelEventsList[index].event,
                                    onRefreshCalendar: () async {
                                      await controller.getTravelEvents(
                                        startTime: controller.selectedDay.value,
                                        endTime: controller.selectedDay.value,
                                      );
                                    },
                                    pictures: controller.eventImages[controller
                                            .travelEventsList[index]
                                            .event
                                            .id!] ??
                                        [],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
        },
      ),
      floatingActionButton: CustomBottomBar.agendaFloatingActionButton(
        context: context,
        color: travelColor,
        onPressed: () async {
          final result = await CreateOrEditBottomSheet.createEvent(
            context: context,
            color: travelColor,
            isTravel: true,
            categoryId: agenda.id,
            chosenTime: controller.selectedDay.value,
          );
          if (result == true) {
            LoadingOverlay.show(context);
            final controller = Get.find<TravelController>();
            await controller.getTravelEvents(
              startTime: controller.selectedDay.value,
              endTime: controller.selectedDay.value,
            );
            LoadingOverlay.hide();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomBar.customBottomBar(context),
    );
  }
}

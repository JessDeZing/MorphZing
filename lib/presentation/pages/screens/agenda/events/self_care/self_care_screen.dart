import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/self_care/self_care_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/self_care/widgets/advice_container.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/self_care/widgets/advices_list.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/create_or_edit_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/custom_calendar.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/event_lists.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/model/event_with_participants.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class SelfCareScreen extends StatelessWidget {
  const SelfCareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = SelfCareController();
    final agenda = Get.find<AgendaController>().listOfAgendaNames[3];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: StaticAppBar.searchAppBar(
          context,
          agenda.name,
          false,
          '',
          color: selfCareColor,
        ),
        body: GetX<SelfCareController>(
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
                        primaryColor: selfCareColor,
                        changeFocusedDay: controller.changeFocusedDay,
                        pageController: controller.pageController,
                        onPageChanged: (date) {
                          controller.focusedDay.value = date;
                        },
                      ),
                      _typeBar(controller, context),
                    ],
                  );
          },
        ),
        floatingActionButton: CustomBottomBar.agendaFloatingActionButton(
          context: context,
          color: selfCareColor,
          onPressed: () async {
            final result = await CreateOrEditBottomSheet.createEvent(
              context: context,
              color: selfCareColor,
              categoryId: agenda.id,
              chosenTime: controller.selectedDay.value,
            );
            if (result == true) {
              LoadingOverlay.show(context);
              final controller = Get.find<SelfCareController>();
              await controller.getSelfCareEvents(
                startTime: controller.selectedDay.value,
                endTime: controller.selectedDay.value,
              );
              LoadingOverlay.hide();
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomBar.customBottomBar(context),
      ),
    );
  }

  _typeBar(SelfCareController controller, BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.symmetric(
                horizontal: BorderSide(
                  width: 0,
                  color: dividerColor,
                ),
              ),
            ),
            child: TabBar(
              padding: EdgeInsets.zero,
              indicatorColor: selfCareColor,
              labelColor: selfCareColor,
              labelStyle: const TextStyle(
                color: selfCareColor,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro Display',
                fontSize: 14,
              ),
              unselectedLabelColor: hintTextColor,
              tabs: [
                Tab(
                  text: ownSelfCare.tr,
                ),
                Tab(
                  text: suggestions.tr,
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: TabBarView(
              children: [
                EventLists(
                  color: selfCareColor,
                  eventList: controller.selfCareEventsList,
                  onRefreshCalendar: () async {
                    await controller.getSelfCareEvents(
                      startTime: controller.selectedDay.value,
                      endTime: controller.selectedDay.value,
                    );
                  },
                ),
                AdvicesList(adviceList: controller.adviceList.value.results),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

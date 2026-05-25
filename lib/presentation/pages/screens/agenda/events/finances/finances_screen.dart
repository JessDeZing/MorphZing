import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/finances/finances_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/create_or_edit_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/custom_calendar.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/event_lists.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class FinancesScreen extends StatelessWidget {
  const FinancesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = FinancesController();
    final agenda = Get.find<AgendaController>().listOfAgendaNames[1];
    return Scaffold(
      appBar: StaticAppBar.searchAppBar(
        context,
        agenda.name,
        false,
        '',
        color: financeColor,
      ),
      body: GetX<FinancesController>(
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
                      primaryColor: financeColor,
                      changeFocusedDay: controller.changeFocusedDay,
                      pageController: controller.pageController,
                      onPageChanged: (date) {
                        controller.focusedDay.value = date;
                      },
                    ),
                    Expanded(
                        child: EventLists(
                      color: financeColor,
                      eventList: controller.financeEventsList,
                      onRefreshCalendar: () async {
                        await controller.getFinanceEvents(
                          startTime: controller.selectedDay.value,
                          endTime: controller.selectedDay.value,
                        );
                      },
                    ))
                  ],
                );
        },
      ),
      floatingActionButton: CustomBottomBar.agendaFloatingActionButton(
        context: context,
        color: financeColor,
        onPressed: () async {
          final result = await CreateOrEditBottomSheet.createEvent(
            context: context,
            color: financeColor,
            categoryId: agenda.id,
            chosenTime: controller.selectedDay.value,
          );
          if (result == true) {
            LoadingOverlay.show(context);
            final controller = Get.find<FinancesController>();
            await controller.getFinanceEvents(
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

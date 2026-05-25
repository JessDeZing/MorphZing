import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/special_occasions/special_occasions_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/special_occasions/widgets/gradient_calendar.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/special_occasions/widgets/gradient_maker.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/create_or_edit_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/event_lists.dart';
import 'package:morphzing/presentation/pages/screens/profile/profile_screen.dart';
import 'package:morphzing/presentation/pages/screens/search/search_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';

class SpecialOccasionsScreen extends StatelessWidget {
  const SpecialOccasionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = SpecialOccasionsController();
    final agenda = Get.find<AgendaController>().listOfAgendaNames[4];
    final logic = Get.find<AppController>();
    var profileImage = logic.user?.imageUrl ?? "";
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Theme.of(context).shadowColor.withOpacity(0.26),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const GradientMaker(
              child: Icon(
                Icons.arrow_back_ios,
              ),
            ),
          ),
          backgroundColor:
              Theme.of(context).appBarTheme.backgroundColor ?? bgColor,
          centerTitle: true,
          title: GradientMaker(
            child: Text(
              agenda.name,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () =>
                  Get.toNamed(searchRoute, arguments: SearchScreenParam()),
              child: Center(
                child: SizedBox(
                    height: 30,
                    width: 30,
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Icon(
                        Icons.search,
                        size: 30,
                        color: hintTextColor,
                      ),
                    )),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () => Get.to(const ProfileScreen()),
                child: Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: blueColor),
                    child: (profileImage.isEmpty || profileImage == "null")
                        ? const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 26,
                            ),
                          )
                        : CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(profileImage),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: GetX<SpecialOccasionsController>(
          init: controller,
          builder: (controller) {
            return controller.pageLoading.value
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Column(
                    children: [
                      GradientCalendar(
                        firstDay: controller.startDay,
                        lastDay: controller.endDay,
                        selectedDay: controller.selectedDay,
                        focusedDay: controller.focusedDay,
                        changeFocusedDay: controller.changeFocusedDay,
                        pageController: controller.pageController,
                        onPageChanged: (date) {
                          controller.focusedDay.value = date;
                        },
                      ),
                      Expanded(
                        child: EventLists(
                          color: null,
                          eventList: controller.specialOccasionEventsList,
                          gradient: specialOccasionGradient,
                          onRefreshCalendar: () async {
                            await controller.getSpecialOccasionEvents(
                              startTime: controller.selectedDay.value,
                              endTime: controller.selectedDay.value,
                            );
                          },
                        ),
                      ),
                    ],
                  );
          },
        ),
        floatingActionButton: DecoratedBox(
          decoration: const BoxDecoration(
              gradient: specialOccasionGradient,
              borderRadius: BorderRadius.all(Radius.circular(60))),
          child: FloatingActionButton(
            onPressed: () async {
              final result = await CreateOrEditBottomSheet.createEvent(
                context: context,
                color: null,
                categoryId: agenda.id,
                chosenTime: controller.selectedDay.value,
              );
              if (result == true) {
                LoadingOverlay.show(context);
                final controller = Get.find<SpecialOccasionsController>();
                await controller.getSpecialOccasionEvents(
                  startTime: controller.selectedDay.value,
                  endTime: controller.selectedDay.value,
                );
                LoadingOverlay.hide();
              }
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            child: const Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomBar.customBottomBar(context),
      ),
    );
  }
}

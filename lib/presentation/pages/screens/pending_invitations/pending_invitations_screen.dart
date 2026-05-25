import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/common_functions.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/pending_invitations_controller.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/widgets/agenda_type_container.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/utils/style/colors.dart';

class PendingInvitationsScreen extends StatefulWidget {
  const PendingInvitationsScreen({Key? key}) : super(key: key);

  @override
  State<PendingInvitationsScreen> createState() =>
      _PendingInvitationsScreenState();
}

class _PendingInvitationsScreenState extends State<PendingInvitationsScreen> {
  final controller =
      Get.put<PendingInvitationsController>(PendingInvitationsController());
  final agendaController = Get.find<AgendaController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: StaticAppBar.homeAppBar(
        context,
        'Pending invitations',
        false,
        '',
      ),
      body: Obx(() {
        return controller.pageLoading.value
            ? const Center(child: CircularProgressIndicator.adaptive())
            : agendaController.listOfAgendaNames.isEmpty
                ? Center(
                    child: Text('Failed to fetch agenda names'),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 23),
                        AgendaTypeContainer(
                          name: agendaController.listOfAgendaNames.first.name,
                          //this is where it shows teh events status
                          quantity: CommonFunctions.getCorrectEventQuantity(
                              controller.work.length),
                          color: workColor,
                          nameStyle: customTextStyle(
                            fontSize: 20,
                            color: blackTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                          quantityStyle: customTextStyle(
                            fontSize: 14,
                            color: blackTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                          events: controller.work,
                        ),
                        const SizedBox(height: 16),
                        AgendaTypeContainer(
                          name: agendaController.listOfAgendaNames[1].name,
                          quantity: CommonFunctions.getCorrectEventQuantity(
                              controller.finances.length),
                          color: financeColor,
                          events: controller.finances,
                        ),
                        const SizedBox(height: 16),
                        AgendaTypeContainer(
                          name: agendaController.listOfAgendaNames[2].name,
                          quantity: CommonFunctions.getCorrectEventQuantity(
                              controller.travel.length),
                          color: travelColor,
                          events: controller.travel,
                          travelPictures: controller.travelPictures,
                        ),
                        const SizedBox(height: 16),
                        AgendaTypeContainer(
                          name: agendaController.listOfAgendaNames[3].name,
                          quantity: CommonFunctions.getCorrectEventQuantity(
                              controller.selfCare.length),
                          color: selfCareColor,
                          events: controller.selfCare,
                        ),
                        const SizedBox(height: 16),
                        AgendaTypeContainer(
                          name: agendaController.listOfAgendaNames[4].name,
                          quantity: CommonFunctions.getCorrectEventQuantity(
                              controller.specialOccasions.length),
                          nameStyle: customTextStyle(
                            fontSize: 20,
                            color: blackTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                          quantityStyle: customTextStyle(
                            fontSize: 14,
                            color: blackTextColor,
                            fontWeight: FontWeight.w400,
                          ),
                          events: controller.specialOccasions,
                        ),
                        const SizedBox(height: 16),
                        AgendaTypeContainer(
                          name: agendaController.listOfAgendaNames.last.name,
                          quantity: CommonFunctions.getCorrectEventQuantity(
                              controller.meetUp.length),
                          color: meetUpColor,
                          events: controller.meetUp,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  );
      }),
    );
  }
}

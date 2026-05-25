import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_controller.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/agenda_menu_item.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/presentation/widgets/todo_single_widget.dart';
import 'package:morphzing/utils/style/colors.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final logic = Get.find<AgendaController>();
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      return Scaffold(
        appBar: StaticAppBar.searchAppBar(
          context,
          agenda.tr,
          false,
          '',
        ),
        body: logic.pageLoading.value
            ? const Center(child: CircularProgressIndicator.adaptive())
            : logic.listOfAgendaNames.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                      children: [
                        const SizedBox(height: 20),
                        const TodoSingleWidget(),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Get.toNamed(workRoute),
                                child: AgendaMenuItem(
                                  ctx: context,
                                  iconImage:
                                      'assets/icons/meetup_widget_icon.png',
                                  route: '',
                                  title: logic.listOfAgendaNames.first.name,
                                  bgColor: workColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Get.toNamed(financesRoute),
                                child: AgendaMenuItem(
                                  ctx: context,
                                  iconImage:
                                      'assets/icons/special_occasions_widget_icon.png',
                                  route: '',
                                  title: logic.listOfAgendaNames[1].name,
                                  bgColor: financeColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Get.toNamed(travelRoute),
                                child: AgendaMenuItem(
                                  iconImage:
                                      'assets/icons/selfcare_widget_icon.png',
                                  ctx: context,
                                  route: '',
                                  title: logic.listOfAgendaNames[2].name,
                                  bgColor: travelColor,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Get.toNamed(selfCareRoute),
                                child: AgendaMenuItem(
                                  iconImage:
                                      'assets/icons/travel_widget_icon.png',
                                  ctx: context,
                                  route: '',
                                  title: logic.listOfAgendaNames[3].name,
                                  bgColor: selfCareColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Get.toNamed(specialOccasionRoute),
                                child: AgendaMenuItem(
                                  iconImage:
                                      'assets/icons/finance_widget_icon.png',
                                  ctx: context,
                                  route: '',
                                  title: logic.listOfAgendaNames[4].name,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => Get.toNamed(meetUpRoute),
                                child: AgendaMenuItem(
                                  iconImage:
                                      'assets/icons/work_widget_icon.png',
                                  ctx: context,
                                  route: '',
                                  title: logic.listOfAgendaNames[5].name,
                                  bgColor: meetUpColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
        // floatingActionButton: CustomBottomBar.customFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomBar.customBottomBar(context),
      );
    });
  }
}

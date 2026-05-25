import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/logic/controllers/journal/journal_controller.dart';
import 'package:morphzing/presentation/pages/screens/journal/journey_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalCalendar extends StatefulWidget {
  const JournalCalendar({super.key});

  @override
  State<JournalCalendar> createState() => _JournalCalendarState();
}

class _JournalCalendarState extends State<JournalCalendar> {
  final controller = Get.find<JournalController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(
      () => Scaffold(
        appBar: StaticAppBar.searchAppBar(context, 'Calendar', false, ""),
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color.fromARGB(40, 217, 38, 29),
                  Color.fromARGB(40, 230, 120, 23),
                  Color.fromARGB(40, 255, 247, 1),
                  Color.fromARGB(40, 131, 196, 40),
                  Color.fromARGB(40, 118, 197, 240),
                  Color.fromARGB(40, 143, 30, 120),
                ]),
                borderRadius: BorderRadius.circular(13),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.only(
                top: 18,
                bottom: 18,
                right: 2,
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.now().add((365 * 3).days),
                focusedDay: controller.focusedDay.value,
                headerStyle: const HeaderStyle(
                  formatButtonShowsNext: false,
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                ),
                onDaySelected:
                    (DateTime selectedDay, DateTime focusedDay) async {
                  controller.focusedDay(selectedDay);
                  controller.calendarModel.value.clear();
                  setState(() {});
                  controller.getJournalsCalendar();
                },
                selectedDayPredicate: (DateTime day) {
                  return controller.focusedDay.value.millisecondsSinceEpoch ==
                      day.millisecondsSinceEpoch;
                },
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Color(0xFFA9A9C6),
                  ),
                  weekendStyle: TextStyle(
                    color: Color(0xFFA9A9C6),
                  ),
                ),
                calendarStyle: const CalendarStyle(
                  cellMargin: EdgeInsets.all(10),
                  isTodayHighlighted: true,
                  outsideDaysVisible: false,
                  rangeEndDecoration: BoxDecoration(color: Colors.black),
                  selectedDecoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 217, 38, 29),
                      Color.fromARGB(255, 230, 120, 23),
                      Color.fromARGB(255, 255, 247, 1),
                      Color.fromARGB(255, 131, 196, 40),
                      Color.fromARGB(255, 118, 197, 240),
                      Color.fromARGB(255, 143, 30, 120),
                    ]),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Color(0xFFA9A9C6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Center(
              child: (controller.loading.value)
                  ? const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: CupertinoActivityIndicator(),
                    )
                  : controller.calendarModel.value.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.calendarModel.value.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final model = controller.calendarModel.value[index];

                            return CupertinoButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                debugPrint('MODEL: ${model.toJson()}');
                                Get.to(
                                  JourneyScreen(
                                    isEdit: true,
                                    journeyTime: model.journeyTime,
                                    noteName: model.noteName,
                                    description: model.description,
                                    audio: model.audioUrl,
                                    draw: model.drawUrl,
                                    location: model.location,
                                    webLink: model.webLink,
                                    document: model.documentUrl,
                                    id: model.id,
                                    photos: model.images,
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 244, 244, 244),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat.EEEE().format(controller
                                            .calendarModel
                                            .value[index]
                                            .journeyTime!),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF00C9BC),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        DateFormat.MMMd().format(controller
                                            .calendarModel
                                            .value[index]
                                            .journeyTime!),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF00C9BC),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        DateFormat.jm().format(controller
                                            .calendarModel
                                            .value[index]
                                            .journeyTime!),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF00C9BC),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                      "${controller.calendarModel.value[index].noteName}"),
                                  subtitle: (controller.calendarModel
                                                  .value[index].description ??
                                              "")
                                          .isNotEmpty
                                      ? Text(
                                          "${controller.calendarModel.value[index].description}")
                                      : null,
                                ),
                              ),
                            );
                          },
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No Journey for this day',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      isDark ? whiteColor : Color(0xFF050A41),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "You don't have Journey for this day, don't forget to record interesting moments in your life, you can start right now",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: isDark
                                      ? greyTextColor
                                      : Color(0xFF676A8B),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
        floatingActionButton: CustomBottomBar.journalFloatingActionButton(() {
          Get.toNamed(journeyRoute);
        }),
        bottomNavigationBar: CustomBottomBar.customBottomBar(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

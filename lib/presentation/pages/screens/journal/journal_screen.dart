import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/presentation/pages/screens/journal/journey_screen.dart';
import 'package:morphzing/presentation/pages/screens/journal/post_journey_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/app_bar.dart';
import 'package:morphzing/presentation/widgets/custom_bottom_bar.dart';
import 'package:morphzing/utils/style/colors.dart';

import '../../../../logic/controllers/journal/journal_controller.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final journalController = Get.put(JournalController());

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  fetchInfo() async {
    await journalController.getTodayJournals();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? darkBgColor : whiteColor,
      appBar: StaticAppBar.homeAppBar(context, 'Journal', false, ""),
      body: Obx(
        () {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 16,
                ),
                child: CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () => Get.to(const PostJourneyScreen()),
                  child: Container(
                    height: 50,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [
                        Color(0xFFD9271D),
                        Color(0xFFE67817),
                        Color(0xFFFFF701),
                        Color(0xFF84C428),
                        Color(0xFF76C5F0),
                        Color(0xFF8F1E78),
                      ]),
                    ),
                    child: Center(
                      child: Text(
                        'Today\'s Journey',
                        style: staticTextStyle(
                          16,
                          whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 2,
                color: greyTextColor,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${journalController.totalEntries.value}',
                          style: staticTextStyle(
                            18,
                            travelColor,
                          ),
                        ),
                        Text(
                          'Total Entries',
                          style: staticTextStyle(
                            12,
                            greyTextColor,
                          ),
                        ),
                      ],
                    )),
                    Container(
                      height: 30,
                      width: 1,
                      color: greyTextColor,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${journalController.currentStreak.value}',
                          style: staticTextStyle(
                            18,
                            travelColor,
                          ),
                        ),
                        Text(
                          'Current Streak',
                          style: staticTextStyle(
                            12,
                            greyTextColor,
                          ),
                        ),
                      ],
                    )),
                    Container(
                      height: 30,
                      width: 1,
                      color: greyTextColor,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${journalController.weeksJournaling.value}',
                          style: staticTextStyle(
                            18,
                            travelColor,
                          ),
                        ),
                        Text(
                          'Weeks Journaling',
                          style: staticTextStyle(
                            12,
                            greyTextColor,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              const Divider(
                height: 2,
                color: greyTextColor,
              ),
              Expanded(
                child: Center(
                  child: (journalController.loading.value)
                      ? const CircularProgressIndicator()
                      : journalController.model.value.isNotEmpty
                          ? ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: journalController.model.value.length,
                              itemBuilder: (context, index) {
                                JournalModel? model;
                                model = journalController.model.value[index];

                                return CupertinoButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    debugPrint('MODEL: ${model?.toJson()}');
                                    Get.to(
                                      JourneyScreen(
                                        isEdit: true,
                                        journeyTime: model?.journeyTime,
                                        noteName: model?.noteName,
                                        description: model?.description,
                                        audio: model?.audioUrl,
                                        draw: model?.drawUrl,
                                        location: model?.location,
                                        webLink: model?.webLink,
                                        document: model?.documentUrl,
                                        id: model?.id,
                                        photos: model?.images,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFAFAFB),
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
                                            DateFormat.EEEE().format(
                                                journalController.model
                                                    .value[index].journeyTime!),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF00C9BC),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            DateFormat.MMMd().format(
                                                journalController.model
                                                    .value[index].journeyTime!),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF00C9BC),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            DateFormat.jm().format(
                                                journalController.model
                                                    .value[index].journeyTime!),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Color(0xFF00C9BC),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Text(journalController
                                          .model.value[index].noteName),
                                      subtitle: (journalController
                                                      .model
                                                      .value[index]
                                                      .description ??
                                                  "")
                                              .isNotEmpty
                                          ? Text(
                                              "${journalController.model.value[index].description}")
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No Journey for today',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        isDark ? whiteColor : Color(0xFF050A41),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "You don't have Journey for today, don't forget to record interesting moments in your life, you can start right now",
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
          );
        },
      ),
      bottomNavigationBar: CustomBottomBar.customJournalBottomBar(
        context: context,
        onPressedCalendar: () => () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomBottomBar.journalFloatingActionButton(
        () => Get.toNamed(journeyRoute)!.then((value) {
          journalController.getStats();
          journalController.getTodayJournals();
        }),
        color: blueColor,
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/journal/note.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/widgets/start_and_finish_date/time_picker_spinner.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/presentation/pages/screens/journal/journey_screen.dart';
import 'package:morphzing/presentation/pages/screens/note/note/note_controller.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/journal/journal_calendar_widget.dart';
import 'package:morphzing/presentation/widgets/journal/journey_bottomsheet_widget.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final NoteController _controller = NoteController();

  late final TextEditingController _titleController =
      TextEditingController(text: _controller.title);
  late final TextEditingController _descController =
      TextEditingController(text: _controller.description);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<NoteController>(
      init: _controller,
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            if (controller.isNoteEdit) {
              controller.onPressedUpdate();
            } else if (controller.title.isEmpty &&
                controller.description.isEmpty) {
              Get.back();
            } else {
              controller.onPressedSave();
            }
            // _controller.backPressed(context);
            return false;
          },
          child: Scaffold(
            backgroundColor: isDark ? darkBgColor : whiteColor,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  // LoadingOverlay.show(context);
                  // if (controller.isNoteEdit) {
                  //   controller.onPressedUpdate();
                  // } else {
                  //   controller.onPressedSave();
                  // }

                  if (controller.isNoteEdit) {
                    controller.onPressedUpdate();
                  } else if (controller.title.isEmpty &&
                      controller.description.isEmpty) {
                    Get.back();
                  } else {
                    controller.onPressedSave();
                  }
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? whiteColor : blackTextColor,
                ),
              ),
              actions: [
                Obx(() {
                  if (controller.isNoteEdit) {
                    return IconButton(
                      onPressed: () {
                        CustomDialogs.show(
                          context: context,
                          title: '${deleteNote.tr}?',
                          onPressLeftButton: () => Get.back(),
                          onPressRightButton: () {
                            Get.back();
                            LoadingOverlay.show(context);
                            controller.deleteNote();
                          },
                          leftButton: no.tr,
                          rightButton: yes.tr,
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    );
                  }
                  return SizedBox();
                }),
                // TextButton(
                //   child: const Text(
                //     "Save",
                //     style: TextStyle(
                //       color: Color(0XFF4890FF),
                //     ),
                //   ),
                //   onPressed: () {
                //     LoadingOverlay.show(context);
                //     if (controller.isNoteEdit) {
                //       controller.onPressedUpdate();
                //     } else {
                //       controller.onPressedSave();
                //     }
                //   },
                // )
              ],
              backgroundColor: isDark ? darkBgColor : bgColor,
              centerTitle: true,
              title: Text(
                'Note',
                style: TextStyle(
                  color: isDark ? whiteColor : blackTextColor,
                  fontFamily: 'SF Pro Display',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SafeArea(
              child: Obx(() {
                return Column(
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    //   child: JournalCalendarWidget(
                    //     dateTime: controller.dateTime,
                    //     onPressedDateTime: () {
                    //       controller.isTimeWidget = false;
                    //       showDialog(
                    //         context: context,
                    //         builder: (context) => BuildCalendar(
                    //           noteController: controller,
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    16.verticalSpace,
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 10),
                        child: SizedBox(
                          width: Get.width,
                          child: TextField(
                            controller: _titleController,
                            onChanged: (e) {
                              controller.title = e;
                            },
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Title name',
                            ),
                            maxLengthEnforcement: MaxLengthEnforcement
                                .truncateAfterCompositionEnds,
                            style: staticTextStyle(
                              24,
                              isDark ? whiteColor : blackTextColor,
                            ),
                          ),
                        ),
                      );
                    }),
                    controller.isNoteDraw
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 300,
                                  width: Get.width,
                                  child: (controller.loadingDraw)
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : controller.isEditNote != null &&
                                              controller.isEditNote!.drawUrl !=
                                                  null
                                          ? Image.network(
                                              controller.isEditNote!.drawUrl!,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.file(
                                              controller.drawFile!,
                                              fit: BoxFit.fill,
                                            ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  height: 300,
                                  width: Get.width,
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (controller.isEditNote != null) {
                                        controller.isEditNote = controller
                                            .isEditNote!
                                            .copyWith(drawUrl: null);
                                      }
                                      controller.drawFile = null;
                                      controller.isNoteDraw = false;
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF3B30),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.delete,
                                          color: whiteColor,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: greyTextColor.withOpacity(0.3),
                                    )),
                                width: Get.width,
                                child: TextField(
                                  controller: _descController,
                                  maxLines: 50,
                                  onChanged: (e) {
                                    controller.description = e;
                                  },
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Descriptions',
                                  ),
                                  style: staticTextStyle(
                                    16,
                                    isDark ? whiteColor : blackTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    20.verticalSpace,
                    //const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      color: isDark ? darkBgColor : bgColor,
                      height: 50,
                      width: Get.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.onPressedT();
                              },
                              child: Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/T.png',
                                  ),
                                  height: 18,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 1,
                            color: isDark
                                ? whiteColor
                                : greyTextColor.withOpacity(0.2),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.onPressedDraw();
                              },
                              child: Center(
                                child: Image(
                                  image: AssetImage(
                                    'assets/images/draw.png',
                                  ),
                                  height: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

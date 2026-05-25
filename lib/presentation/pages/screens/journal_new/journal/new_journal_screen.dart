import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/purchase/template.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/bottom_picker/template_option_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/journal/new_journal_controller.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/journey_template/journey_template_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/subscription/widgets/subscription_dialog.dart';
import 'package:morphzing/presentation/widgets/calendar_widget.dart';
import 'package:morphzing/presentation/widgets/journal/journal_calendar_widget.dart';
import 'package:morphzing/presentation/widgets/journal/journal_info_widget.dart';
import 'package:morphzing/presentation/widgets/journal/journal_paint_widget.dart';
import 'package:morphzing/presentation/widgets/journal/multiple_image_widget.dart';
import 'package:morphzing/utils/app_functions.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;

class NewJournalScreen extends StatefulWidget {
  const NewJournalScreen({Key? key}) : super(key: key);

  @override
  State<NewJournalScreen> createState() => _NewJournalScreenState();
}

class _NewJournalScreenState extends State<NewJournalScreen> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    _initPermission();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    super.initState();
  }

  _initPermission() async {
    final PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      //permission is granted
    } else {
      //permission denied or undermined
    }
  }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.microphone.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.microphone].request();
      return permissionStatus[Permission.microphone] ??
          PermissionStatus.granted;
    } else {
      return permission;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<NewJournalController>(
      init: NewJournalController(),
      builder: (controller) {
        return Obx(() {
          return WillPopScope(
              // remove backpress popup from here
              onWillPop: () async {
                if (controller.isJournalEdit) {
                  controller.onUpdatePressed();
                } else if (controller.title.isEmpty &&
                    controller.description.isEmpty) {
                  Get.back();
                } else {
                  controller.onSavePressed();
                }
                //  if (controller.isJournalEdit) {
                //           controller.onUpdatePressed();
                //         } else {
                //           controller.onSavePressed();
                //         }
                // controller.backPressed(context);
                // controller.onSavePressed();
                return false;
              },
              child: Container(
                decoration: BoxDecoration(
                    image: controller.templateUrl != null
                        ? DecorationImage(
                            image: NetworkImage(controller.templateUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: whiteColor.withOpacity(0.1)),
                child: Scaffold(
                  backgroundColor: controller.templateUrl != null
                      ? Colors.transparent
                      : isDark
                          ? darkBgColor
                          : whiteColor,

                  // backgroundColor: isDark ? darkBgColor : whiteColor,
                  appBar: AppBar(
                    backgroundColor: isDark
                        ? Theme.of(context).appBarTheme.backgroundColor
                        : bgColor,
                    leading: IconButton(
                      onPressed: () {
                        if (controller.isJournalEdit) {
                          controller.onUpdatePressed();
                        } else if (controller.title.isEmpty &&
                            controller.description.isEmpty) {
                          Get.back();
                        } else {
                          controller.onSavePressed();
                        }
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: isDark ? whiteColor : blackTextColor,
                      ),
                    ),
                    actions: [
                      if (Get.find<AppController>()
                              .user
                              ?.userSubscription
                              .paymentStatus ==
                          SubscriptionType.free) ...[
                        GestureDetector(
                          onTap: () {
                            SubscriptionDialog.show(context: context);
                          },
                          child: Center(
                              child: SizedBox(
                            height: 30,
                            width: 30,
                            child: SvgPicture.asset('assets/icons/premium.svg'),
                          )),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      // TextButton(
                      //   onPressed: () {
                      //     LoadingOverlay.show(context);
                      //     if (controller.isJournalEdit) {
                      //       controller.onUpdatePressed();
                      //     } else {
                      //       controller.onSavePressed();
                      //     }
                      //   },
                      //   child: Text(save.tr),
                      // ),
                    ],
                    centerTitle: true,
                    title: Text(
                      journey.tr,
                      style: TextStyle(
                        color: isDark ? whiteColor : blackTextColor,
                        fontFamily: 'SF Pro Display',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  body: Obx(() {
                    return Container(
                      // decoration: BoxDecoration(
                      //     image: controller.templateUrl != null
                      //         ? DecorationImage(
                      //             image: NetworkImage(controller.templateUrl!),
                      //             fit: BoxFit.cover,
                      //           )
                      //         : null,
                      //     color: whiteColor.withOpacity(0.1)),
                      child: Column(children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            children: [
                              JournalCalendarWidget(
                                dateTime: controller.chosenDateTime,
                                onPressedDateTime: () {
                                  controller.setDateTime(context);
                                },
                              ),
                              JournalInfoWidget(
                                title: controller.title,
                                desc: controller.description,
                                onChangeTitle: (title) =>
                                    controller.title = title,
                                onChangeDescription: (description) =>
                                    controller.description = description,
                              ),
                              8.verticalSpace,
                              MultipleImageViewWidget(
                                photos: controller.photoList,
                                onPressed: () {
                                  controller.openMultiPhotoScreen();
                                },
                                onMore: () =>
                                    controller.openPhotoBottomPicker(),
                              ),
                              if (controller.drawFile != null ||
                                  controller.drawPath.isNotEmpty) ...[
                                8.verticalSpace,
                                JournalPaintWidget(
                                  loading: controller.painterLoading,
                                  file: controller.drawFile,
                                  drawPath: controller.drawPath,
                                  onPressedDelete: () {
                                    controller.drawPath = '';
                                    controller.drawFile = null;
                                  },
                                ),
                              ],
                              if (controller.audioFile != null ||
                                  controller.audioPath.isNotEmpty) ...{
                                ...[
                                  8.verticalSpace,
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: isDark
                                            ? Colors.white.withOpacity(0.2)
                                            : greyTextColor.withOpacity(0.3),
                                      ),
                                      color: isDark
                                          ? Colors.transparent
                                          : whiteColor.withOpacity(0.7),
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            CupertinoButton(
                                              onPressed: () async {
                                                if (isPlaying) {
                                                  await audioPlayer.pause();
                                                } else {
                                                  if (controller.audioFile !=
                                                      null) {
                                                    await audioPlayer.play(
                                                        DeviceFileSource(
                                                            controller
                                                                .audioFile!
                                                                .path));
                                                  } else if (controller
                                                      .audioPath.isNotEmpty) {
                                                    await audioPlayer.play(
                                                        UrlSource(controller
                                                            .audioPath));
                                                  }
                                                }
                                              },
                                              padding: const EdgeInsets.all(0),
                                              child: CircleAvatar(
                                                radius: 16,
                                                child: Icon(
                                                  isPlaying
                                                      ? Icons.pause
                                                      : Icons.play_arrow,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                        Expanded(
                                          child: Slider(
                                            min: 0,
                                            max: duration.inSeconds.toDouble(),
                                            value:
                                                position.inSeconds.toDouble(),
                                            onChanged: (double value) async {
                                              final position = Duration(
                                                  seconds: value.toInt());
                                              await audioPlayer.seek(position);
                                            },
                                          ),
                                        ),
                                        Text(
                                          controller.formatTime(duration),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                              },
                              if (controller.locationText.isNotEmpty) ...[
                                8.verticalSpace,
                                _initBgContainer(
                                  child: Text(
                                    controller.locationText,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF4890FF),
                                      decoration: controller.isLocationUrl
                                          ? TextDecoration.underline
                                          : null,
                                    ),
                                  ),
                                  onPressedItem: controller.isLocationUrl
                                      ? () async {
                                          final Uri myUrl = Uri.parse(
                                              controller.locationText);

                                          if (!await launchUrl(myUrl)) {
                                            return;
                                          }
                                        }
                                      : null,
                                )
                              ],
                              if (controller.webLinkText.isNotEmpty) ...[
                                8.verticalSpace,
                                _initBgContainer(
                                  child: Text(
                                    controller.webLinkText,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF4890FF),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  onPressedItem: () async {
                                    final urlText = controller.webLinkText;

                                    final Uri myUrl = Uri.parse(urlText);
                                    if (!await launchUrl(myUrl)) {
                                      return;
                                    }
                                  },
                                )
                              ],
                              if (controller.docFile != null ||
                                  controller.docPath.isNotEmpty) ...[
                                8.verticalSpace,
                                _initBgContainer(
                                  onPressedItem: () {
                                    if (controller.docFile != null) {
                                      controller.openFile(controller.docFile!);
                                    } else {
                                      controller.launchURL(controller.docPath);
                                    }
                                  },
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      radius: 20,
                                      child: Icon(
                                        Icons.file_download_outlined,
                                        color: isDark
                                            ? whiteColor
                                            : blackTextColor,
                                      ),
                                    ),
                                    title: Text(
                                      controller.documentName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      controller.documentDesc,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xFF676A8B),
                                      ),
                                    ),
                                    trailing: Text(
                                      getFileSizeString(
                                          bytes: controller.documentSize,
                                          decimals: 2),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Color(0xFF676A8B),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SafeArea(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8),
                            color: isDark ? darkGreyButton : bgColor,
                            height: 50,
                            width: Get.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.openAudioBottomSheet();
                                    },
                                    child: const Center(
                                      child: Image(
                                        image: AssetImage(
                                          'assets/images/voice.png',
                                        ),
                                        height: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 1,
                                  color: greyTextColor.withOpacity(0.2),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.openPainterScreen();
                                    },
                                    child: const Center(
                                      child: Image(
                                        image: AssetImage(
                                          'assets/images/draw.png',
                                        ),
                                        height: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 1,
                                  color: greyTextColor.withOpacity(0.2),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      controller.openJourneyBottomSheet();
                                    },
                                    child: const Center(
                                      child: Image(
                                        image: AssetImage(
                                          'assets/images/extra.png',
                                        ),
                                        height: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 1,
                                  color: greyTextColor.withOpacity(0.2),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return TemplateOptionBottomSheet(
                                            onPressedTemplate: () async {
                                              final Template? template =
                                                  await JourneyTemplateBottomSheet
                                                      .show(context: context);
                                              if (template != null) {
                                                controller
                                                    .setTemplate(template);
                                              }
                                            },
                                            onPressedShare: () {
                                              if (controller
                                                  .photoList.isNotEmpty) {
                                                LoadingOverlay.show(context);
                                                controller.shareFile();
                                              }
                                            },
                                            onPressedDelete: () {
                                              if (controller.isJournalEdit) {
                                                CustomDialogs.show(
                                                  context: context,
                                                  title: '${deleteJourney.tr}?',
                                                  onPressLeftButton: () =>
                                                      Get.back(),
                                                  onPressRightButton: () {
                                                    Get.back();
                                                    Get.back();
                                                    LoadingOverlay.show(
                                                        context);
                                                    controller.deleteJourney();
                                                  },
                                                  leftButton: no.tr,
                                                  rightButton: yes.tr,
                                                );
                                              } else {
                                                Get.back();
                                              }
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: const Center(
                                      child: Icon(
                                        Icons.more_vert,
                                        size: 26,
                                        color: Color(0XFF4890FF),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                    );
                  }),
                ),
              ));
        });
      },
    );
  }

  Widget _initBgContainer({
    required Widget child,
    required VoidCallback? onPressedItem,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: whiteColor.withOpacity(0.7),
      child: InkWell(
        onTap: onPressedItem != null ? () => onPressedItem() : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: whiteColor.withOpacity(0.7),
            border: Border.all(
              width: 1,
              color: greyTextColor.withOpacity(0.3),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

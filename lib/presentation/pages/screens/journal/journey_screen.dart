import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/logic/controllers/journal/journal_controller.dart';
import 'package:morphzing/logic/controllers/journal/journey_controller.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/journal/audio_bottomsheet_widget.dart';
import 'package:morphzing/presentation/widgets/journal/journey_bottomsheet_widget.dart';
import 'package:morphzing/presentation/widgets/journal/multiple_image_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/style/colors.dart';

class JourneyScreen extends StatefulWidget {
  /*
  journeyTime: dateTime.value.toString(),
      noteName: journeyTitleController.text,
      description: journeyDescriptionController.text,
      audio: audio,
      draw: file,
      location: locationText.value.isNotEmpty ? locationText.value : null,
      webLink: webLinkText.value.isNotEmpty ? webLinkText.value : null,
      document: docFile.value,
  */
  final DateTime? journeyTime;
  final String? noteName;
  final String? description;
  final String? audio;
  final String? draw;
  final String? location;
  final String? webLink;
  final String? document;
  final List<Photo>? photos;

  final int? id;
  final bool isEdit;

  const JourneyScreen({
    Key? key,
    this.isEdit = false,
    this.journeyTime,
    this.noteName,
    this.description,
    this.audio,
    this.draw,
    this.location,
    this.webLink,
    this.document,
    this.id,
    this.photos,
  }) : super(key: key);

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  final journeyController = Get.put(
    JourneyController(),
  );

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    journeyController.fetchInitData(
      widget.journeyTime,
      widget.noteName,
      widget.description,
      widget.audio,
      widget.draw,
      widget.location,
      widget.webLink,
      widget.document,
      widget.id,
      widget.photos,
    );
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
    return Obx(() {
      return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? darkBgColor
            : whiteColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: blackTextColor,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {},
              child: Center(
                child: SizedBox(
                    height: 30,
                    width: 30,
                    child: SvgPicture.asset('assets/icons/premium.svg')),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Opacity(
              opacity:
                  journeyController.journeyTitleController.text.isNotEmpty ||
                          !(journeyController.loading.value)
                      ? 1
                      : 0.5,
              child: CupertinoButton(
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Color(0XFF4890FF),
                  ),
                ),
                onPressed:
                    journeyController.journeyTitleController.text.isNotEmpty
                        ? () async {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: const CupertinoActivityIndicator(),
                                  ),
                                );
                              },
                              barrierDismissible: false,
                            );
                            journeyController.loading(true);
                            widget.isEdit
                                ? await journeyController.onEdit()
                                : await journeyController.onSave();

                            journeyController.loading(false);
                            Get.back();
                          }
                        : null,
              ),
            ),
          ],
          backgroundColor: bgColor,
          centerTitle: true,
          title: const Text(
            'Today\'s Journey',
            style: TextStyle(
              color: blackTextColor,
              fontFamily: 'SF Pro Display',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: (journeyController.loading.value)
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                            height: 50,
                            width: Get.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat.jm().format(
                                            journeyController.dateTime.value),
                                        style: staticTextStyle(
                                          12,
                                          greyTextColor,
                                        ),
                                      ),
                                      Text(
                                        '${DateFormat.MMMMd().format(journeyController.dateTime.value)}, ${DateFormat.y().format(journeyController.dateTime.value)}',
                                        style: staticTextStyle(
                                          16,
                                          blackTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: IconButton(
                                      onPressed: () {
                                        journeyController.isTimeWidget.value =
                                            false;
                                        showDialog(
                                          context: context,
                                          builder: (context) => BuildCalendar(
                                            journeyController:
                                                journeyController,
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.event_note,
                                        color: blueColor,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Divider(
                              height: 1,
                              color: greyTextColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 10),
                            child: SizedBox(
                              height: 30,
                              width: Get.width,
                              child: TextField(
                                onChanged: (e) {
                                  setState(() {});
                                },
                                controller:
                                    journeyController.journeyTitleController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Title name',
                                ),
                                style: staticTextStyle(
                                  20,
                                  blackTextColor,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? greyTextColor.withOpacity(0.3)
                                        : greyTextColor.withOpacity(0.3),
                                  )),
                              height: 200,
                              width: Get.width,
                              child: TextField(
                                maxLines: 50,
                                controller: journeyController
                                    .journeyDescriptionController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Descriptions',
                                ),
                                style: staticTextStyle(
                                  14,
                                  blackTextColor,
                                ),
                              ),
                            ),
                          ),
                          Obx(() {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8),
                              child: MultipleImageViewWidget(
                                onMore: () {
                                  showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return _showMore(context);
                                    },
                                  );
                                },
                                photos: journeyController.photos.value,
                                onPressed: () {},
                              ),
                            );
                          }),
                          if (journeyController.drawFile != null) ...{
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 300,
                                    width: Get.width,
                                    child: (journeyController.paintLoader.value)
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Image.file(
                                            journeyController.drawFile!,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    height: 300,
                                    width: Get.width,
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          journeyController.drawFile = null;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF3B30),
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                            ),
                          } else ...{
                            const SizedBox(height: 8),
                          },
                          if (journeyController.webLinkText.isNotEmpty) ...{
                            CupertinoButton(
                              alignment: Alignment.centerLeft,
                              onPressed: () async {
                                final urlText =
                                    journeyController.webLinkText.value;

                                final Uri myUrl = Uri.parse(urlText);
                                if (!await launchUrl(myUrl)) {
                                  return;
                                }
                              },
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                journeyController.webLinkText.value,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4890FF),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          },
                          if (journeyController.locationText.isNotEmpty) ...{
                            CupertinoButton(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              onPressed: () async {
                                // https://www.google.com/maps/place/Kukcha+Mosque/@41.3216428,69.2043121,15z/data=!4m5!3m4!1s0x38ae8bfa8c4225e5:0x28f17ddc027649c6!8m2!3d41.3227628!4d69.2048432
                                final urlText =
                                    journeyController.locationText.value;

                                if (urlText.startsWith("https://")) {
                                  final Uri myUrl = Uri.parse(urlText);

                                  if (!await launchUrl(myUrl)) {
                                    return;
                                  }
                                }
                              },
                              child: Text(
                                (journeyController.locationText.value
                                        .startsWith("https://")
                                    ? "${journeyController.locationText.value.split("/")[2]}/${journeyController.locationText.value.split("/")[3]}"
                                    : journeyController.locationText.value),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4890FF),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          },
                          if (journeyController.docFile.value != null) ...{
                            CupertinoButton(
                              onPressed: () {
                                journeyController
                                    .openFile(journeyController.docFile.value!);
                              },
                              padding: const EdgeInsets.all(0),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  radius: 20,
                                  child: Icon(
                                    Icons.file_download_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  journeyController.documentFile?.name ??
                                      "Unkown",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                subtitle: Text(
                                  journeyController.documentFile?.path
                                          ?.split("/")
                                          .last ??
                                      "Unknown",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xFF676A8B),
                                  ),
                                ),
                                trailing: Text(
                                  ((journeyController.documentFile?.size ?? 1) /
                                              1000000)
                                          .toString()
                                          .split(".")[0] +
                                      "." +
                                      ((journeyController.documentFile?.size ??
                                                  1) /
                                              1000000)
                                          .toString()
                                          .split(".")[1]
                                          .substring(0, 2) +
                                      " MB",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xFF676A8B),
                                  ),
                                ),
                              ),
                            )
                          },
                          if (journeyController.pathAudio.value.isNotEmpty) ...{
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.centerRight,
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      CupertinoButton(
                                        onPressed: () async {
                                          if (isPlaying) {
                                            await audioPlayer.pause();
                                          } else {
                                            if (journeyController
                                                .pathAudio.value.isNotEmpty) {
                                              final source = DeviceFileSource(
                                                  journeyController
                                                      .pathAudio.value);
                                              await audioPlayer.play(source);
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
                                      Text(
                                        formatTime(position),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Slider(
                                      min: 0,
                                      max: duration.inSeconds.toDouble(),
                                      value: position.inSeconds.toDouble(),
                                      onChanged: (double value) async {
                                        final position =
                                            Duration(seconds: value.toInt());
                                        await audioPlayer.seek(position);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          },
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      color: bgColor,
                      height: 50,
                      width: Get.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Get.bottomSheet(
                                //   AudioBottomSheetWidget(
                                //     journeyController: journeyController,
                                //   ),
                                // );
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
                              onTap: () async {
                                await Get.toNamed(painterRoute)?.then((value) {
                                  if (value != null) {
                                    journeyController.readImageFromUnit8(value);
                                  }
                                });

                                Future.microtask(() async {
                                  setState(() {});
                                  await Future.delayed(
                                    const Duration(milliseconds: 1200),
                                  );
                                  setState(() {});
                                });
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
                                // await Get.bottomSheet(
                                //   const JourneyBottomSheet(),
                                // );
                                // setState(() {});
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
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return _showMoreVert(context);
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
                  ],
                ),
              ),
      );
    });
  }

  Widget _showMore(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 272,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Options",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF050A41),
              ),
            ),
            const SizedBox(height: 20),
            Opacity(
              opacity: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(7, 5, 10, 65),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.ios_share,
                    color: Color(0xFF050A41),
                  ),
                  title: Text(
                    "Share",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF050A41),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                if (journeyController.photos.length < 5) {
                  var image = await journeyController.journeyImageFromGallery();
                  if (image != null) {
                    journeyController.photos.add(image);
                    setState(() {});
                  }
                } else {
                  Get.back();
                  Get.snackbar('',
                      'Free limit is 5. Please remove a photo to add new one ');
                }
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(7, 5, 10, 65),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.add_photo_alternate_rounded,
                    color: Color(0xFF050A41),
                  ),
                  title: Text(
                    "Add a photo",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF050A41),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                journeyController.photos.clear();
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(7, 5, 10, 65),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Color(0xFFFF3B30),
                  ),
                  title: Text(
                    "Delete photos",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFFFF3B30),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showMoreVert(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 342,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Options",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF050A41),
              ),
            ),
            const SizedBox(height: 20),
            Opacity(
              opacity: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(7, 5, 10, 65),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.menu_book,
                    color: Color(0xFF050A41),
                  ),
                  title: Text(
                    "Templates",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF050A41),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Opacity(
              opacity: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(7, 5, 10, 65),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.remove_red_eye,
                    color: Color(0xFF050A41),
                  ),
                  title: Text(
                    "View",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF050A41),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Opacity(
              opacity: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(7, 5, 10, 65),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.ios_share,
                    color: Color(0xFF050A41),
                  ),
                  title: Text(
                    "Share",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF050A41),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CupertinoButton(
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                Get.back();
                if (widget.isEdit) {
                  journeyController.loading(true);
                  await journeyController.deleteJourney();
                  journeyController.loading(false);
                }
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(7, 5, 10, 65),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Color(0xFFFF3B30),
                  ),
                  title: Text(
                    "Delete note",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFFFF3B30),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildCalendar extends StatefulWidget {
  final JourneyController journeyController;

  const BuildCalendar({required this.journeyController, Key? key})
      : super(key: key);

  @override
  State<BuildCalendar> createState() => _BuildCalendarState();
}

class _BuildCalendarState extends State<BuildCalendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: (widget.journeyController.isTimeWidget.value)
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 220,
              width: Get.width - 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: staticTextStyle(
                      16,
                      blackTextColor,
                    ),
                  ),
                  Expanded(
                    child: TimePickerSpinner(
                      is24HourMode: false,
                      normalTextStyle: staticTextStyle(
                        20,
                        blackTextColor.withOpacity(0.5),
                      ),
                      highlightedTextStyle:
                          const TextStyle(fontSize: 24, color: blackTextColor),
                      spacing: 20,
                      itemHeight: 40,
                      isForce2Digits: true,
                      onTimeChange: (time) {
                        widget.journeyController.dateTime.value = DateTime(
                          widget.journeyController.dateTime.value.year,
                          widget.journeyController.dateTime.value.month,
                          widget.journeyController.dateTime.value.day,
                          time.hour,
                          time.minute,
                          time.second,
                        );
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: blueColor),
                      child: Center(
                        child: Text(
                          'Save',
                          style: staticTextStyle(
                            16,
                            whiteColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 500,
              width: Get.width - 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Calendar',
                    style: staticTextStyle(
                      16,
                      blackTextColor,
                    ),
                  ),
                  Expanded(
                    child: TableCalendar(
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: blueColor,
                          // borderRadius: BorderRadius.circular(10),
                        ),
                        // selectedDecoration: BoxDecoration(
                        //   color: blueColor,
                        //   borderRadius: BorderRadius.circular(10),
                        // ),
                      ),
                      calendarFormat: _calendarFormat,
                      headerStyle: HeaderStyle(
                        titleTextStyle: staticTextStyle(
                          16,
                          blueColor,
                        ),
                        formatButtonVisible: false,
                        formatButtonShowsNext: false,
                        titleCentered: true,
                      ),
                      onDaySelected: (selectedDay, focusedDay) {
                        widget.journeyController.dateTime.value = selectedDay;
                        widget.journeyController.focusedDateTime.value =
                            focusedDay;
                        setState(() {});
                      },
                      currentDay: widget.journeyController.dateTime.value,
                      focusedDay:
                          widget.journeyController.focusedDateTime.value,
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2040, 3, 14),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.journeyController.isTimeWidget.value = true;
                      setState(() {});
                    },
                    child: Container(
                      height: 50,
                      width: Get.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: blueColor),
                      child: Center(
                        child: Text(
                          'Continue',
                          style: staticTextStyle(
                            16,
                            whiteColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));

  return [
    if (duration.inHours > 0) hours,
    minutes,
    seconds,
  ].join(":");
}

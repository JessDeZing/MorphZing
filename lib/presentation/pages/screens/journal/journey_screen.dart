import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:image_picker/image_picker.dart';
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
  final journeyController = Get.put(JourneyController());
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    journeyController.fetchInitData(
      widget.journeyTime, widget.noteName, widget.description,
      widget.audio, widget.draw, widget.location, widget.webLink,
      widget.document, widget.id, widget.photos,
    );
    _initPermission();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() { isPlaying = state == PlayerState.playing; });
    });
    audioPlayer.onDurationChanged.listen((d) { setState(() { duration = d; }); });
    audioPlayer.onPositionChanged.listen((p) { setState(() { position = p; }); });
    super.initState();
  }

  _initPermission() async { await _getPermission(); }

  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.microphone.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus = await [Permission.microphone].request();
      return permissionStatus[Permission.microphone] ?? PermissionStatus.granted;
    }
    return permission;
  }

  Future<void> _saveAndPop() async {
    final desc = journeyController.journeyDescriptionController.text.trim();
    final title = journeyController.journeyTitleController.text.trim();
    
    // Nothing to save
    if (desc.isEmpty && title.isEmpty) {
      Get.back(result: false);
      return;
    }
    
    // Auto-title from first 7 words if no title
    if (title.isEmpty && desc.isNotEmpty) {
      final words = desc.split(RegExp(r'\s+'));
      journeyController.journeyTitleController.text = words.take(7).join(' ');
    }
    
    journeyController.loading(true);
    if (widget.isEdit) {
      await journeyController.onEdit();
    } else {
      await journeyController.onSave();
    }
    journeyController.loading(false);
    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final appBarColor = isDark ? const Color(0xFF1C1C1E) : bgColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? Colors.black : const Color(0xFFE5E5EA);

    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          await _saveAndPop();
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF000000),
          appBar: AppBar(
            backgroundColor: appBarColor,
            foregroundColor: textColor,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () async => await _saveAndPop(),
              icon: Icon(Icons.arrow_back_ios, color: textColor),
            ),
            title: Text('Journey', style: TextStyle(color: textColor, fontFamily: 'SF Pro Display', fontSize: 18, fontWeight: FontWeight.bold)),
            actions: [
              CupertinoButton(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.save, color: textColor, size: 28),
                onPressed: () async {
                  await _saveAndPop();
                },
              ),
            ],
          ),
          body: journeyController.loading.value
              ? const Center(child: CupertinoActivityIndicator())
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            // Date/time row
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                              height: 60,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(DateFormat.jm().format(journeyController.dateTime.value),
                                          style: const TextStyle(fontSize: 13, color: Colors.white70)),
                                        Text('${DateFormat.MMMMd().format(journeyController.dateTime.value)}, ${DateFormat.y().format(journeyController.dateTime.value)}',
                                          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            const Divider(height: 1, color: greyTextColor),
                            // Title
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF000000),
                                ),
                                padding: EdgeInsets.zero,
                                child: TextField(
                                  onChanged: (e) => setState(() {}),
                                  controller: journeyController.journeyTitleController,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFF000000),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    hintText: 'Give your entry a title...',
                                    hintStyle: TextStyle(color: Colors.white24, fontSize: 18),
                                    contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                  ),
                                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const Divider(height: 1, thickness: 0.3, color: Colors.white24, indent: 16, endIndent: 16),
                            // Description
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF000000),
                                ),
                                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.6),
                                width: double.infinity,
                                child: TextField(
                                  maxLines: null,
                                  controller: journeyController.journeyDescriptionController,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFF000000),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    hintText: 'Tell me about your day...',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
                                ),
                              ),
                            ),
                            // Photos
                            Obx(() => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: MultipleImageViewWidget(
                                onMore: () {
                                  showModalBottomSheet(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    context: context,
                                    builder: (context) => _showMore(context),
                                  );
                                },
                                photos: journeyController.photos.value,
                                onPressed: () {},
                              ),
                            )),
                            // Draw file
                            if (journeyController.drawFile != null) ...{
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: Stack(children: [
                                  SizedBox(
                                    height: 300, width: double.infinity,
                                    child: journeyController.paintLoader.value
                                        ? const Center(child: CircularProgressIndicator())
                                        : Image.file(journeyController.drawFile!, fit: BoxFit.cover),
                                  ),
                                  Positioned(top: 10, right: 10,
                                    child: GestureDetector(
                                      onTap: () => setState(() => journeyController.drawFile = null),
                                      child: Container(
                                        height: 40, width: 40,
                                        decoration: BoxDecoration(color: const Color(0xFFFF3B30), borderRadius: BorderRadius.circular(20)),
                                        child: const Icon(Icons.delete, color: Colors.white, size: 18),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            } else ...{const SizedBox(height: 8)},
                            // Weblink
                            if (journeyController.webLinkText.isNotEmpty) ...{
                              CupertinoButton(
                                alignment: Alignment.centerLeft,
                                onPressed: () async {
                                  final Uri url = Uri.parse(journeyController.webLinkText.value);
                                  if (!await launchUrl(url)) return;
                                },
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(journeyController.webLinkText.value,
                                  style: const TextStyle(fontSize: 17, color: Color(0xFF4890FF), decoration: TextDecoration.underline)),
                              ),
                            },
                            // Location
                            if (journeyController.locationText.isNotEmpty) ...{
                              CupertinoButton(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                onPressed: () async {
                                  final urlText = journeyController.locationText.value;
                                  if (urlText.startsWith("https://")) {
                                    final Uri url = Uri.parse(urlText);
                                    if (!await launchUrl(url)) return;
                                  }
                                },
                                child: Text(journeyController.locationText.value,
                                  style: const TextStyle(fontSize: 17, color: Color(0xFF4890FF), decoration: TextDecoration.underline)),
                              ),
                            },
                            // Document
                            if (journeyController.docFile.value != null) ...{
                              CupertinoButton(
                                onPressed: () => journeyController.openFile(journeyController.docFile.value!),
                                padding: EdgeInsets.zero,
                                child: ListTile(
                                  leading: const CircleAvatar(radius: 20, child: Icon(Icons.file_download_outlined, color: Colors.white)),
                                  title: Text(journeyController.documentFile?.name ?? "Unknown",
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                ),
                              ),
                            },
                            // Audio
                            if (journeyController.pathAudio.value.isNotEmpty) ...{
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(children: [
                                  Column(children: [
                                    CupertinoButton(
                                      onPressed: () async {
                                        if (isPlaying) {
                                          await audioPlayer.pause();
                                        } else {
                                          await audioPlayer.play(DeviceFileSource(journeyController.pathAudio.value));
                                        }
                                      },
                                      padding: EdgeInsets.zero,
                                      child: CircleAvatar(radius: 16, child: Icon(isPlaying ? Icons.pause : Icons.play_arrow)),
                                    ),
                                    Text(formatTime(position)),
                                  ]),
                                  Expanded(child: Slider(
                                    min: 0, max: duration.inSeconds.toDouble(),
                                    value: position.inSeconds.toDouble(),
                                    onChanged: (v) async => await audioPlayer.seek(Duration(seconds: v.toInt())),
                                  )),
                                ]),
                              ),
                            },
                          ],
                        ),
                      ),
                      // Bottom toolbar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: appBarColor,
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Mic
                            Expanded(child: GestureDetector(
                              onTap: () {
                                Get.bottomSheet(AudioBottomSheetWidget(
                                  onChangePath: (path) {
                                    journeyController.pathAudio.value = path;
                                  },
                                ));
                              },
                              child: const Center(child: Image(image: AssetImage('assets/images/voice.png'), height: 22, color: Colors.white)),
                            )),
                            Container(height: 30, width: 1, color: greyTextColor),
                            // Gallery
                            Expanded(child: GestureDetector(
                              onTap: () async {
                                await journeyController.pickMultipleImages();
                                debugPrint('Photos count: ${journeyController.photos.length}');
                                setState(() {});
                              },
                              child: const Center(child: Image(image: AssetImage('assets/images/photo.png'), height: 22, color: Colors.white)),
                            )),
                            Container(height: 30, width: 1, color: greyTextColor),
                            // Paint/Draw
                            Expanded(child: GestureDetector(
                              onTap: () async {
                                await Get.toNamed(painterRoute)?.then((value) {
                                  if (value != null) journeyController.readImageFromUnit8(value);
                                });
                                Future.microtask(() async {
                                  setState(() {});
                                  await Future.delayed(const Duration(milliseconds: 1200));
                                  setState(() {});
                                });
                              },
                              child: const Center(child: Icon(Icons.brush, color: Colors.white, size: 24)),
                            )),
                            Container(height: 30, width: 1, color: greyTextColor),
                            // Wallpaper/Background
                            Expanded(child: GestureDetector(
                              onTap: () {},
                              child: const Center(child: Icon(Icons.wallpaper, color: Colors.white, size: 24)),
                            )),
                            Container(height: 30, width: 1, color: greyTextColor),
                            // More
                            Expanded(child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  context: context,
                                  builder: (context) => _showMoreVert(context),
                                );
                              },
                              child: const Center(child: Icon(Icons.more_vert, size: 26, color: Color(0XFF4890FF))),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    });
  }

  Widget _showMore(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF050A41);
    final cardColor = isDark ? const Color(0xFF2C2C2E) : const Color.fromARGB(7, 5, 10, 65);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Options", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textColor)),
            const SizedBox(height: 16),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                var image = await journeyController.journeyImageFromGallery();
                if (image != null) { journeyController.photos.add(Photo(file: image)); setState(() {}); }
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: cardColor),
                child: ListTile(
                  leading: Icon(Icons.add_photo_alternate_rounded, color: textColor),
                  title: Text("Add a photo", style: TextStyle(fontSize: 17, color: textColor)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () { journeyController.photos.clear(); Get.back(); },
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: cardColor),
                child: const ListTile(
                  leading: Icon(Icons.delete, color: Color(0xFFFF3B30)),
                  title: Text("Delete photos", style: TextStyle(fontSize: 17, color: Color(0xFFFF3B30))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showMoreVert(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF050A41);
    final cardColor = isDark ? const Color(0xFF2C2C2E) : const Color.fromARGB(15, 5, 10, 65);
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Media", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textColor)),
              const SizedBox(height: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  Get.back();
                  final Uri mapsUrl = Uri.parse('https://maps.google.com');
                  if (await canLaunchUrl(mapsUrl)) await launchUrl(mapsUrl);
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: cardColor),
                  child: ListTile(leading: Icon(Icons.location_on, color: textColor), title: Text("Location", style: TextStyle(fontSize: 17, color: textColor)), trailing: Icon(Icons.chevron_right, color: textColor)),
                ),
              ),
              const SizedBox(height: 8),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  Get.back();
                  await showDialog(context: context, builder: (ctx) => AlertDialog(
                    title: const Text('Add Weblink'),
                    content: TextField(controller: journeyController.webLinkController,
                      decoration: const InputDecoration(hintText: 'https://')),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      TextButton(onPressed: () {
                        if (journeyController.webLinkController.text.isNotEmpty) {
                          journeyController.webLinkText.value = journeyController.webLinkController.text;
                        }
                        Navigator.pop(ctx);
                      }, child: const Text('Add')),
                    ],
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: cardColor),
                  child: ListTile(leading: Icon(Icons.link, color: textColor), title: Text("Weblink", style: TextStyle(fontSize: 17, color: textColor)), trailing: Icon(Icons.chevron_right, color: textColor)),
                ),
              ),
              const SizedBox(height: 8),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async { Get.back(); await journeyController.pickFile(); setState(() {}); },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: cardColor),
                  child: ListTile(leading: Icon(Icons.attach_file, color: textColor), title: Text("Document", style: TextStyle(fontSize: 17, color: textColor)), trailing: Icon(Icons.chevron_right, color: textColor)),
                ),
              ),
              const SizedBox(height: 8),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  Get.back();
                  var image = await journeyController.journeyImageFromCamera();
                  if (image != null) { journeyController.photos.add(Photo(file: image)); setState(() {}); }
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: cardColor),
                  child: ListTile(leading: Icon(Icons.camera_alt, color: textColor), title: Text("Camera", style: TextStyle(fontSize: 17, color: textColor)), trailing: Icon(Icons.chevron_right, color: textColor)),
                ),
              ),

              const SizedBox(height: 8),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  Get.back();
                  if (widget.isEdit) {
                    final confirm = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF1a1a2e),
                      title: const Text('Delete entry?', style: TextStyle(color: Colors.white)),
                      content: const Text('This cannot be undone.', style: TextStyle(color: Colors.grey)),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.redAccent))),
                      ],
                    ));
                    if (confirm == true) {
                      journeyController.loading(true);
                      await journeyController.deleteJourney();
                      journeyController.loading(false);
                      Get.back(result: true);
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: cardColor),
                  child: const ListTile(
                    leading: Icon(Icons.delete, color: Color(0xFFFF3B30)),
                    title: Text("Delete", style: TextStyle(fontSize: 17, color: Color(0xFFFF3B30))),
                    trailing: Icon(Icons.chevron_right, color: Color(0xFFFF3B30)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildCalendar extends StatefulWidget {
  final JourneyController journeyController;
  const BuildCalendar({required this.journeyController, Key? key}) : super(key: key);

  @override
  State<BuildCalendar> createState() => _BuildCalendarState();
}

class _BuildCalendarState extends State<BuildCalendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: widget.journeyController.isTimeWidget.value
          ? Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: 220, width: Get.width - 30,
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('Time', style: staticTextStyle(16, blackTextColor)),
                Expanded(child: TimePickerSpinner(
                  is24HourMode: false,
                  normalTextStyle: staticTextStyle(20, blackTextColor.withOpacity(0.5)),
                  highlightedTextStyle: const TextStyle(fontSize: 24, color: blackTextColor),
                  spacing: 20, itemHeight: 40, isForce2Digits: true,
                  onTimeChange: (time) {
                    widget.journeyController.dateTime.value = DateTime(
                      widget.journeyController.dateTime.value.year,
                      widget.journeyController.dateTime.value.month,
                      widget.journeyController.dateTime.value.day,
                      time.hour, time.minute, time.second,
                    );
                  },
                )),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 50, width: Get.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: blueColor),
                    child: Center(child: Text('Save', style: staticTextStyle(16, whiteColor))),
                  ),
                ),
              ]),
            )
          : Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: 500, width: Get.width - 30,
              child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text('Calendar', style: staticTextStyle(16, blackTextColor)),
                Expanded(child: TableCalendar(
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(shape: BoxShape.circle, color: blueColor),
                  ),
                  calendarFormat: _calendarFormat,
                  headerStyle: HeaderStyle(
                    titleTextStyle: staticTextStyle(16, blueColor),
                    formatButtonVisible: false, formatButtonShowsNext: false, titleCentered: true,
                  ),
                  onDaySelected: (selectedDay, focusedDay) {
                    widget.journeyController.dateTime.value = selectedDay;
                    widget.journeyController.focusedDateTime.value = focusedDay;
                    setState(() {});
                  },
                  currentDay: widget.journeyController.dateTime.value,
                  focusedDay: widget.journeyController.focusedDateTime.value,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2040, 3, 14),
                )),
                GestureDetector(
                  onTap: () { widget.journeyController.isTimeWidget.value = true; setState(() {}); },
                  child: Container(
                    height: 50, width: Get.width,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: blueColor),
                    child: Center(child: Text('Continue', style: staticTextStyle(16, whiteColor))),
                  ),
                ),
              ]),
            ),
    );
  }
}

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
}

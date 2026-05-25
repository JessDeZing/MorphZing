import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
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
import 'package:morphzing/presentation/widgets/journal/build_journey.dart';
import 'package:morphzing/presentation/widgets/journal/journey_bottomsheet_widget.dart';
import 'package:morphzing/presentation/widgets/journal/multiple_all_images_widget.dart';
import 'package:morphzing/presentation/widgets/journal/multiple_image_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/style/colors.dart';

class PostJourneyScreen extends StatefulWidget {
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
  final int? id;

  const PostJourneyScreen({
    Key? key,
    this.journeyTime,
    this.noteName,
    this.description,
    this.audio,
    this.draw,
    this.location,
    this.webLink,
    this.document,
    this.id,
  }) : super(key: key);

  @override
  State<PostJourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<PostJourneyScreen> {
  final journalController = Get.find<JournalController>();
  final journeyController = Get.put(JourneyController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: whiteColor,
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
        body: (journalController.loading.value)
            ? const Center(
                child: CupertinoActivityIndicator(),
              )
            : journalController.model.value.isEmpty
                ? const Center(
                    child: Text(
                      "No Today’s Journey",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF676A8B),
                      ),
                    ),
                  )
                : SafeArea(
                    child: ListView.builder(
                      itemCount: journalController.model.value.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return BuildJourney(
                          model: journalController.model.value[index],
                          index: index,
                        );
                      },
                    ),
                  ),
      );
    });
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

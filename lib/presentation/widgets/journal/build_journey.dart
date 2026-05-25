import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/presentation/pages/screens/journal/post_journey_screen.dart';
import 'package:morphzing/presentation/widgets/journal/multiple_all_images_widget.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildJourney extends StatefulWidget {
  final JournalModel model;
  final int index;
  const BuildJourney({super.key, required this.model, this.index = 0});

  @override
  State<BuildJourney> createState() => _BuildJourneyState();
}

class _BuildJourneyState extends State<BuildJourney> {
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          height: 50,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.jm().format(widget.model.journeyTime!),
                      style: staticTextStyle(
                        12,
                        isDark ? Colors.white : greyTextColor,
                      ),
                    ),
                    Text(
                      '${DateFormat.MMMMd().format(widget.model.journeyTime!)}, ${DateFormat.y().format(widget.model.journeyTime!)}',
                      style: staticTextStyle(
                        16,
                        blackTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.event_note,
                    color: blueColor,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Divider(
            height: 1,
            color: isDark ? Colors.white : greyTextColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: SizedBox(
            height: 30,
            width: Get.width,
            child: TextField(
              onChanged: (e) {
                setState(() {});
              },
              readOnly: true,
              controller: TextEditingController(text: widget.model.noteName),
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Title name',
              ),
              style: staticTextStyle(
                20,
                isDark ? Colors.white : blackTextColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Container(
            padding: const EdgeInsets.all(8),
            color: isDark ? darkBgColor : whiteColor,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: greyTextColor.withOpacity(0.3),
                )),
            height: 200,
            width: Get.width,
            child: TextField(
              maxLines: 8,
              readOnly: true,
              controller: TextEditingController(text: widget.model.description),
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Descriptions',
              ),
              style: staticTextStyle(
                14,
                isDark ? Colors.white : blackTextColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: (widget.model.images ?? []).isNotEmpty
              ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8)
              : const EdgeInsets.all(0),
          child: MultipleAllImagesWidget(
            onMore: () {},
            index: widget.index,
          ),
        ),
        if (widget.model.drawUrl != null &&
            widget.model.drawUrl != "null" &&
            widget.model.drawUrl!.isNotEmpty) ...{
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: SizedBox(
              height: 300,
              width: Get.width,
              child: Image.network(
                widget.model.drawUrl!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        } else ...{
          const SizedBox(height: 8),
        },
        if (widget.model.webLink != null &&
            widget.model.webLink != "null" &&
            widget.model.webLink!.isNotEmpty) ...{
          CupertinoButton(
            alignment: Alignment.centerLeft,
            onPressed: () async {
              final urlText = widget.model.webLink!;

              final Uri myUrl = Uri.parse(urlText);
              if (!await launchUrl(myUrl)) {
                return;
              }
            },
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              (widget.model.webLink!.startsWith("https://")
                  ? "${widget.model.webLink!.split("/")[2]}/${widget.model.webLink!.split("/")[3]}"
                  : widget.model.webLink!),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4890FF),
                decoration: TextDecoration.underline,
              ),
            ),
          )
        },
        if (widget.model.location != null &&
            widget.model.location != "null" &&
            widget.model.location!.isNotEmpty) ...{
          CupertinoButton(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onPressed: () async {
              // https://www.google.com/maps/place/Kukcha+Mosque/@41.3216428,69.2043121,15z/data=!4m5!3m4!1s0x38ae8bfa8c4225e5:0x28f17ddc027649c6!8m2!3d41.3227628!4d69.2048432
              final urlText = widget.model.location!;

              if (urlText.startsWith("https://")) {
                final Uri myUrl = Uri.parse(urlText);

                if (!await launchUrl(myUrl)) {
                  return;
                }
              }
            },
            child: Text(
              (widget.model.location!.startsWith("https://")
                  ? "${widget.model.location!.split("/")[2]}/${widget.model.location!.split("/")[3]}"
                  : widget.model.location!),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4890FF),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        },
        if (widget.model.documentUrl != null &&
            widget.model.documentUrl != "null" &&
            widget.model.documentUrl!.isNotEmpty) ...{
          CupertinoButton(
            onPressed: () {
              OpenFile.open(widget.model.documentUrl);
            },
            padding: const EdgeInsets.all(0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                child: Icon(
                  Icons.file_download_outlined,
                  color:
                      isDark ? Theme.of(context).cardTheme.color : Colors.black,
                ),
              ),
              title: Text(
                widget.model.documentUrl?.split("/").last ?? "Unkown",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              subtitle: Text(
                widget.model.documentUrl?.split("/").last ?? "Unknown",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: isDark
                      ? Theme.of(context).textTheme.bodyMedium?.color
                      : Color(0xFF676A8B),
                ),
              ),
              // trailing: Text(
              //   ((journeyController.documentFile?.size ?? 1) / 1000000)
              //           .toString()
              //           .split(".")[0] +
              //       "." +
              //       ((journeyController.documentFile?.size ?? 1) / 1000000)
              //           .toString()
              //           .split(".")[1]
              //           .substring(0, 2) +
              //       " MB",
              //   style: const TextStyle(
              //     fontWeight: FontWeight.w400,
              //     fontSize: 12,
              //     color: Color(0xFF676A8B),
              //   ),
              // ),
            ),
          )
        },
        if (widget.model.audioUrl != null &&
            widget.model.audioUrl != "null" &&
            widget.model.audioUrl!.isNotEmpty) ...{
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          if (widget.model.audioUrl!.isNotEmpty) {
                            final source = UrlSource(widget.model.audioUrl!);
                            await audioPlayer.play(source);
                          }
                        }
                      },
                      padding: const EdgeInsets.all(0),
                      child: CircleAvatar(
                        radius: 16,
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
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
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                    },
                  ),
                ),
              ],
            ),
          ),
        },
        const SizedBox(height: 12),
      ],
    );
  }
}

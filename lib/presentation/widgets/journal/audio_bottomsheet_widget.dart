import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:morphzing/logic/controllers/journal/journey_controller.dart';
import 'package:get/get.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioBottomSheetWidget extends StatefulWidget {
  final Function(String value) onChangePath;

  const AudioBottomSheetWidget({Key? key, required this.onChangePath})
      : super(key: key);

  @override
  State<AudioBottomSheetWidget> createState() => _AudioBottomSheetWidgetState();
}

class _AudioBottomSheetWidgetState extends State<AudioBottomSheetWidget> {
  final _audioRecorder = AudioRecorder();
  int _recordDuration = 0;
  Timer? _timer;
  bool isPlaying = false;

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> startRecord() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        if (Platform.isIOS) {
          var directory = await getApplicationDocumentsDirectory();
          debugPrint("${DateTime.now().microsecond}.m4a");
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: directory.path +
                '/${DateTime.now().microsecondsSinceEpoch}.m4a',
          );
        } else {
          var directory = await getApplicationDocumentsDirectory();
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.aacLc),
            path: directory.path +
                '/${DateTime.now().microsecondsSinceEpoch}.m4a',
          );
        }
        _recordDuration = 0;

        startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  Future<String?> stopRecord() async {
    _timer?.cancel();

    final path = await _audioRecorder.stop();

    if (path != null) {
      return path;
    }
    return null;
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      '$minutes : $seconds',
      style: TextStyle(
          color: isDark ? whiteColor : Color(0xff0D0222),
          fontWeight: FontWeight.w500,
          fontSize: 12),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 100,
      alignment: Alignment.center,
      width: Get.width,
      color: isDark ? darkBgColor : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.delete,
                  color: todayColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      _buildTimer(),
                      const Spacer(),
                      CupertinoButton(
                        onPressed: () async {
                          if (await _audioRecorder.isRecording()) {
                            String? path = await stopRecord();

                            isPlaying = false;

                            setState(() {});

                            debugPrint("the current path is $path");
                            if (path == null) return;

                            widget.onChangePath(path);
                          } else {
                            await startRecord();
                            isPlaying = true;
                            setState(() {});
                          }
                        },
                        padding: const EdgeInsets.all(0),
                        child: CircleAvatar(
                          radius: 22,
                          child: Icon(
                            isPlaying ? Icons.stop : Icons.mic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SocialMediaRecorder(
                  //   sendRequestFunction: (soundFile) async {
                  //     String path = soundFile.path;

                  //     debugPrint("the current path is $path");

                  //     widget.journeyController.pathAudio(path);
                  //     setState(() {});
                  //   },
                  //   encode: AudioEncoderType.AAC,
                  // ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

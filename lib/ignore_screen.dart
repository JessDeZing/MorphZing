// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:social_media_recorder/audio_encoder_type.dart';
// import 'package:social_media_recorder/screen/social_media_recorder.dart';

// enum AudioEncoder {
//   /// Will output to MPEG_4 format container
//   AAC,

//   /// Will output to MPEG_4 format container
//   AAC_LD,

//   /// Will output to MPEG_4 format container
//   AAC_HE,

//   /// sampling rate should be set to 8kHz
//   /// Will output to 3GP format container on Android
//   AMR_NB,

//   /// sampling rate should be set to 16kHz
//   /// Will output to 3GP format container on Android
//   AMR_WB,

//   /// Will output to MPEG_4 format container
//   /// /!\ SDK 29 on Android /!\
//   /// /!\ SDK 11 on iOs /!\
//   OPUS,
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final audioPlayer = AudioPlayer();
//   bool isPlaying = false;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;
//   String path = "";

//   @override
//   void initState() {
//     audioPlayer.onPlayerStateChanged.listen((state) {
//       setState(() {
//         isPlaying = state == PlayerState.playing;
//       });
//     });

//     audioPlayer.onDurationChanged.listen((newDuration) {
//       setState(() {
//         duration = newDuration;
//       });
//     });

//     audioPlayer.onPositionChanged.listen((newPosition) {
//       setState(() {
//         position = newPosition;
//       });
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Center(
//             child: Column(
//               children: [
//                 const Spacer(),
//                 if (path.isNotEmpty) ...{
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: Row(
//                       children: [
//                         Column(
//                           children: [
//                             CupertinoButton(
//                               onPressed: () async {
//                                 if (isPlaying) {
//                                   await audioPlayer.pause();
//                                 } else {
//                                   if (path.isNotEmpty) {
//                                     final source = DeviceFileSource(path);
//                                     await audioPlayer.play(source);
//                                   }
//                                 }
//                               },
//                               padding: const EdgeInsets.all(0),
//                               child: CircleAvatar(
//                                 radius: 16,
//                                 child: Icon(
//                                   isPlaying ? Icons.pause : Icons.play_arrow,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               formatTime(position),
//                             ),
//                           ],
//                         ),
//                         Expanded(
//                           child: Slider(
//                             min: 0,
//                             max: duration.inSeconds.toDouble(),
//                             value: position.inSeconds.toDouble(),
//                             onChanged: (double value) async {
//                               final position = Duration(seconds: value.toInt());
//                               await audioPlayer.seek(position);
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 },
//                 Padding(
//                   padding: const EdgeInsets.only(top: 140),
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: SocialMediaRecorder(
//                       sendRequestFunction: (soundFile) {
//                         debugPrint("the current path is ${soundFile.path}");
//                         path = soundFile.path;
//                         setState(() {});
//                       },
//                       encode: AudioEncoderType.AAC,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// String formatTime(Duration duration) {
//   String twoDigits(int n) => n.toString().padLeft(2, "0");
//   final hours = twoDigits(duration.inHours);
//   final minutes = twoDigits(duration.inMinutes.remainder(60));
//   final seconds = twoDigits(duration.inSeconds.remainder(60));

//   return [
//     if (duration.inHours > 0) hours,
//     minutes,
//     seconds,
//   ].join(":");
// }

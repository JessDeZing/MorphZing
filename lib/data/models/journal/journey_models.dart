import 'dart:io';

import 'package:morphzing/data/models/journal/journal_model.dart';

class JourneyModelPhotos {
  JourneyModelPhotos({
    required this.journeyTime,
    required this.noteName,
    this.description,
    this.audio,
    this.draw,
    this.location,
    this.webLink,
    this.document,
    this.photos,
    required this.user,
  });

  String journeyTime;
  String noteName;
  String? description;
  File? audio;
  File? draw;
  String? location;
  String? webLink;
  File? document;
  List<Photo>? photos;
  int user;

  factory JourneyModelPhotos.fromJson(Map<String, dynamic> json) =>
      JourneyModelPhotos(
        journeyTime: json["journey_time"],
        noteName: json["note_name"],
        description: json["description"],
        audio: json["audio"],
        draw: json["draw"],
        location: json["location"],
        webLink: json["web_link"],
        document: json["document"],
        photos: json["photos"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "journey_time": journeyTime,
        "note_name": noteName,
        "description": description,
        "audio": audio,
        "draw": draw,
        "web_link": webLink,
        "document": document,
        "photos": photos,
        "user": user,
      };
}

class JourneyModel {
  JourneyModel({
    required this.journeyTime,
    required this.noteName,
    this.description,
    this.audio,
    this.draw,
    this.location,
    this.webLink,
    this.document,
    this.images,
    required this.user,
  });

  String journeyTime;
  String noteName;
  String? description;
  File? audio;
  File? draw;
  String? location;
  String? webLink;
  File? document;
  List? images;
  int user;

  factory JourneyModel.fromJson(Map<String, dynamic> json) => JourneyModel(
        journeyTime: json["journey_time"],
        noteName: json["note_name"],
        description: json["description"],
        audio: json["audio"],
        draw: json["draw"],
        location: json["location"],
        webLink: json["web_link"],
        document: json["document"],
        images: json["images"],
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "journey_time": journeyTime,
        "note_name": noteName,
        "description": description,
        "audio": audio,
        "draw": draw,
        "web_link": webLink,
        "document": document,
        "images": images,
        "user": user,
      };
}

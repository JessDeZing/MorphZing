// To parse this JSON data, do
//
//     final journalModel = journalModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';

JournalModel journalModelFromJson(String str) => JournalModel.fromJson(json.decode(str));

String journalModelToJson(JournalModel data) => json.encode(data.toJson());

class JournalModel {
  JournalModel({
    required this.id,
    required this.journeyTime,
    required this.noteName,
    required this.description,
    required this.audio,
    required this.draw,
    required this.location,
    required this.audioUrl,
    required this.webLink,
    required this.documentUrl,
    required this.documentName,
    required this.documentSize,
    required this.documentDescription,
    required this.drawUrl,
    required this.images,
    required this.templateUrl,
    required this.user,
    bool? isPlaying,
    Duration? duration,
    Duration? position,
  }) {
    this.isPlaying = isPlaying ?? false;
    this.duration = duration ?? Duration.zero;
    this.position = position ?? Duration.zero;
  }

  int id;
  DateTime? journeyTime;
  String noteName;
  String? description;
  String? audio;
  String? draw;
  String? location;
  String? audioUrl;
  String? webLink;
  String? documentUrl;
  String? documentName;
  int? documentSize;
  String? documentDescription;
  String? drawUrl;
  String? templateUrl;
  List<Photo>? images;
  int user;
  late bool isPlaying;
  late Duration duration;
  late Duration position;

  factory JournalModel.fromJson(Map<String, dynamic> json) => JournalModel(
        id: json["id"],
        journeyTime: DateTime.parse(json["journey_time"]),
        noteName: json["note_name"],
        description: json["description"],
        audio: json["audio"],
        draw: json["draw"],
        location: json["location"],
        audioUrl: json["audio_url"],
        webLink: json["web_link"],
        documentUrl: json["document_url"],
        documentName: json["document_name"],
        documentSize: json["document_size"],
        documentDescription: json["document_desc"],
        drawUrl: json["draw_url"],
        templateUrl: json['user_template_image'],
        images: List<Photo>.from(json["images"].map((x) => Photo.fromJson(x))),
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "journey_time": journeyTime!.toIso8601String(),
        "note_name": noteName,
        "description": description,
        "audio": audio,
        "draw": draw,
        "location": location,
        "audio_url": audioUrl,
        "web_link": webLink,
        "document_url": documentUrl,
        'document_name': documentName,
        'document_size': documentSize,
        'document_desc': documentDescription,
        "draw_url": drawUrl,
        "user_template_image": templateUrl,
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
        "user": user,
      };
}

class Photo {
  Photo({
    this.id,
    this.image,
    this.post,
    this.imageUrl,
    this.file,
  });

  int? id;
  String? image;
  int? post;
  String? imageUrl;
  File? file;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        image: json["image"],
        post: json["post"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "post": post,
        "image_url": imageUrl,
      };

  Photo copyWith({
    int? id,
    String? image,
    int? post,
    String? imageUrl,
    File? file,
  }) {
    return Photo(
      id: id ?? this.id,
      image: image ?? this.image,
      post: post ?? this.post,
      imageUrl: imageUrl ?? this.imageUrl,
      file: file ?? this.file,
    );
  }
}

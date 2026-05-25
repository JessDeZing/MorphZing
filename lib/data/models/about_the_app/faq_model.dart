// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

FaqModel? faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel? data) => json.encode(data!.toJson());

class FaqModel {
  FaqModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  int? count;
  dynamic next;
  dynamic previous;
  List<Result?>? results;

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null
            ? []
            : List<Result?>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": results == null
            ? []
            : List<dynamic>.from(results!.map((x) => x!.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.question,
    this.answer,
    this.createdDate,
    this.updatedDate,
  });

  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? question;
  String? answer;
  DateTime? createdDate;
  DateTime? updatedDate;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        question: json["question"],
        answer: json["answer"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedDate: DateTime.parse(json["updated_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "question": question,
        "answer": answer,
        "created_date": createdDate?.toIso8601String(),
        "updated_date": updatedDate?.toIso8601String(),
      };
}


import 'dart:convert';

JournalStreakModel journalStreakModelFromJson(String str) => JournalStreakModel.fromJson(json.decode(str));

String journalStreakModelToJson(JournalStreakModel data) => json.encode(data.toJson());

class JournalStreakModel {
  JournalStreakModel({
    required this.streakCount,
    required this.totalEntries,
    required this.weekStreak,
  });

  int streakCount;
  int totalEntries;
  int weekStreak;

  factory JournalStreakModel.fromJson(Map<String, dynamic> json) => JournalStreakModel(
    streakCount: json["streak_count"],
    totalEntries: json["total_entries"],
    weekStreak: json["week_streak"],
  );

  Map<String, dynamic> toJson() => {
    "streak_count": streakCount,
    "total_entries": totalEntries,
    "week_streak": weekStreak,
  };
}

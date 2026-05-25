import 'dart:ui';
import 'package:morphzing/data/models/agenda/event.dart';

class InvitationArguments {
  final String categoryName;
  final List<Event> eventList;
  final Color? color;
  final List<String>? travelPictures;

  const InvitationArguments({
    required this.categoryName,
    required this.eventList,
    this.color,
    this.travelPictures,
  });
}

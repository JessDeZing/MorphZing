import 'package:flutter/material.dart';

class EventInfoBottomSheet extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventInfoBottomSheet({Key? key, required this.event}) : super(key: key);

  static Future show({
    required BuildContext context,
    required Map<String, dynamic> event,
  }) =>
      showModalBottomSheet(
        context: context,
        builder: (_) => EventInfoBottomSheet(event: event),
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
      );

  @override
  State<EventInfoBottomSheet> createState() => _EventInfoBottomSheetState();
}

class _EventInfoBottomSheetState extends State<EventInfoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(widget.event['title'] ?? 'Event'),
    );
  }
}

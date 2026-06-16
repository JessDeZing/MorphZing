import 'package:flutter/material.dart';

class TaskInfoBottomSheet extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskInfoBottomSheet({Key? key, required this.task}) : super(key: key);

  static Future show({
    required BuildContext context,
    required Map<String, dynamic> task,
  }) =>
      showModalBottomSheet(
        context: context,
        builder: (_) => TaskInfoBottomSheet(task: task),
        isScrollControlled: true,
        enableDrag: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
      );

  @override
  State<TaskInfoBottomSheet> createState() => _TaskInfoBottomSheetState();
}

class _TaskInfoBottomSheetState extends State<TaskInfoBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Text(widget.task['title'] ?? 'Task'),
    );
  }
}

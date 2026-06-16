import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'note_controller.dart';

class NoteScreen extends GetView<NoteController> {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.notes.length,
        itemBuilder: (context, index) {
          final note = controller.notes[index];
          return ListTile(
            title: Text(note.title ?? ''),
            onTap: () => controller.openNote(note),
          );
        },
      )),
    );
  }
}

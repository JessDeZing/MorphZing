import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/journal/note.dart';
import 'package:morphzing/data/repositories/journal/note_repository.dart';
import 'package:morphzing/di/di_config.dart';

class NoteController extends GetxController {
  final NoteRepository _noteRepository = getIt<NoteRepository>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final RxBool isSaving = false.obs;
  Note? existingNote;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Note) {
      existingNote = args;
      titleController.text = args.noteName ?? '';
      descriptionController.text = args.noteDescription ?? '';
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  bool get isEditing => existingNote != null;

  void saveNote() async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Error', 'Title cannot be empty',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isSaving.value = true;
    try {
      if (isEditing) {
        await _noteRepository.updateNote(
          id: existingNote!.id!,
          noteName: title,
          description: descriptionController.text.trim(),
        );
      } else {
        await _noteRepository.createNote(
          noteName: title,
          noteTime: DateTime.now().toIso8601String(),
          description: descriptionController.text.trim(),
        );
      }
      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSaving.value = false;
    }
  }

  // kept for compatibility
  final notes = [].obs;
  void openNote(dynamic note) => Get.back();
}

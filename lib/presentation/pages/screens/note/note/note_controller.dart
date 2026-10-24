import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/show_error.dart';
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

  void saveNote({bool silent = false}) async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      if (silent) { Get.back(); return; }
      showErrorSnackBar(message: noteTitleRequired.tr);
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
      if (e is! DioException) showErrorSnackBar(message: somethingWentWrongRetry.tr);
    } finally {
      isSaving.value = false;
    }
  }

  void deleteNote() async {
    if (!isEditing) return;
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(onPressed: () => Get.back(result: true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _noteRepository.deleteNote(id: existingNote!.id!);
      Get.back(result: true);
    } catch (e) {
      if (e is! DioException) showErrorSnackBar(message: somethingWentWrongRetry.tr);
    }
  }

  // kept for compatibility
  final notes = [].obs;
  void openNote(dynamic note) => Get.back();
}

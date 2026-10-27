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
    if (isSaving.value) return; // back + Save at the same time: save once
    final description = descriptionController.text.trim();
    var title = titleController.text.trim();
    // Title is optional: use the first 3 words of the note (like Journal)
    if (title.isEmpty) title = _titleFromText(description);
    if (title.isEmpty) {
      Get.back(); // nothing typed: leave without saving
      return;
    }
    isSaving.value = true;
    try {
      if (isEditing) {
        await _noteRepository.updateNote(
          id: existingNote!.id!,
          noteName: title,
          description: description,
        );
      } else {
        await _noteRepository.createNote(
          noteName: title,
          noteTime: DateTime.now().toIso8601String(),
          description: description,
        );
      }
      Get.back(result: true);
    } catch (e) {
      if (e is! DioException) showErrorSnackBar(message: somethingWentWrongRetry.tr);
    } finally {
      isSaving.value = false;
    }
  }

  // First 3 words of the note, max 50 characters
  String _titleFromText(String text) {
    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).take(3).join(' ');
    return words.length > 50 ? words.substring(0, 50) : words;
  }

  void deleteNote() async {
    if (!isEditing) return;
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: Text(noteDeleteQuestion.tr),
        content: Text(cannotBeUndone.tr),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: Text(cancel.tr)),
          TextButton(onPressed: () => Get.back(result: true), child: Text(delete.tr, style: const TextStyle(color: Colors.red))),
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

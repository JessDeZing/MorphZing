path = './lib/presentation/pages/screens/note/note/note_controller.dart'
with open(path, 'r') as f:
    content = f.read()

old = '''  void saveNote() async {
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
  }'''

new = '''  void saveNote({bool silent = false}) async {
    final title = titleController.text.trim();
    if (title.isEmpty) {
      if (silent) { Get.back(); return; }
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
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }'''

if old in content:
    content = content.replace(old, new)
    with open(path, 'w') as f:
        f.write(content)
    print('Done')
else:
    print('ERROR: old text not found - no changes made')

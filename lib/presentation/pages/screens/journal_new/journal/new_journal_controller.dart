import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/repositories/journal/new_journal_repository.dart';
import 'package:morphzing/di/di_config.dart';

class NewJournalController extends GetxController {
  final NewJournalRepository _repo = getIt<NewJournalRepository>();
  final box = GetStorage();

  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;

  JournalModel? journalToEdit;
  bool get isJournalEdit => journalToEdit != null;

  @override
  void onReady() {
    final args = Get.arguments;
    if (args is JournalModel) {
      journalToEdit = args;
    }
    super.onReady();
  }

  Future<bool> saveJournal({
    required String title,
    required String description,
    required DateTime journeyTime,
  }) async {
    if (title.trim().isEmpty) {
      errorMessage.value = 'Please enter a title';
      return false;
    }
    isSaving.value = true;
    errorMessage.value = '';
    try {
      if (isJournalEdit) {
        await _repo.updateJournal(
          id: journalToEdit!.id,
          noteName: title.trim(),
          description: description.trim(),
          journeyTime: journeyTime.toIso8601String(),
        );
      } else {
        await _repo.createJournal(
          noteName: title.trim(),
          description: description.trim(),
          journeyTime: journeyTime.toIso8601String(),
        );
      }
      isSaving.value = false;
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to save. Please try again.';
      isSaving.value = false;
      return false;
    }
  }

  Future<bool> deleteJournal() async {
    if (journalToEdit == null) return false;
    isSaving.value = true;
    try {
      await _repo.journeyDelete(id: journalToEdit!.id);
      isSaving.value = false;
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to delete.';
      isSaving.value = false;
      return false;
    }
  }
}

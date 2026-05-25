import 'package:get/get.dart';
import 'package:morphzing/data/models/journal/note.dart';
import 'package:morphzing/data/repositories/journal/note_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/utils/loading_overlay.dart';

class CreateFolderBottomController extends GetxController {
  final NoteRepository _noteRepository = getIt();

  final RxString _folderTitle = ''.obs;

  String get folderTitle => _folderTitle.value;

  set folderTitle(value) => _folderTitle.value = value;

  bool isValidate() {
    if (_folderTitle.value.isNotEmpty) {
      return true;
    }

    return false;
  }

  void createFolder() {
    _noteRepository.createFolder(name: _folderTitle.value).then((value) {
      LoadingOverlay.hide();
      Get.back(result: true);
    }).catchError(
      (e) => LoadingOverlay.hide(),
    );
  }
}

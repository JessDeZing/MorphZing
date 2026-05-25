import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/folder.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/journal/journal_streak_model.dart';
import 'package:morphzing/data/models/journal/note.dart';
import 'package:morphzing/data/repositories/journal/new_journal_repository.dart';
import 'package:morphzing/data/repositories/journal/note_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/bottom_picker/note/move_foder_bottom/move_folder_bottom_sheet.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/sorting_utils.dart';

class MyNoteController extends GetxController {
  final Folder folder = Get.arguments as Folder;

  final NoteRepository _noteRepository = getIt<NoteRepository>();
  final Rx<RxStatus> _rxStatus = Rx<RxStatus>(RxStatus.empty());
  final RxList<Note> _response = RxList<Note>([]);
  final RxBool _isChecking = false.obs;

  bool isUpdated = false;

  int currentPage = 1;

  RxStatus get rxStatus => _rxStatus.value;

  List<Note> get response => _response.value;

  bool get isChecking => _isChecking.value;

  set isChecking(value) => _isChecking.value = value;

  @override
  void onReady() {
    _getNoteList();
    super.onReady();
  }

  void _getNoteList() async {
    _rxStatus.value = RxStatus.loading();
    currentPage = 1;
    _noteRepository.getNoteListByFolderId(folder.id!).then((value) {
      List<Note> notes = value.noteList != null ? [...value.noteList!] : [];

      // Sort notes alphabetically by name
      _response.value = SortingUtils.sortNotesAlphabetically(notes);
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  void openUpdateNoteScreen(Note note) {
    Get.toNamed(noteRoute, arguments: note)?.then((value) {
      if (value != null) {
        _getNoteList();
      }
    });
  }

  void openNoteScreen() {
    Get.toNamed(noteRoute, arguments: folder)?.then((value) {
      if (value != null) {
        isUpdated = true;
        _getNoteList();
      }
    });
  }

  void onChangeNoteChecked(int checkedIndex) {
    List<Note> newList = [];
    for (int i = 0; i < response.length; i++) {
      if (i == checkedIndex) {
        newList.add(
            response[i].copyWith(isChecked: !response[checkedIndex].isChecked));
      } else {
        newList.add(response[i]);
      }
    }
    _response.value = newList;
  }

  void onCancel() {
    List<Note> newList = [];
    for (int i = 0; i < response.length; i++) {
      newList.add(response[i].copyWith(isChecked: false));
    }
    _response.value = newList;
    _isChecking.value = false;
  }

  void onSelectAll() {
    List<Note> newList = [];
    for (int i = 0; i < response.length; i++) {
      newList.add(response[i].copyWith(isChecked: true));
    }
    _response.value = newList;
  }

  bool isValidate() {
    if (response.where((element) => element.isChecked).isNotEmpty) return true;

    return false;
  }

  void openMoveFolderBottom(context) {
    MoveFolderBottomSheet.show(
      context: context,
      list: response.where((element) => element.isChecked).toList(),
      folder: folder,
    ).then((value) {
      if (value != null) {
        isUpdated = true;
        _isChecking.value = false;
        _getNoteList();
      }
    });
  }

  void removeFromFolder() {
    List<int> ids = [];
    for (Note note in _response) {
      if (note.isChecked) ids.add(note.id!);
    }
    _noteRepository.removeFromFolder(ids).then((value) {
      LoadingOverlay.hide();
      isUpdated = true;
      _isChecking.value = false;
      _getNoteList();
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  void reorderNotes(int oldIndex, int newIndex) {
    print('My Note - Reorder: $oldIndex -> $newIndex');
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    print('My Note - Adjusted newIndex: $newIndex');
    final note = _response.removeAt(oldIndex);
    _response.insert(newIndex, note);
    update();
  }
}

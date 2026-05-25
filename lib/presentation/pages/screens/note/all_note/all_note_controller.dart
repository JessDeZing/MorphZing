import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/note.dart';
import 'package:morphzing/data/repositories/journal/note_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/bottom_picker/note/all_folder_bottom/all_folder_bottom_sheet.dart';
import 'package:morphzing/presentation/bottom_picker/note/create_folder_bottom/create_folder_bottom_sheet.dart';
import 'package:morphzing/presentation/bottom_picker/note/move_foder_bottom/move_folder_bottom_sheet.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

class AllNoteController extends GetxController {
  final NoteRepository _noteRepository = getIt<NoteRepository>();
  final Rx<RxStatus> _rxStatus = Rx<RxStatus>(RxStatus.empty());
  final Rx<ApiPagination<Note>> _response =
      Rx<ApiPagination<Note>>(ApiPagination(total: 0, data: []));
  final RxBool _isChecking = false.obs;
  final RxSet<int> _pinnedNoteIds = <int>{}.obs;
  final RxList<int> _noteOrder = <int>[].obs;
  final GetStorage _storage = GetStorage();
  Timer? _autoSaveTimer;
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;
  final RxString _currentFilter = 'all'.obs; // 'all', 'alphabetical', 'date'

  int currentPage = 1;

  RxStatus get rxStatus => _rxStatus.value;

  ApiPagination<Note> get response => _response.value;

  List<Note> get orderedNotes {
    List<Note> notes = List.from(_response.value.data);

    // Separate pinned and unpinned notes
    List<Note> pinnedNotes =
        notes.where((note) => _pinnedNoteIds.contains(note.id)).toList();
    List<Note> unpinnedNotes =
        notes.where((note) => !_pinnedNoteIds.contains(note.id)).toList();

    // Apply filter based on current selection
    switch (_currentFilter.value) {
      case 'alphabetical':
        pinnedNotes.sort((a, b) {
          final nameA = a.noteName?.toLowerCase() ?? '';
          final nameB = b.noteName?.toLowerCase() ?? '';
          return nameA.compareTo(nameB);
        });
        unpinnedNotes.sort((a, b) {
          final nameA = a.noteName?.toLowerCase() ?? '';
          final nameB = b.noteName?.toLowerCase() ?? '';
          return nameA.compareTo(nameB);
        });
        break;
      // case 'date':
      //   pinnedNotes.sort((a, b) {
      //     final dateA = a.updatedTime ?? DateTime(1970);
      //     final dateB = b.updatedTime ?? DateTime(1970);
      //     return dateB.compareTo(dateA); // Newest first
      //   });
      //   unpinnedNotes.sort((a, b) {
      //     final dateA = a.updatedTime ?? DateTime(1970);
      //     final dateB = b.updatedTime ?? DateTime(1970);
      //     return dateB.compareTo(dateA); // Newest first
      //   });
      //   break;
      case 'custom':
        // Sort pinned notes by custom order only
        if (_noteOrder.isNotEmpty) {
          Map<int, int> orderMap = {};
          for (int i = 0; i < _noteOrder.length; i++) {
            orderMap[_noteOrder[i]] = i;
          }

          pinnedNotes.sort((a, b) {
            int aOrder = orderMap[a.id] ?? 999;
            int bOrder = orderMap[b.id] ?? 999;
            return aOrder.compareTo(bOrder);
          });

          unpinnedNotes.sort((a, b) {
            int aOrder = orderMap[a.id] ?? 999;
            int bOrder = orderMap[b.id] ?? 999;
            return aOrder.compareTo(bOrder);
          });
        }
        break;
      default: // 'all' - keep original order
        break;
    }

    // Return pinned notes first, then unpinned notes
    return [...pinnedNotes, ...unpinnedNotes];
  }

  bool get isChecking => _isChecking.value;

  set isChecking(value) => _isChecking.value = value;

  bool isNotePinned(int? noteId) => _pinnedNoteIds.contains(noteId);

  String get currentFilter => _currentFilter.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedData();
    _setupScrollListener();
  }

  @override
  void onReady() {
    _getNoteList();
    super.onReady();
  }

  @override
  void onClose() {
    _autoSaveTimer?.cancel();
    scrollController.dispose();
    super.onClose();
  }

  void _loadSavedData() {
    List<dynamic>? savedPinnedIds = _storage.read<List>('pinned_note_ids');
    if (savedPinnedIds != null) {
      _pinnedNoteIds.clear();
      _pinnedNoteIds.addAll(savedPinnedIds.cast<int>());
    }

    List<dynamic>? savedOrder = _storage.read<List>('note_order');
    if (savedOrder != null) {
      _noteOrder.assignAll(savedOrder.cast<int>());
    }
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        _loadMoreNotes();
      }
    });
  }

  void _saveData() {
    _storage.write('pinned_note_ids', _pinnedNoteIds.toList());
    _storage.write('note_order', _noteOrder.toList());
  }

  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), () {
      _saveData();
    });
  }

  void _getNoteList() async {
    _rxStatus.value = RxStatus.loading();
    currentPage = 1;
    _noteRepository.getNoteList(currentPage: currentPage).then((value) {
      _response.value = value;
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  void _loadMoreNotes() async {
    // Check if we're already loading more or if we've reached the last page
    if (isLoadingMore || _response.value.isLastPage()) {
      return;
    }

    isLoadingMore = true;
    await Future.delayed(const Duration(milliseconds: 100));
    _rxStatus.value = RxStatus.loadingMore();

    _noteRepository
        .getNoteList(
      currentPage: currentPage + 1,
    )
        .then((value) {
      currentPage = currentPage + 1;
      _response.value = ApiPagination(
          total: value.total, data: [..._response.value.data, ...value.data]);
      _rxStatus.value = RxStatus.success();
      isLoadingMore = false;
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
      isLoadingMore = false;
    });
  }

  void getPaginationJournalList() async {
    _loadMoreNotes();
  }

  void onChangeNoteChecked(int checkedIndex) {
    List<Note> newList = [];
    for (int i = 0; i < response.data.length; i++) {
      if (i == checkedIndex) {
        newList.add(response.data[i]
            .copyWith(isChecked: !response.data[checkedIndex].isChecked));
      } else {
        newList.add(response.data[i]);
      }
    }
    _response.value =
        ApiPagination(total: _response.value.total, data: newList);
  }

  void onCancel() {
    List<Note> newList = [];
    for (int i = 0; i < response.data.length; i++) {
      newList.add(response.data[i].copyWith(isChecked: false));
    }
    _response.value =
        ApiPagination(total: _response.value.total, data: newList);
    _isChecking.value = false;
  }

  void onSelectAll() {
    List<Note> newList = [];
    for (int i = 0; i < response.data.length; i++) {
      newList.add(response.data[i].copyWith(isChecked: true));
    }
    _response.value =
        ApiPagination(total: _response.value.total, data: newList);
  }

  void openNoteScreen({Note? note}) {
    Get.toNamed(noteRoute, arguments: note)?.then((value) {
      if (value != null) {
        _getNoteList();
      }
    });
  }

  void openCreateFolderBottom(context) {
    CreateFolderBottomSheet.show(context: context).then((value) {
      if (value != null) {
        _getNoteList();
      }
    });
  }

  void openMoveFolderBottom(context) {
    MoveFolderBottomSheet.show(
      context: context,
      list: response.data.where((element) => element.isChecked).toList(),
    ).then((value) {
      if (value != null) {
        _isChecking.value = false;
        _getNoteList();
      }
    });
  }

  bool isValidate() {
    return response.data.where((element) => element.isChecked).isNotEmpty;
  }

  void openAllFolder(BuildContext context) {
    AllFolderBottomSheet.show(context: context).then((value) {
      if (value != null && value) {
        _getNoteList();
      }
    });
  }

  void togglePinNote(Note note) {
    if (note.id == null) return;

    if (_pinnedNoteIds.contains(note.id)) {
      _pinnedNoteIds.remove(note.id);
      _noteOrder.remove(note.id);
    } else {
      _pinnedNoteIds.add(note.id!);
      if (!_noteOrder.contains(note.id)) {
        _noteOrder.add(note.id!);
      }
    }

    _scheduleAutoSave();
    update(); // Add this to refresh the UI
  }

  /// Simple reordering that actually changes the list order
  void setFilter(String filter) {
    _currentFilter.value = filter;
    update(); // Refresh the UI
  }

  void reorderNotes(int oldIndex, int newIndex) {
    print('Reorder: $oldIndex -> $newIndex');

    // Get the current ordered notes for index mapping
    final orderedNotesList = List<Note>.from(orderedNotes);
    if (orderedNotesList.isEmpty) {
      print('Notes list is empty');
      return;
    }

    if (oldIndex < 0 || oldIndex >= orderedNotesList.length) {
      print('Invalid oldIndex: $oldIndex, length: ${orderedNotesList.length}');
      return;
    }

    if (newIndex < 0 || newIndex >= orderedNotesList.length) {
      print('Invalid newIndex: $newIndex, length: ${orderedNotesList.length}');
      return;
    }

    // Get the note that was dragged
    final draggedNote = orderedNotesList[oldIndex];
    print('Dragged note: ${draggedNote.noteName} (ID: ${draggedNote.id})');

    // When dragging, automatically switch to custom mode to enable drag and drop
    if (_currentFilter.value != 'custom') {
      _currentFilter.value = 'custom';
      // Initialize custom order if it doesn't exist
      if (_noteOrder.isEmpty) {
        _noteOrder.addAll(
            _response.value.data.where((n) => n.id != null).map((n) => n.id!));
      }
    }

    // Get the current custom ordered list
    final customOrderedList = List<Note>.from(_response.value.data);

    // Separate pinned and unpinned notes
    List<Note> pinnedNotes = customOrderedList
        .where((note) => _pinnedNoteIds.contains(note.id))
        .toList();
    List<Note> unpinnedNotes = customOrderedList
        .where((note) => !_pinnedNoteIds.contains(note.id))
        .toList();

    // Apply custom order
    if (_noteOrder.isNotEmpty) {
      Map<int, int> orderMap = {};
      for (int i = 0; i < _noteOrder.length; i++) {
        orderMap[_noteOrder[i]] = i;
      }

      pinnedNotes.sort((a, b) {
        int aOrder = orderMap[a.id] ?? 999;
        int bOrder = orderMap[b.id] ?? 999;
        return aOrder.compareTo(bOrder);
      });

      unpinnedNotes.sort((a, b) {
        int aOrder = orderMap[a.id] ?? 999;
        int bOrder = orderMap[b.id] ?? 999;
        return aOrder.compareTo(bOrder);
      });
    }

    final finalOrderedList = [...pinnedNotes, ...unpinnedNotes];

    // Find the actual indices in the custom ordered list
    final actualOldIndex =
        finalOrderedList.indexWhere((note) => note.id == draggedNote.id);

    if (actualOldIndex == -1) {
      print('Could not find dragged note in custom ordered list');
      return;
    }

    // Remove from old position
    final removedNote = finalOrderedList.removeAt(actualOldIndex);
    print('Removed note from index $actualOldIndex');

    // Calculate new position in custom ordered list
    int actualNewIndex = newIndex;
    if (newIndex > oldIndex) {
      actualNewIndex = actualOldIndex + (newIndex - oldIndex);
    } else {
      actualNewIndex = actualOldIndex - (oldIndex - newIndex);
    }

    // Ensure bounds
    if (actualNewIndex < 0) actualNewIndex = 0;
    if (actualNewIndex > finalOrderedList.length)
      actualNewIndex = finalOrderedList.length;

    print('Inserting note at index $actualNewIndex');
    finalOrderedList.insert(actualNewIndex, removedNote);

    // Update the custom order to reflect the new arrangement
    _noteOrder.clear();
    _noteOrder
        .addAll(finalOrderedList.where((n) => n.id != null).map((n) => n.id!));

    _scheduleAutoSave();
    update();
    print('Reorder completed successfully');
  }
}

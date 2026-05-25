import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:morphzing/data/models/journal/folder.dart';
import 'package:morphzing/data/models/journal/move_folder.dart';
import 'package:morphzing/data/models/journal/note.dart';
import 'package:morphzing/data/repositories/journal/note_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/bottom_picker/note/create_folder_bottom/create_folder_bottom_sheet.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/sorting_utils.dart';

import '../../../../data/models/api_pagination.dart';

class MoveFolderBottomController extends GetxController {
  final Folder? folder;

  MoveFolderBottomController(this.folder);

  final NoteRepository _noteRepository = getIt<NoteRepository>();

  final Rx<RxStatus> _loading = Rx<RxStatus>(RxStatus.empty());

  final Rx<ApiPagination<Folder>> _response =
      Rx<ApiPagination<Folder>>(ApiPagination(total: 0, data: []));

  ApiPagination<Folder> get response => _response.value;

  RxStatus get loading => _loading.value;

  int currentPage = 1;

  @override
  void onReady() {
    _getFolderList();
    super.onReady();
  }

  void _getFolderList() async {
    _loading.value = RxStatus.loading();
    currentPage = 1;
    _noteRepository.getFolderList(currentPage: currentPage).then((value) {
      List<Folder> newList = _sortFolder(value.data);

      // Sort folders alphabetically by name
      newList = SortingUtils.sortFoldersAlphabetically(newList);

      _response.value = ApiPagination(
        total:
            newList.length == value.data.length ? value.total : value.total - 1,
        data: newList,
      );
      _loading.value = RxStatus.success();
    }).onError((error, stackTrace) {
      _loading.value = RxStatus.error(error.toString());
    });
  }

  void getPaginationFolderList() async {
    await Future.delayed(Duration(milliseconds: 100));
    _loading.value = RxStatus.loadingMore();
    _noteRepository
        .getFolderList(
      currentPage: currentPage + 1,
    )
        .then((value) {
      currentPage = currentPage + 1;
      List<Folder> newList = _sortFolder(value.data);

      // Combine existing and new data, then sort the entire list alphabetically
      List<Folder> combinedData = [..._response.value.data, ...newList];
      combinedData = SortingUtils.sortFoldersAlphabetically(combinedData);

      _response.value = ApiPagination(
        total:
            newList.length == value.data.length ? value.total : value.total - 1,
        data: combinedData,
      );
      _loading.value = RxStatus.success();
    }).catchError((e) {
      _loading.value = RxStatus.error(e.toString());
    });
  }

  List<Folder> _sortFolder(List<Folder> folderList) {
    if (folder == null) return folderList;
    List<Folder> newList = [];

    for (Folder value in folderList) {
      if (folder!.id != value.id) {
        newList.add(value);
      }
    }

    // Sort folders alphabetically by name
    return SortingUtils.sortFoldersAlphabetically(newList);
  }

  void onChecked(Folder folder) {
    List<Folder> newList = [..._response.value.data];

    for (int index = 0; index < _response.value.data.length; index++) {
      if (_response.value.data[index].id == folder.id) {
        newList[index] =
            response.data[index].copyWith(isChecked: !folder.isChecked);
      } else {
        newList[index] = response.data[index].copyWith(
            isChecked:
                folder.isChecked ? response.data[index].isChecked : false);
      }
    }
    _response.value =
        ApiPagination(total: _response.value.total, data: newList);
  }

  bool isValidate() {
    if (_response.value.data.where((element) => element.isChecked).isNotEmpty) {
      return true;
    }

    return false;
  }

  void onSave(List<Note> noteList) {
    Folder? chosenFolder;
    for (Folder folder in response.data) {
      if (folder.isChecked) {
        chosenFolder = folder;
        break;
      }
    }

    _noteRepository
        .moveToFolder(MoveFolder(
            noteIds: noteList.map((e) => e.id!).toList(),
            folderId: chosenFolder!.id))
        .then(
      (value) {
        LoadingOverlay.hide();
        Get.back(result: true);
      },
    ).catchError((e) {
      LoadingOverlay.hide();
    });
  }
}

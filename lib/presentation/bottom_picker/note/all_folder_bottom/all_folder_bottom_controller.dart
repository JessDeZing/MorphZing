import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:morphzing/data/models/journal/folder.dart';
import 'package:morphzing/data/repositories/journal/note_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/bottom_picker/note/create_folder_bottom/create_folder_bottom_sheet.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';

import '../../../../data/models/api_pagination.dart';

class AllFolderBottomController extends GetxController {
  final NoteRepository _noteRepository = getIt<NoteRepository>();

  final Rx<RxStatus> _loading = Rx<RxStatus>(RxStatus.empty());

  final Rx<ApiPagination<Folder>> _response =
      Rx<ApiPagination<Folder>>(ApiPagination(total: 0, data: []));
  final RxString _currentFilter = 'all'.obs; // 'all', 'alphabetical', 'date'

  ApiPagination<Folder> get response => _response.value;

  RxStatus get loading => _loading.value;

  int currentPage = 1;

  bool isUpdated = false;

  String get currentFilter => _currentFilter.value;

  List<Folder> get filteredFolders {
    List<Folder> folders = List.from(_response.value.data);

    switch (_currentFilter.value) {
      case 'alphabetical':
        folders.sort((a, b) {
          final nameA = a.name?.toLowerCase() ?? '';
          final nameB = b.name?.toLowerCase() ?? '';
          return nameA.compareTo(nameB);
        });
        break;
      // case 'date':
      //   folders.sort((a, b) {
      //     final dateA = a.updatedTime ?? DateTime(1970);
      //     final dateB = b.updatedTime ?? DateTime(1970);
      //     return dateB.compareTo(dateA); // Newest first
      //   });
      //   break;
      default: // 'all' - keep original order
        break;
    }

    return folders;
  }

  void setFilter(String filter) {
    _currentFilter.value = filter;
    update(); // Refresh the UI
  }

  @override
  void onReady() {
    _getFolderList();
    super.onReady();
  }

  void _getFolderList() async {
    _loading.value = RxStatus.loading();
    currentPage = 1;
    _noteRepository.getFolderList(currentPage: currentPage).then((value) {
      // No automatic sorting - keep original order
      _response.value = ApiPagination(total: value.total, data: value.data);
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

      // Combine existing data with new data (no automatic sorting)
      final combinedData = [..._response.value.data, ...value.data];

      _response.value = ApiPagination(total: value.total, data: combinedData);
      _loading.value = RxStatus.success();
    }).catchError((e) {
      _loading.value = RxStatus.error(e.toString());
    });
  }

  void deleteFolder(Folder chosenFolder) {
    _noteRepository.deleteFolder(chosenFolder.id!).then((value) {
      _getFolderList();
      LoadingOverlay.hide();
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  void addFolder(BuildContext context) {
    CreateFolderBottomSheet.show(context: context)
        .then((value) => _getFolderList());
  }

  void openMyFolder(Folder folder) {
    Get.toNamed(
      myRoute,
      arguments: folder,
      preventDuplicates: false,
    )?.then((value) {
      if (value != null && value) {
        isUpdated = true;
        _getFolderList();
      }
    });
  }
}

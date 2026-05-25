import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:morphzing/core/enum/search_type_enum.dart';
import 'package:morphzing/core/extension/search_type_extension.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/note.dart';
import 'package:morphzing/data/repositories/search/search_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/bottom_picker/filter_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/search/search_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

class SearchController<T> extends GetxController {
  final SearchRepository _searchRepository = getIt<SearchRepository>();
  final SearchScreenParam _param = Get.arguments;

  late final Rx<SearchTypeEnum> _searchTypeEnum = Rx<SearchTypeEnum>(_param.searchTypeEnum);

  final Rx<RxStatus> _rxStatus = Rx<RxStatus>(RxStatus.empty());

  final Rx<ApiPagination<dynamic>> _response = Rx<ApiPagination<dynamic>>(ApiPagination(total: 0, data: []));

  final TextEditingController _searchTextEditingController = TextEditingController();

  int currentPage = 1;

  SearchTypeEnum get searchTypeEnum => _searchTypeEnum.value;

  RxStatus get rxStatus => _rxStatus.value;

  set searchTypeEnum(value) => _searchTypeEnum.value = value;

  SearchScreenParam get param => _param;

  ApiPagination<dynamic> get response => _response.value;

  TextEditingController get searchTextEditingController => _searchTextEditingController;

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    super.dispose();
  }

  void openFilterBottomSheet() {
    Get.bottomSheet(
      FilterBottomSheet(searchTypeEnum: _searchTypeEnum.value),
      isScrollControlled: true,
    ).then((value) {
      if (value != null) {
        _searchTypeEnum.value = value;
        if (_searchTypeEnum.value == SearchTypeEnum.initial) _searchTextEditingController.text = '';
        if (_searchTextEditingController.text.isNotEmpty) {
          getSearchList();
        }
      }
    });
  }

  void getSearchList() {
    if (_searchTypeEnum.value == SearchTypeEnum.task) {
      getTaskList();
    } else if (_searchTypeEnum.value == SearchTypeEnum.event) {
      getEventList();
    } else if (_searchTypeEnum.value == SearchTypeEnum.journey) {
      getJournalList();
    }else{
      getNoteList();
    }
  }

  void getPaginationList() {
    if (_searchTypeEnum.value == SearchTypeEnum.task) {
      getPaginationTaskList();
    } else if (_searchTypeEnum.value == SearchTypeEnum.event) {
      getPaginationEventList();
    } else if (_searchTypeEnum.value == SearchTypeEnum.journey) {
      getPaginationJournalList();
    }else{
      getPaginationNoteList();
    }
  }

  void getTaskList() async {
    _rxStatus.value = RxStatus.loading();
    currentPage = 1;
    _searchRepository
        .getTaskList(
      search: _searchTextEditingController.text,
      category: _searchTypeEnum.value.getQueryValue(),
      currentPage: currentPage,
    )
        .then((value) {
      _response.value = value;
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  void getPaginationTaskList() async {
    await Future.delayed(Duration(milliseconds: 100));
    _rxStatus.value = RxStatus.loadingMore();
    _searchRepository
        .getTaskList(
      search: _searchTextEditingController.text,
      category: _searchTypeEnum.value.getQueryValue(),
      currentPage: currentPage + 1,
    )
        .then((value) {
      currentPage = currentPage + 1;
      _response.value = ApiPagination(total: value.total, data: [..._response.value.data, ...value.data]);
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  void getEventList() async {
    _rxStatus.value = RxStatus.loading();
    currentPage = 1;
    _searchRepository
        .getEventList(
      search: _searchTextEditingController.text,
      category: _searchTypeEnum.value.getQueryValue(),
      currentPage: currentPage,
    )
        .then((value) {
      _response.value = value;
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  void getPaginationEventList() async {
    await Future.delayed(Duration(milliseconds: 100));
    _rxStatus.value = RxStatus.loadingMore();
    _searchRepository
        .getEventList(
      search: _searchTextEditingController.text,
      category: _searchTypeEnum.value.getQueryValue(),
      currentPage: currentPage + 1,
    )
        .then((value) {
      currentPage = currentPage + 1;
      _response.value = ApiPagination(total: value.total, data: [..._response.value.data, ...value.data]);
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  void getJournalList() async {
    _rxStatus.value = RxStatus.loading();
    currentPage = 1;
    _searchRepository
        .getJournalList(
      search: _searchTextEditingController.text,
      category: _searchTypeEnum.value.getQueryValue(),
      currentPage: currentPage,
    )
        .then((value) {
      _response.value = value;
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  void getPaginationJournalList() async {
    await Future.delayed(Duration(milliseconds: 100));
    _rxStatus.value = RxStatus.loadingMore();
    _searchRepository
        .getJournalList(
      search: _searchTextEditingController.text,
      category: _searchTypeEnum.value.getQueryValue(),
      currentPage: currentPage + 1,
    )
        .then((value) {
      currentPage = currentPage + 1;
      _response.value = ApiPagination(total: value.total, data: [..._response.value.data, ...value.data]);
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  void getNoteList() async {
    _rxStatus.value = RxStatus.loading();
    currentPage = 1;
    _searchRepository
        .getNoteList(
      search: _searchTextEditingController.text,
      category: _searchTypeEnum.value.getQueryValue(),
      currentPage: currentPage,
    )
        .then((value) {
      _response.value = value;
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  void getPaginationNoteList() async {
    await Future.delayed(Duration(milliseconds: 100));
    _rxStatus.value = RxStatus.loadingMore();
    _searchRepository
        .getNoteList(
      search: _searchTextEditingController.text,
      category: _searchTypeEnum.value.getQueryValue(),
      currentPage: currentPage + 1,
    )
        .then((value) {
      currentPage = currentPage + 1;
      _response.value = ApiPagination(total: value.total, data: [..._response.value.data, ...value.data]);
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  void openNoteScreen(Note note) {
    Get.toNamed(noteRoute, arguments: note)?.then((value) {
      if (value != null) {
        getNoteList();
      }
    });
  }
}

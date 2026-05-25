import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/journal/journal_streak_model.dart';
import 'package:morphzing/data/repositories/journal/new_journal_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';

class CalendarJournalController extends GetxController {
  final NewJournalRepository _newJournalRepository = getIt<NewJournalRepository>();
  final Rx<RxStatus> _rxStatus = Rx<RxStatus>(RxStatus.empty());
  final Rx<ApiPagination<JournalModel>> _response = Rx<ApiPagination<JournalModel>>(ApiPagination(total: 0, data: []));
  final Rx<DateTime> _focusedDay = Rx<DateTime>(DateTime.now());
  final Rx<DateTime> _chosenDay = Rx<DateTime>(DateTime.now());
  final RxList<String> _journalDateTimeList = RxList([]);
  PageController pageController = PageController();
  bool isUpdated = false;

  int currentPage = 1;

  RxStatus get rxStatus => _rxStatus.value;

  ApiPagination<JournalModel> get response => _response.value;

  DateTime get focusedDay => _focusedDay.value;

  set focusedDay(value) => _focusedDay.value = value;

  DateTime get chosenDay => _chosenDay.value;

  set chosenDay(value) => _chosenDay.value = value;

  List<String> get journalDateTimeList => _journalDateTimeList.value;

  set focusedDat(value) => _focusedDay.value = value;

  @override
  void onInit() {
    _init();
    super.onInit();
  }

  void _init() async {
    _rxStatus.value = RxStatus.loading();
    currentPage = 1;
    _newJournalRepository
        .getAllJournalByDate(
      startDate: _getDateTimeString(_chosenDay.value.subtract(Duration(days: 31))),
      endDate: _getDateTimeString(_chosenDay.value.add(Duration(days: 31))),
    )
        .then((value) {
      setJournalDateTimeList(value);
      return _newJournalRepository.getJournalByDate(
        startDate: _getDateTimeString(_chosenDay.value),
        endDate: _getDateTimeString(_chosenDay.value),
        currentPage: currentPage,
      );
    }).then((value) {
      _response.value = value;
      _rxStatus.value = RxStatus.success();
    }).catchError((e) {
      _rxStatus.value = RxStatus.error(e.toString());
    });
  }

  void getJournalDateTimeList({
    required DateTime startDate,
    required DateTime enDate,
  }) async {
    _newJournalRepository
        .getAllJournalByDate(
      startDate: _getDateTimeString(startDate),
      endDate: _getDateTimeString(enDate),
    )
        .then((value) {
      setJournalDateTimeList(value);
      LoadingOverlay.hide();
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  void getJournalList() async {
    _rxStatus.value = RxStatus.loading();
    currentPage = 1;
    _newJournalRepository
        .getJournalByDate(
      startDate: _getDateTimeString(_chosenDay.value),
      endDate: _getDateTimeString(_chosenDay.value),
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
    _newJournalRepository
        .getJournalByDate(
      startDate: _getDateTimeString(_chosenDay.value),
      endDate: _getDateTimeString(_chosenDay.value),
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

  void setJournalDateTimeList(List<JournalModel> list) {
    Set<String> _newList = {};
    for (JournalModel journalModel in list) {
      if (journalModel.journeyTime != null) {
        print(journalModel.journeyTime.toString());
        _newList.add(DateFormat('yyyy-MM-dd').format(journalModel.journeyTime!));
      }
    }
    _journalDateTimeList.value = [..._newList.toList()];
    update();
  }

  String _getDateTimeString(DateTime dateTime) => DateFormat('yyyy-MM-dd').format(dateTime);

  void openCreateJournalScreen() {
    Get.toNamed(journeyRoute, arguments: _chosenDay.value)?.then((value) {
      if (value != null && value) {
        isUpdated = value;
        _init();
      }
    });
  }

  void openUpdateJournalScreen(JournalModel model) {
    Get.toNamed(journeyRoute, arguments: model)?.then((value) {
      if (value != null && value) {
        isUpdated = value;
        getJournalList();
      }
    });
  }

  void onPressedBack() => Get.back(result: isUpdated);
}

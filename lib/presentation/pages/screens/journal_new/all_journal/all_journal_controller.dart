import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/journal/journal_streak_model.dart';
import 'package:morphzing/data/repositories/journal/new_journal_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

class AllJournalController extends GetxController {
  final NewJournalRepository _newJournalRepository = getIt<NewJournalRepository>();
  final Rx<RxStatus> _rxStatus = Rx<RxStatus>(RxStatus.empty());
  final Rx<ApiPagination<JournalModel>> _response = Rx<ApiPagination<JournalModel>>(ApiPagination(total: 0, data: []));
  final String _startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  final String _endDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  final Rx<JournalStreakModel> _journalStreakModel = Rx<JournalStreakModel>(
    JournalStreakModel(streakCount: 0, totalEntries: 0, weekStreak: 0),
  );

  int currentPage = 1;

  RxStatus get rxStatus => _rxStatus.value;

  ApiPagination<JournalModel> get response => _response.value;

  JournalStreakModel get journalStreakModel => _journalStreakModel.value;

  @override
  void onReady() {
    _getJournalCountJournalList();
    super.onReady();
  }

  void _getJournalCountJournalList() async {
    _rxStatus.value = RxStatus.loading();
    currentPage = 1;
    _newJournalRepository.getJournalStreak().then((value) {
      _journalStreakModel.value = value;
      return _newJournalRepository.getJournalByDate(
        startDate: _startDate,
        endDate: _endDate,
        currentPage: currentPage,
      );
    }).then((value) {
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
      startDate: _startDate,
      endDate: _endDate,
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

  void openTodayJournal() {
    Get.toNamed(todayJournalRoute)?.then((value) {
      if (value != null && value) _getJournalCountJournalList();
    });
  }

  void openCalendarJournalScreen() {
    Get.toNamed(calendarJournal)?.then((value) {
      if (value != null && value) _getJournalCountJournalList();
    });
  }

  void openCreateJournalScreen() {
    Get.toNamed(journeyRoute)?.then((value) {
      if (value != null && value) _getJournalCountJournalList();
    });
  }

  void openUpdateJournalScreen(JournalModel model) {
    Get.toNamed(journeyRoute, arguments: model)?.then((value) {
      if (value != null && value) _getJournalCountJournalList();
    });
  }
}

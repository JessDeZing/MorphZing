import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/journal/journal_streak_model.dart';
import 'package:morphzing/data/repositories/journal/journal_repositories.dart';
import 'package:morphzing/data/repositories/journal/new_journal_repository.dart';
import 'package:morphzing/di/di_config.dart';

class JournalController extends GetxController {
  final NewJournalRepository _newJournalRepository = getIt<NewJournalRepository>();

  RxBool loading = false.obs;
  RxInt totalEntries = 0.obs;
  RxInt currentStreak = 0.obs;
  RxInt weeksJournaling = 0.obs;
  Rx<List<JournalModel>> model = Rx([]);
  Rx<List<JournalModel>> calendarModel = Rx([]);

  Rx<DateTime> focusedDay = Rx(DateTime.now());

  final box = GetStorage();

  Future getStats() async {
    loading(true);
    JournalStreakModel journalStreakModel = await _newJournalRepository.getJournalStreak();
    totalEntries.value = journalStreakModel.totalEntries;
    currentStreak.value = journalStreakModel.streakCount;
    weeksJournaling.value = journalStreakModel.weekStreak;
    loading(false);
  }

  Future getTodayJournals() async {
    loading(true);
    String searchDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    ApiPagination<JournalModel> response = await _newJournalRepository.getJournalByDate(
      startDate: searchDate,
      endDate: searchDate,
      currentPage: 1,
    );
    model.value = [...response.data];
    loading(false);
  }

  Future getJournalsCalendar() async {
    loading(true);
    var result = await JournalRepositories.getJournalsCalendar(box.read('token').toString(), focusedDay.value);
    if (result.statusCode == 200) {
      final data = result.data?.map((e) => JournalModel.fromJson(e));

      // debugPrint('DATA: ${data?.toList()}');
      calendarModel(data?.toList());
    }
    // showInternalError();

    loading(false);
  }

  @override
  void onInit() {
    super.onInit();
    getStats();
    getTodayJournals();
    // getJournalsCalendar();
  }
}

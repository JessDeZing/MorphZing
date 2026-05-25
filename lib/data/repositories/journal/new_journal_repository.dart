import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:morphzing/data/api/journal_api.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/journal/journal_streak_model.dart';

@singleton
class NewJournalRepository {
  final JournalApi _journalApi;

  NewJournalRepository(this._journalApi);

  Future<JournalStreakModel> getJournalStreak() async {
    return await _journalApi.getJournalStreak();
  }

  Future<ApiPagination<JournalModel>> getJournalByDate({
    required String startDate,
    required String endDate,
    required int currentPage,
  }) async {
    return await _journalApi.getJournalByDate(
      startDate: startDate,
      endDate: endDate,
      currentPage: currentPage,
    );
  }

  Future<List<JournalModel>> getAllJournalByDate({
    required String startDate,
    required String endDate,
  }) async {
    return await _journalApi.getAllJournalByDate(
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<ApiPagination<JournalModel>> getTodayJournal({
    required int currentPage,
  }) async {
    return await _journalApi.getTodayJournal(
      currentPage: currentPage,
    );
  }

  Future<ApiPagination<JournalModel>> getTodayJournalByDate({
    required String startDate,
    required String endDate,
    required int currentPage,
  }) async {
    return await _journalApi.getTodayJournal(
      currentPage: currentPage,
    );
  }

  Future<void> journeyDelete({
    required int id,
  }) async {
    return await _journalApi.journeyDelete(id);
  }

  Future<void> journeyFreeTemplate(int journalId, int templateId) async {
    return await _journalApi.journeyFreeTemplate(journalId, templateId);
  }

  Future<void> journeyUserTemplate(int journalId, int templateId) async {
    return await _journalApi.journeyUserTemplate(journalId, templateId);
  }

  Future<void> createJournal({
    int? userId,
    String? journeyTime,
    String? noteName,
    String? description,
    String? weblink,
    String? location,
    String? documentName,
    String? documentDesc,
    int? documentSize,
    List<File>? photos,
    File? audio,
    File? document,
    File? draw,
    int? userTemplateId,
    int? freeTemplateId,
  }) async {
    return await _journalApi.createJournal(
      userId: userId,
      journeyTime: journeyTime,
      noteName: noteName,
      description: description,
      weblink: weblink,
      location: location,
      documentName: documentName,
      documentDesc: documentDesc,
      documentSize: documentSize,
      photos: photos,
      audio: audio,
      document: document,
      draw: draw,
      userTemplateId: userTemplateId,
      freeTemplateId: freeTemplateId,
    );
  }

  Future<void> updateJournal({
    required int id,
    int? userId,
    String? journeyTime,
    String? noteName,
    String? description,
    String? weblink,
    String? location,
    String? documentName,
    String? documentDesc,
    int? documentSize,
    List<File>? photos,
    File? audio,
    File? document,
    File? draw,
    String? drawUrl,
    int? userTemplateId,
    int? freeTemplateId,
  }) async {
    return await _journalApi.updateJournal(
      id: id,
      userId: userId,
      journeyTime: journeyTime,
      noteName: noteName,
      description: description,
      weblink: weblink,
      location: location,
      documentName: documentName,
      documentDesc: documentDesc,
      documentSize: documentSize,
      photos: photos,
      audio: audio,
      document: document,
      draw: draw,
      drawUrl: drawUrl,
      userTemplateId: userTemplateId,
      freeTemplateId: freeTemplateId,
    );
  }

  Future<void> journalDeletePhoto({
    required List<int> photoIds,
  }) async {
    return await _journalApi.journalDeletePhoto({'photo_ids': photoIds});
  }
}

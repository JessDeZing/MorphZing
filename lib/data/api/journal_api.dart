import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/journal/journal_streak_model.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:retrofit/http.dart';

part 'journal_api.g.dart';

@singleton
@RestApi()
abstract class JournalApi {
  @factoryMethod
  factory JournalApi(Dio dio) = _JournalApi;

  @GET(JOURNAL_GET_STATS)
  Future<JournalStreakModel> getJournalStreak();

  @GET(JOURNAL_POST_JOURNEY)
  Future<ApiPagination<JournalModel>> getJournalByDate({
    @Query('start_date') required String startDate,
    @Query('end_date') required String endDate,
    @Query('page') required int currentPage,
  });

  @GET(ALL_JOURNAL_POST_JOURNEY)
  Future<List<JournalModel>> getAllJournalByDate({
    @Query('start_date') required String startDate,
    @Query('end_date') required String endDate,
  });

  @GET(JOURNAL_POST_JOURNEY)
  Future<ApiPagination<JournalModel>> getTodayJournal({
    @Query('page') required int currentPage,
  });

  @DELETE("$JOURNAL_DELETE_JOURNEY/{id}/")
  Future<void> journeyDelete(@Path() int id);

  @PATCH("$JOURNAL_TEMPLATE/{id}/")
  @MultiPart()
  Future<void> journeyUserTemplate(@Path() int id, @Part(name: 'user_template') int templateId);

  @PATCH("$JOURNAL_TEMPLATE/{id}/")
  @MultiPart()
  Future<void> journeyFreeTemplate(@Path() int id, @Part(name: 'free_template') int templateId);

  @POST(JOURNAL_POST_JOURNEY)
  @MultiPart()
  Future<void> createJournal({
    @Part(name: 'user') int? userId,
    @Part(name: 'journey_time') String? journeyTime,
    @Part(name: 'note_name') String? noteName,
    @Part(name: 'description') String? description,
    @Part(name: 'web_link') String? weblink,
    @Part(name: 'location') String? location,
    @Part(name: 'document_name') String? documentName,
    @Part(name: 'document_desc') String? documentDesc,
    @Part(name: 'document_size') int? documentSize,
    @Part(name: 'photos') List<File>? photos,
    @Part(name: 'audio') File? audio,
    @Part(name: 'document') File? document,
    @Part(name: 'draw') File? draw,
    @Part(name: 'user_template') int? userTemplateId,
    @Part(name: 'free_template') int? freeTemplateId,
  });

  @PUT('$JOURNAL_POST_JOURNEY/{id}/')
  @MultiPart()
  Future<void> updateJournal({
    @Path() required int id,
    @Part(name: 'user') int? userId,
    @Part(name: 'journey_time') String? journeyTime,
    @Part(name: 'note_name') String? noteName,
    @Part(name: 'description') String? description,
    @Part(name: 'web_link') String? weblink,
    @Part(name: 'location') String? location,
    @Part(name: 'document_name') String? documentName,
    @Part(name: 'document_desc') String? documentDesc,
    @Part(name: 'document_size') int? documentSize,
    @Part(name: 'photos') List<File>? photos,
    @Part(name: 'audio') File? audio,
    @Part(name: 'document') File? document,
    @Part(name: 'draw') File? draw,
    @Part(name: 'drawing_url') String? drawUrl,
    @Part(name: 'user_template') int? userTemplateId,
    @Part(name: 'free_template') int? freeTemplateId,
  });

  @POST(JOURNAL_DELETE_PHOTO)
  Future<void> journalDeletePhoto(@Body() Map<String, List<int>> photoIds);
}

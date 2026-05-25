import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/journal/note.dart';
import 'package:retrofit/http.dart';

part 'search_api.g.dart';

@singleton
@RestApi()
abstract class SearchApi {
  @factoryMethod
  factory SearchApi(Dio dio) = _SearchApi;

  @GET("/dashboard/search")
  Future<ApiPagination<Todo>> getTaskList({
    @Query('search') required String search,
    @Query('category') required String category,
    @Query('page') required int currentPage,
  });

  @GET("/dashboard/search")
  Future<ApiPagination<Event>> getEventList({
    @Query('search') required String search,
    @Query('category') required String category,
    @Query('page') required int currentPage,
  });

  @GET("/dashboard/search")
  Future<ApiPagination<JournalModel>> getJournalList({
    @Query('search') required String search,
    @Query('category') required String category,
    @Query('page') required int currentPage,
  });

  @GET("/dashboard/search")
  Future<ApiPagination<Note>> getNoteList({
    @Query('search') required String search,
    @Query('category') required String category,
    @Query('page') required int currentPage,
  });
}

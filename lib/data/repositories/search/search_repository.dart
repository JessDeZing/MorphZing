import 'package:injectable/injectable.dart';
import 'package:morphzing/data/api/search_api.dart';
import 'package:morphzing/data/models/agenda/event.dart';
import 'package:morphzing/data/models/agenda/todo.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/journal/note.dart';

@singleton
class SearchRepository {
  final SearchApi _searchApi;

  SearchRepository(this._searchApi);

  Future<ApiPagination<Todo>> getTaskList({
    required String search,
    required String category,
    required int currentPage,
  }) async {
    return await _searchApi.getTaskList(
      search: search,
      category: category,
      currentPage: currentPage,
    );
  }

  Future<ApiPagination<Event>> getEventList({
    required String search,
    required String category,
    required int currentPage,
  }) async {
    return await _searchApi.getEventList(
      search: search,
      category: category,
      currentPage: currentPage,
    );
  }

  Future<ApiPagination<JournalModel>> getJournalList({
    required String search,
    required String category,
    required int currentPage,
  }) async {
    return await _searchApi.getJournalList(
      search: search,
      category: category,
      currentPage: currentPage,
    );
  }

  Future<ApiPagination<Note>> getNoteList({
    required String search,
    required String category,
    required int currentPage,
  }) async {
    return await _searchApi.getNoteList(
      search: search,
      category: category,
      currentPage: currentPage,
    );
  }
}

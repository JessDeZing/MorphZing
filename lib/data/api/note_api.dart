import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:morphzing/core/constants/urls.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/folder.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/journal/journal_streak_model.dart';
import 'package:morphzing/data/models/journal/move_folder.dart';
import 'package:morphzing/data/models/user/user_model/user.dart';
import 'package:retrofit/http.dart';

import '../models/journal/note.dart';

part 'note_api.g.dart';

@singleton
@RestApi()
abstract class NoteApi {
  @factoryMethod
  factory NoteApi(Dio dio) = _NoteApi;

  @GET(NOTE_LIST)
  Future<ApiPagination<Note>> getNoteList({@Query('page') required int currentPage});

  @DELETE("$NOTE_LIST/{id}/")
  Future<void> deleteNote(@Path() int id);

  @POST(NOTE_LIST)
  Future<void> createNote({
    @Part(name: 'note_name') required String noteName,
    @Part(name: 'note_time') required String noteTime,
    @Part(name: 'description') String? description,
    @Part(name: 'folder') String? folder,
    @Part(name: 'draw') File? draw,
  });

  @PATCH("$NOTE_LIST/{id}/")
  Future<void> updateNote({
    @Path() required int id,
    @Part(name: 'note_name') required String noteName,
    //@Part(name: 'note_time') required String noteTime,
    @Part(name: 'description') String? description,
    @Part(name: 'folder') String? folder,
    @Part(name: 'draw') File? draw,
  });

  @POST(FOLDER_LIST)
  Future<void> createFolder({
    @Part(name: 'name') required String name,
  });

  @GET(FOLDER_LIST)
  Future<ApiPagination<Folder>> getFolderList({@Query('page') required int currentPage});

  @DELETE("$FOLDER_LIST/{id}/")
  Future<void> deleteFolder(@Path() int id);

  @GET("$FOLDER_LIST/{id}/")
  Future<Folder> getNoteListByFolderId(@Path() int id);

  @POST(MOVE_FOLDER)
  Future<void> moveToFolder(@Body() MoveFolder moveFolder);

  @POST(REMOVE_FROM_FOLDER)
  Future<void> removeFromFolder(@Body() Map<String, List<int>> data);
}

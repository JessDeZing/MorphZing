import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:morphzing/data/api/journal_api.dart';
import 'package:morphzing/data/api/note_api.dart';
import 'package:morphzing/data/models/api_pagination.dart';
import 'package:morphzing/data/models/journal/folder.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/journal/journal_streak_model.dart';
import 'package:morphzing/data/models/journal/move_folder.dart';

import '../../models/journal/note.dart';

@singleton
class NoteRepository {
  final NoteApi _noteApi;

  NoteRepository(this._noteApi);

  Future<ApiPagination<Note>> getNoteList({required int currentPage}) async {
    return await _noteApi.getNoteList(currentPage: currentPage);
  }

  Future<void> createNote({
    required String noteName,
    required String noteTime,
    String? description,
    String? folder,
    File? draw,
  }) async {
    return await _noteApi.createNote(
      noteName: noteName,
      noteTime: noteTime,
      description: description,
      folder: folder,
      draw: draw,
    );
  }

  Future<void> updateNote({
    required int id,
    required String noteName,
    // required String noteTime,
    String? description,
    String? folder,
    File? draw,
  }) async {
    return await _noteApi.updateNote(
      id: id,
      noteName: noteName,
      //  noteTime: noteTime,
      description: description,
      folder: folder,
      draw: draw,
    );
  }

  Future<void> deleteNote({required int id}) async {
    return await _noteApi.deleteNote(id);
  }

  Future<void> createFolder({
    required String name,
  }) async {
    return await _noteApi.createFolder(name: name);
  }

  Future<ApiPagination<Folder>> getFolderList({required int currentPage}) async {
    return await _noteApi.getFolderList(currentPage: currentPage);
  }

  Future<void> deleteFolder(int folderId) async {
    return await _noteApi.deleteFolder(folderId);
  }

  Future<Folder> getNoteListByFolderId(int folderId) async {
    return await _noteApi.getNoteListByFolderId(folderId);
  }

  Future<void> moveToFolder(MoveFolder moveFolder) async {
    return await _noteApi.moveToFolder(moveFolder);
  }

  Future<void> removeFromFolder(List<int> noteIds) async {
    return await _noteApi.removeFromFolder({'note_ids': noteIds});
  }
}

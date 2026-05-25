import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:morphzing/data/api/note_api.dart';
import 'package:morphzing/data/models/journal/folder.dart';
import 'package:morphzing/data/models/journal/note.dart';
import 'package:morphzing/data/repositories/journal/note_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:path_provider/path_provider.dart';

class NoteController extends GetxController {
  final NoteRepository _noteRepository = getIt<NoteRepository>();

  final Rx<Note?> _editNote = Rx<Note?>(null);
  final Rx<Folder?> _folder = Rx<Folder?>(null);

  // final Rx<DateTime> _dateTime = Rx<DateTime>(DateTime.now());
  // final Rx<DateTime> _focusedDateTime = Rx<DateTime>(DateTime.now());

  final Rx<RxStatus> _rxCreateStatus = Rx<RxStatus>(RxStatus.empty());
  final RxBool _isTimeWidget = false.obs;
  final RxBool _loadingDraw = false.obs;
  final RxBool _isNoteDraw = false.obs;
  final RxBool _isNoteEdit = false.obs;
  final Rx<File?> _drawFile = Rx<File?>(null);
  final RxString _title = ''.obs;
  final RxString _description = ''.obs;

  Note? get isEditNote => _editNote.value;

  // DateTime get dateTime => _dateTime.value;
  //
  // DateTime get focusedDateTime => _focusedDateTime.value;

  RxStatus get rxCreateStatus => _rxCreateStatus.value;

  bool get isTimeWidget => _isTimeWidget.value;

  bool get loadingDraw => _loadingDraw.value;

  bool get isNoteDraw => _isNoteDraw.value;

  bool get isNoteEdit => _isNoteEdit.value;

  File? get drawFile => _drawFile.value;

  String get title => _title.value;

  String get description => _description.value;

  //set dateTime(value) => _dateTime.value = value;

  set isEditNote(Note? value) => _editNote.value = value;

//  set focusedDateTime(value) => _focusedDateTime.value = value;

  set rxCreateStatus(value) => _rxCreateStatus.value = value;

  set isTimeWidget(value) => _isTimeWidget.value = value;

  set loadingDraw(value) => _loadingDraw.value = value;

  set isNoteDraw(value) => _isNoteDraw.value = value;

  set drawFile(value) => _drawFile.value = value;

  set title(value) => _title.value = value;

  set description(value) => _description.value = value;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments is Note) {
      _editNote.value = Get.arguments;
      _isNoteEdit.value = true;
      // _dateTime.value = _isEditNote.value!.updatedTime ?? DateTime.now();
      // _focusedDateTime.value = _isEditNote.value!.updatedTime ?? DateTime.now();
      _title.value = _editNote.value!.noteName ?? '';
      _description.value = _editNote.value!.noteDescription ?? '';
      _isNoteDraw.value = _editNote.value!.drawUrl != null;
    } else if (Get.arguments != null && Get.arguments is Folder) {
      _folder.value = Get.arguments;
    }
    super.onInit();
  }

  void onPressedT() {
    _isNoteDraw.value = false;
  }

  void onPressedDraw() async {
    await Get.toNamed(painterRoute)?.then((value) {
      if (value != null) {
        if (_isNoteEdit.value) {
          _editNote.value = _editNote.value!.copyWith(drawUrl: null);
        }
        _isNoteDraw.value = true;
        _readImageFromUnit8(value);
      }
    });
  }

  _readImageFromUnit8(Uint8List unitImage) async {
    _loadingDraw.value = true;
    final tempDir = await getTemporaryDirectory();
    _drawFile.value = await File('${tempDir.path}/${DateTime.now()}.png').create();
    _drawFile.value?.writeAsBytesSync(unitImage);
    _loadingDraw.value = false;
  }

  bool isValidate() {
    if (_isNoteEdit.value && _title.value.isNotEmpty && (_editNote.value!.drawUrl != null || _drawFile.value != null || _description.value.isNotEmpty)) {
      return true;
    }

    if (_title.value.isNotEmpty && (_drawFile.value != null || _description.value.isNotEmpty)) {
      return true;
    }
    return false;
  }

  void onPressedSave() async {
    _noteRepository
        .createNote(
            noteName: _title.value,
            noteTime: DateTime.now().toIso8601String(),
            draw: _isNoteDraw.value ? _drawFile.value : null,
            description: !_isNoteDraw.value ? _description.value : null,
            folder: _folder.value?.id.toString())
        .then((value) {
      LoadingOverlay.hide();
      Get.back(result: true);
      showGetSnackBar(message: noteCreateSuccessMessage.tr);
    }).catchError((e) {
      LoadingOverlay.hide();
      _rxCreateStatus.value = RxStatus.error(e.toString());
    });
  }

  void onPressedUpdate() async {
    _noteRepository
        .updateNote(
      id: _editNote.value!.id!,
      noteName: _title.value,
      draw: _isNoteDraw.value ? _drawFile.value : null,
      description: !_isNoteDraw.value ? _description.value : null,
    )
        .then((value) {
      LoadingOverlay.hide();
      Get.back(result: true);
      showGetSnackBar(message: noteEditedSuccessMessage.tr);
    }).catchError((e) {
      LoadingOverlay.hide();
      _rxCreateStatus.value = RxStatus.error(e.toString());
    });
  }

  void deleteNote() {
    _noteRepository.deleteNote(id: _editNote.value!.id!).then((value) {
      LoadingOverlay.hide();
      Get.back(result: true);
      showGetSnackBar(message: noteDeleteMessage.tr);
    }).catchError((e) {
      LoadingOverlay.hide();
      _rxCreateStatus.value = RxStatus.error(e.toString());
    });
  }

  void backPressed(context) {
    if (_description.value.isEmpty && _title.value.isEmpty && _drawFile.value == null) {
      Get.back();
      return;
    }
    CustomDialogs.show(
      context: context,
      title: areYouSureWantToExitNote.tr,
      onPressLeftButton: () => Get.back(),
      onPressRightButton: () {
        Get.back();
        Get.back();
      },
      leftButton: no.tr,
      rightButton: yes.tr,
    );
  }
}

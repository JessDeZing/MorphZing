import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/data/models/purchase/template.dart';
import 'package:morphzing/data/repositories/journal/new_journal_repository.dart';
import 'package:morphzing/di/di_config.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/presentation/bottom_picker/photo_bottom_picker.dart';
import 'package:morphzing/presentation/bottom_picker/web_link_bottom_sheet.dart';
import 'package:morphzing/presentation/pages/screens/agenda/widgets/custom_dialog.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/presentation/widgets/calendar_widget.dart';
import 'package:morphzing/presentation/widgets/journal/audio_bottomsheet_widget.dart';
import 'package:morphzing/presentation/widgets/journal/journey_bottomsheet_widget.dart';
import 'package:morphzing/utils/app_functions.dart';
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class NewJournalController extends GetxController {
  final NewJournalRepository _repository = getIt<NewJournalRepository>();
  final AppController _appController = Get.find<AppController>();
  late final JournalModel? journalModel;

  final Rx<Template?> _template = Rx<Template?>(null);
  final Rx<String?> _templateUrl = Rx<String?>(null);
  final Rx<DateTime> _chosenDateTime = Rx<DateTime>(DateTime.now());
  final RxString _title = ''.obs;
  final RxString _description = ''.obs;
  final RxString _webLinkText = ''.obs;
  final RxString _locationText = ''.obs;
  final RxList<Photo> _photoList = RxList<Photo>([]);
  final Rx<File?> _drawFile = Rx<File?>(null);
  final Rx<File?> _docFile = Rx(null);
  final Rx<File?> _audioFile = Rx(null);

  final RxString _drawPath = ''.obs;
  final RxString _docPath = ''.obs;
  final RxString _documentName = ''.obs;
  final RxString _documentDesc = ''.obs;
  final RxInt _documentSize = 0.obs;
  final RxString _audioPath = ''.obs;

  final RxBool _painterLoading = false.obs;

  final RxBool _isJournalEdit = false.obs;

  final RxBool _isLocationUrl = false.obs;

  set templateUrl(value) => _templateUrl.value = value;

  set title(value) => _title.value = value;

  set description(value) => _description.value = value;

  set drawFile(value) => _drawFile.value = value;

  set drawPath(value) => _drawPath.value = value;

  set docPath(value) => _docPath.value = value;

  set audioPath(value) => _audioPath.value = value;

  String? get templateUrl => _templateUrl.value;

  DateTime get chosenDateTime => _chosenDateTime.value;

  String get title => _title.value;

  String get description => _description.value;

  File? get drawFile => _drawFile.value;

  File? get docFile => _docFile.value;

  File? get audioFile => _audioFile.value;

  List<Photo> get photoList => _photoList.value;

  String get webLinkText => _webLinkText.value;

  String get locationText => _locationText.value;

  String get drawPath => _drawPath.value;

  String get docPath => _docPath.value;

  String get documentName => _documentName.value;

  String get documentDesc => _documentDesc.value;

  int get documentSize => _documentSize.value;

  String get audioPath => _audioPath.value;

  bool get painterLoading => _painterLoading.value;

  bool get isJournalEdit => _isJournalEdit.value;

  bool get isLocationUrl => _isLocationUrl.value;

  final List<Photo> _deletePhotoList = [];

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments is DateTime) {
      DateTime dateTime = Get.arguments;
      _chosenDateTime.value = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      );
    } else if (Get.arguments != null && Get.arguments is JournalModel) {
      journalModel = Get.arguments;
      _templateUrl.value = journalModel!.templateUrl;
      _chosenDateTime.value = journalModel!.journeyTime ?? DateTime.now();
      _title.value = journalModel!.noteName;
      _description.value = journalModel!.description ?? '';
      _locationText.value = journalModel!.location ?? '';
      _webLinkText.value = journalModel!.webLink ?? '';
      _photoList.value = journalModel!.images ?? [];
      _drawPath.value = journalModel!.drawUrl ?? '';
      _docPath.value = journalModel!.documentUrl ?? '';
      _documentName.value = journalModel!.documentName ?? '';
      _documentDesc.value = journalModel!.documentDescription ?? '';
      _documentSize.value = journalModel!.documentSize ?? 0;
      _audioPath.value = journalModel!.audioUrl ?? '';
      _isJournalEdit.value = true;
      _isLocationUrl.value = isValidUrl(journalModel!.location ?? '');
    }
    super.onInit();
  }

  void backPressed(context) {
    if (_templateUrl.value == null &&
        _title.value.isEmpty &&
        _description.value.isEmpty &&
        _locationText.value.isEmpty &&
        _webLinkText.value.isEmpty &&
        _documentName.isEmpty &&
        _photoList.value.isEmpty &&
        _drawPath.value.isEmpty &&
        _drawFile.value == null &&
        _docFile.value == null &&
        _docPath.value.isEmpty &&
        _audioFile.value == null &&
        _audioPath.value.isEmpty) {
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

  void openPhotoBottomPicker() {
    Get.bottomSheet(
      PhotoBottomPicker(
        onAddPhotoPressed: () {},
        onDeletePhotoPressed: () {
          for (Photo photo in _photoList) {
            _deletePhotoList.add(photo);
          }
          _photoList.clear();
          update();
          Get.back();
        },
      ),
    );
  }

  void openMultiPhotoScreen() {
    Get.toNamed(multiPhotoRoute, arguments: _photoList)?.then((value) {
      if (value != null) {
        _photoList.value = [...value[0]];
        _deletePhotoList.addAll(value[1]);
      }
    });
  }

  void setDateTime(context) {
    showDialog(
      context: context,
      builder: (context) => CalendarWidget(
        dateTime: _chosenDateTime.value,
        onChangeDateTime: (value) {
          _chosenDateTime.value = value;
        },
      ),
    );
  }

  void openAudioBottomSheet() {
    Get.bottomSheet(
      AudioBottomSheetWidget(
        onChangePath: (String value) {
          _audioPath.value = '';
          _audioFile.value = File(value);
          Get.back();
        },
      ),
    );
  }

  void openPainterScreen() async {
    Get.toNamed(painterRoute)?.then((value) {
      if (value != null) {
        _readImageFromUnit8(value);
      }
    });
  }

  _readImageFromUnit8(Uint8List unitImage) async {
    _painterLoading.value = true;
    final tempDir = await getTemporaryDirectory();
    _drawFile.value =
        await File('${tempDir.path}/${DateTime.now()}.png').create();
    drawFile?.writeAsBytesSync(unitImage);
    _painterLoading.value = false;
  }

  void openJourneyBottomSheet() async {
    await Get.bottomSheet(
      JourneyBottomSheet(
        onPressedWebLink: () => setWebLinkText(),
        onPressedLocation: () => setLocationLinkText(),
        onPressedDocument: () => setDocFile(),
        onPressedCamera: () {
          int limit = subscribePhoto();
          if (photoList.length >= limit) {
            showAttentionSnackBar(
                message: '${onlyUpTo.tr} $limit ${photosAreAllowed.tr}');
            return;
          }
          openCamera();
        },
        onPressedPhoto: () {
          int limit = subscribePhoto();
          if (photoList.length >= limit) {
            showAttentionSnackBar(
                message: '${onlyUpTo.tr} $limit ${photosAreAllowed.tr}');
            return;
          }
          if (Platform.isAndroid) {
            openGalleryForAndroid();
          } else if (Platform.isIOS) {
            openGalleryForIos();
          }
        },
      ),
    );
  }

  void setWebLinkText() {
    Get.bottomSheet(
      WebLinkBottomSheet(
        title: weblinkDescription.tr,
        icon: 'assets/images/weblink.png',
        value: _webLinkText.value,
        isUrl: true,
      ),
    ).then((value) {
      if (value != null) {
        _webLinkText.value = value;
        Get.back();
      }
    });
  }

  void setLocationLinkText() {
    Get.bottomSheet(
      WebLinkBottomSheet(
        title: 'Text field or add link',
        icon: 'assets/images/location.png',
        value: _locationText.value,
        isUrl: false,
      ),
    ).then((value) {
      if (value != null) {
        bool _validURL = Uri.parse(value).isAbsolute;
        _isLocationUrl.value = _validURL;
        _locationText.value = value;
        Get.back();
      }
    });
  }

  void setDocFile() async {
    FilePickerResult? uploadFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );
    if (uploadFile == null) return;
    _docPath.value = '';
    PlatformFile platformFile = uploadFile.files.first;
    _documentName.value = basenameWithoutExtension(platformFile.name);
    _documentDesc.value = platformFile.name;
    _documentSize.value = platformFile.size;
    _docFile.value = await saveFilePermanently(platformFile);
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File("${appStorage.path}/${file.name}");

    return File(file.path!).copy(newFile.path);
  }

  void openCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);
    _photoList.add(Photo(file: imageTemporary));
    Get.back();
  }

  void openGalleryForAndroid() async {
    int limit = subscribePhoto();

    FilePickerResult? uploadFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (uploadFile?.files.isEmpty ?? true) {
      return;
    }

    var files = uploadFile!.files;

    for (final image in files) {
      final imageTemporary = File(image.path!);
      _photoList.add(Photo(file: imageTemporary));

      if (photoList.length >= limit) {
        update();
        Get.back();
        showAttentionSnackBar(
            message: '${onlyUpTo.tr} $limit ${photosAreAllowed.tr}');
        return;
      }
    }

    update();
    Get.back();
  }

  void openGalleryForIos() async {
    int limit = subscribePhoto();

    final images = await ImagePicker().pickMultiImage();
    if (images.isEmpty) return;

    for (final image in images) {
      final imageTemporary = File(image.path);
      _photoList.add(Photo(file: imageTemporary));

      if (photoList.length >= limit) {
        update();
        Get.back();
        showAttentionSnackBar(
            message: '${onlyUpTo.tr} $limit ${photosAreAllowed.tr}');
        return;
      }
    }

    update();
    Get.back();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(":");
  }

  launchURL(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        // await launchUrl(Uri.parse(url));
        var googleDocsUrl =
            'https://docs.google.com/gview?embedded=true&url=${Uri.parse(url)}';
        final Uri uri = Uri.parse(googleDocsUrl);
        launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (error) {
      showErrorSnackBar(message: error.toString());
    }
  }

  void openFile(File file) => OpenFile.open(file.path);

  void setTemplate(Template template) {
    _template.value = template;
    _templateUrl.value = template.image;
    Get.back();
  }

  void onSavePressed() async {
    List<File> _files = [];

    for (Photo photo in _photoList) {
      if (photo.file != null) {
        _files.add(photo.file!);
      }
    }

    _repository
        .createJournal(
      userId: _appController.user!.id,
      journeyTime: _chosenDateTime.value.toString(),
      noteName: _title.value,
      description: _description.value,
      photos: _files,
      draw: _drawFile.value,
      document: _docFile.value,
      documentName: _documentName.value,
      documentDesc: _documentDesc.value,
      documentSize: _documentSize.value,
      audio: _audioFile.value,
      location: _locationText.value,
      weblink: _webLinkText.value,
      userTemplateId: _template.value != null
          ? _template.value!.isPremium
              ? _template.value!.id
              : null
          : null,
      freeTemplateId: _template.value != null
          ? !_template.value!.isPremium
              ? _template.value!.id
              : null
          : null,
    )
        .then((value) {
      LoadingOverlay.hide();
      Get.back(result: true);
      showGetSnackBar(message: journeyCreateSuccessMessage.tr);
    }).catchError((e) {
      LoadingOverlay.hide();
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (e.response?.data['errors'][0]['message'] ==
            "You have reached the maximum number of journeys allowed.") {
          Get.back(closeOverlays: true, canPop: true);
        }
      });
    });
  }

  void onUpdatePressed() {
    List<File> _files = [];

    for (Photo photo in _photoList) {
      if (photo.file != null) {
        _files.add(photo.file!);
      }
    }

    List<int> deletePhotoIds = [];

    for (Photo photo in _deletePhotoList) {
      if (photo.id != null) {
        deletePhotoIds.add(photo.id!);
      }
    }

    if (deletePhotoIds.isNotEmpty) {
      _repository
          .journalDeletePhoto(photoIds: deletePhotoIds)
          .then((value) => _repository)
          .then(
            (value) => _repository.updateJournal(
              id: journalModel!.id,
              userId: _appController.user!.id,
              journeyTime: _chosenDateTime.value.toString(),
              noteName: _title.value,
              description: _description.value,
              photos: _files,
              draw: _drawFile.value,
              drawUrl: _drawPath.value.isNotEmpty ? _drawPath.value : null,
              document: _docFile.value,
              documentName: _documentName.value,
              documentDesc: _documentDesc.value,
              documentSize: _documentSize.value,
              audio: _audioFile.value,
              location: _locationText.value,
              weblink: _webLinkText.value,
              userTemplateId: _template.value != null
                  ? _template.value!.isPremium
                      ? _template.value!.id
                      : null
                  : null,
              freeTemplateId: _template.value != null
                  ? !_template.value!.isPremium
                      ? _template.value!.id
                      : null
                  : null,
            ),
          )
          .then((value) {
        LoadingOverlay.hide();
        Get.back(result: true);
      }).catchError((e) {
        LoadingOverlay.hide();
      });
    } else {
      _repository
          .updateJournal(
        id: journalModel!.id,
        userId: _appController.user!.id,
        journeyTime: _chosenDateTime.value.toString(),
        noteName: _title.value,
        description: _description.value,
        photos: _files,
        draw: _drawFile.value,
        drawUrl: _drawPath.value.isNotEmpty ? _drawPath.value : null,
        document: _docFile.value,
        documentName: _documentName.value,
        documentDesc: _documentDesc.value,
        documentSize: _documentSize.value,
        audio: _audioFile.value,
        location: _locationText.value,
        weblink: _webLinkText.value,
        userTemplateId: _template.value != null
            ? _template.value!.isPremium
                ? _template.value!.id
                : null
            : null,
        freeTemplateId: _template.value != null
            ? !_template.value!.isPremium
                ? _template.value!.id
                : null
            : null,
      )
          .then((value) {
        LoadingOverlay.hide();
        Get.back(result: true);
        showGetSnackBar(message: journeyEditedSuccessMessage.tr);
      }).catchError((e) {
        LoadingOverlay.hide();
      });
    }
  }

  void deleteJourney() {
    _repository.journeyDelete(id: journalModel!.id).then((value) {
      LoadingOverlay.hide();
      Get.back(result: true);
      showGetSnackBar(message: journeyDeleteMessage.tr);
    }).catchError((e) {
      LoadingOverlay.hide();
    });
  }

  Future<File> fileFromImageUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentDirectory.path, url.split("/").last));
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  void shareFile() async {
    if (_photoList[0].file != null) {
      LoadingOverlay.hide();

      final params = ShareParams(
        text: _description.value.isNotEmpty ? _description.value : _title.value,
        files: [XFile(_photoList[0].file!.path)],
      );

      final result = await SharePlus.instance.share(params);

      if (result.status == ShareResultStatus.success) {
        print('Thank you for sharing the picture!');
      }
      // shareXFiles(
      //   [XFile(_photoList[0].file!.path)],
      //   text: _description.value.isNotEmpty ? _description.value : _title.value,
      // );
    } else {
      File file = await fileFromImageUrl(_photoList[0].imageUrl!);
      LoadingOverlay.hide();

      final params = ShareParams(
        text: _description.value.isNotEmpty ? _description.value : _title.value,
        files: [XFile(file.path)],
      );

      final result = await SharePlus.instance.share(params);

      if (result.status == ShareResultStatus.success) {
        print('Thank you for sharing the picture!');
      }
      // Share.shareXFiles(
      //   [XFile(file.path)],
      //   text: _description.value.isNotEmpty ? _description.value : _title.value,
      // );
    }
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:morphzing/data/models/journal/journey_models.dart';
import 'package:morphzing/data/repositories/journal/journey_repository.dart';
import 'package:morphzing/presentation/pages/screens/home/home_controller.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';
import 'package:morphzing/utils/show_error.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class JourneyController extends GetxController {
  RxBool loading = false.obs;
  RxString pathAudio = RxString("");
  RxBool isRecording = false.obs;
  RxBool recordCompleted = false.obs;
  RxBool isFileUploaded = false.obs;
  RxBool paintLoader = false.obs;
  RxBool isTimeWidget = false.obs;
  Rx<DateTime> dateTime = DateTime.now().obs;
  Rx<DateTime> focusedDateTime = DateTime.now().obs;
  RxList<Photo> photos = RxList<Photo>([]);
  RxInt indexSlide = 0.obs;
  File? drawFile;
  RxString uploadedFileDirectory = ''.obs;
  FilePickerResult? uploadFile;
  TextEditingController webLinkController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  RxString webLinkText = RxString("");
  RxString locationText = RxString("");
  Rx<File?> docFile = Rx(null);
  PlatformFile? documentFile;
  File? audio;
  final box = GetStorage();
  TextEditingController journeyDescriptionController = TextEditingController();
  TextEditingController journeyTitleController = TextEditingController();
  int? id;

  onTapLocation() async {
    if (locationController.text.isNotEmpty) {
      locationText(locationController.text);
      Get.back();
    }
  }

  onTapWeblink() async {
    if (webLinkController.text.isNotEmpty) {
      webLinkText(webLinkController.text);
      Get.back();
    }
  }

  pickFile() async {
    debugPrint('START');

    uploadFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );
    if (uploadFile == null) return;

    // Open single file
    documentFile = uploadFile!.files.first;
    // openFile(opendedFile!);

    docFile(await saveFilePermanently(documentFile!));
  }

  void openFile(File file) {
    OpenFile.open(file.path);
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File("${appStorage.path}/${file.name}");

    return File(file.path!).copy(newFile.path);
  }

  readImageFromUnit8(Uint8List unitImage) async {
    paintLoader.value = true;
    final tempDir = await getTemporaryDirectory();
    drawFile = await File('${tempDir.path}/${DateTime.now()}.png').create();
    drawFile?.writeAsBytesSync(unitImage);
    paintLoader.value = false;
    debugPrint(drawFile?.path);
  }

  journeyImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    debugPrint('$image');

    final imageTemporary = File(image.path);
    return imageTemporary;
  }

  journeyImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    debugPrint('$image');

    final imageTemporary = File(image.path);
    return imageTemporary;
  }

  onSave() async {
    final appController = Get.find<AppController>();
    audio = pathAudio.value.isNotEmpty ? File(pathAudio.value) : null;
    final token = box.read('token').toString();

    print(webLinkText.value.toString());

    try {
      var result = await JourneyRepositories.sendJourneyPost(
        token: token,
        journeyTime: dateTime.value.toString(),
        noteName: journeyTitleController.text,
        description: journeyDescriptionController.text,
        audio: audio,
        draw: drawFile,
        location: locationText.value.isNotEmpty ? locationText.value : null,
        webLink: webLinkText.value.isNotEmpty ? webLinkText.value : null,
        document: docFile.value,
        user: appController.user!.id,
        photos: photos.value,
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        Get.back();
      } else {
        showInternalError();
      }
    } catch (e) {
      Get.back();

      showInternalError();
    }
  }

  onEdit() async {
    final appController = Get.find<AppController>();
    audio = pathAudio.value.isNotEmpty ? File(pathAudio.value) : null;
    final token = box.read('token').toString();

    try {
      var result = await JourneyRepositories.sendJourneyPut(
        id: id ?? -1,
        token: token,
        journeyTime: dateTime.value.toString(),
        noteName: journeyTitleController.text,
        description: journeyDescriptionController.text,
        audio: audio,
        draw: drawFile,
        location: locationText.value.isNotEmpty ? locationText.value : null,
        webLink: webLinkText.value.isNotEmpty ? webLinkText.value : null,
        document: docFile.value,
        user: appController.user!.id,
        photos: photos.value,
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
      } else {
        showInternalError();
      }
    } catch (e) {
      showInternalError();
    }
    Get.back();
  }

  fetchInitData(
    DateTime? journeyTime,
    String? noteName,
    String? description,
    String? audioUrl,
    String? draw,
    String? location,
    String? webLink,
    String? document,
    int? idJourney,
    List<Photo>? images,
  ) async {
    loading(true);

    debugPrint('IMAGEEE: $images');

    try {
      if (idJourney != null) id = idJourney;
      if (journeyTime != null) dateTime(journeyTime);
      if (description != null) journeyDescriptionController.text = description;
      if (noteName != null) journeyTitleController.text = noteName;
      if (audioUrl != null && audioUrl != "null" && audioUrl.isNotEmpty) {
        audio = await _fileFromImageUrl(audioUrl);
        pathAudio(audio?.path);
      }
      if (images != null && images.isNotEmpty) {
        for (var photo in images) {
          photos.add(Photo(file: await _fileFromImageUrl(photo.imageUrl ?? "")));
        }
      }
      if (draw != null && draw != "null" && draw.isNotEmpty) {
        drawFile = await _fileFromImageUrl(draw);
      }
      if (location != null && location.isNotEmpty) locationText(location);
      if (webLink != null && webLink.isNotEmpty) webLinkText(webLink);
      if (document != null && document != "null" && document.isNotEmpty) {
        docFile(await _fileFromImageUrl(document));
      }
    } catch (e) {
      debugPrint("ERROR: $e");
    }
    loading(false);
  }

  deleteJourney() async {
    final token = box.read('token').toString();

    try {
      var result = await JourneyRepositories.journeyDelete(
        id: id ?? -1,
        token: token,
      );
      if (result.statusCode == 200 || result.statusCode == 201 || result.statusCode == 204) {
      } else {
        showInternalError();
      }
    } catch (e) {
      showInternalError();
    }
  }

  Future<File> _fileFromImageUrl(String url) async {
    debugPrint('URL: $url');

    final response = await http.get(Uri.parse(url));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, url.split("/").last));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }
}

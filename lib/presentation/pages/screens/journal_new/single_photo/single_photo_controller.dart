import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:http/http.dart' as http;
import 'package:morphzing/utils/loading_overlay.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SinglePhotoController extends GetxController {
  final Rx<Photo> _photo = Rx<Photo>(Get.arguments);

  Photo get photo => _photo.value;

  Future<File> fileFromImageUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(documentDirectory.path, url.split("/").last));
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  void shareFile() async {
    if (_photo.value.file != null) {
      LoadingOverlay.hide();
      Share.shareXFiles(
        [XFile(_photo.value.file!.path)],
      );
    } else {
      File file = await fileFromImageUrl(_photo.value.imageUrl!);
      LoadingOverlay.hide();
      Share.shareXFiles(
        [XFile(file.path)],
      );
    }
  }
}

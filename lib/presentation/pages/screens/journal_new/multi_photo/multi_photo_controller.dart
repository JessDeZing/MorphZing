import 'package:get/get.dart';
import 'package:morphzing/data/models/journal/journal_model.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

class MultiPhotoController extends GetxController {
  final RxList<Photo> _photoList = Get.arguments;

  List<Photo> get photoList => _photoList;

  final List<Photo> _deletedPhotoList = [];

  void openSinglePhotoScreen(Photo photo) {
    Get.toNamed(singlePhotoRoute, arguments: photo)?.then((value) {
      if (value != null && value) {
        _deletedPhotoList.add(photo);
        photoList.remove(photo);
        update();
      }
    });
  }

  void onPressedBack() => Get.back(result: [_photoList, _deletedPhotoList]);
}

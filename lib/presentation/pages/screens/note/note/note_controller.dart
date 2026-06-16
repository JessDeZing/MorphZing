import 'package:get/get.dart';

class NoteController extends GetxController {
  final notes = [].obs;

  void openNote(dynamic note) {
    Get.back();
  }
}

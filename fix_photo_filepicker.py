path = './lib/logic/controllers/journal/journey_controller.dart'
with open(path, 'r') as f:
    content = f.read()

# Add file_picker import
if "package:file_picker/file_picker.dart" not in content:
    content = content.replace(
        "import 'package:image_picker/image_picker.dart';",
        "import 'package:image_picker/image_picker.dart';\nimport 'package:file_picker/file_picker.dart';"
    )
    print('Import added')

old = '''  Future<void> pickMultipleImages() async {
    // Let ImagePicker handle permissions internally (works better on Samsung Android 13+)
    try {
      final List<XFile> images = await ImagePicker().pickMultiImage(
        imageQuality: 85,
        limit: 10,
      );
      debugPrint('Images selected: ${images.length}');
      if (images.isEmpty) return;
      final newPhotos = images.map((img) => Photo(file: File(img.path))).toList();
      debugPrint('New photos: ${newPhotos.length}');
      photos.addAll(newPhotos);
      photos.refresh();
    } catch (e) {
      Get.snackbar('Error', 'Could not load photos: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }'''

new = '''  Future<void> pickMultipleImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result == null || result.files.isEmpty) return;
      final newPhotos = result.files
          .where((f) => f.path != null)
          .map((f) => Photo(file: File(f.path!)))
          .toList();
      debugPrint('Photos picked via FilePicker: ${newPhotos.length}');
      photos.addAll(newPhotos);
      photos.refresh();
    } catch (e) {
      Get.snackbar('Error', 'Could not load photos: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }'''

if old in content:
    content = content.replace(old, new)
    print('pickMultipleImages replaced with FilePicker')
else:
    print('ERROR: old block not found')

with open(path, 'w') as f:
    f.write(content)
print('Done')

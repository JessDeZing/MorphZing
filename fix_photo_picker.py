path = './lib/logic/controllers/journal/journey_controller.dart'
with open(path, 'r') as f:
    content = f.read()

old = '''    // Request permission for Android 13+
    final status = await Permission.photos.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      // Try storage permission for older Android
      final storageStatus = await Permission.storage.request();
      if (storageStatus.isDenied) return;
    }
    final List<XFile> images = await ImagePicker().pickMultiImage();
    if (images.isEmpty) return;'''

new = '''    // Let ImagePicker handle permissions internally (works better on Samsung Android 13+)
    try {
      final List<XFile> images = await ImagePicker().pickMultiImage(
        imageQuality: 85,
      );
      if (images.isEmpty) return;'''

if old in content:
    content = content.replace(old, new)
    # Close the try block before the next line that uses images
    content = content.replace(
        'photos.refresh();\n  }',
        'photos.refresh();\n    } catch (e) {\n      Get.snackbar(\'Error\', \'Could not load photos: $e\', snackPosition: SnackPosition.BOTTOM);\n    }\n  }',
        1
    )
    print('Photo picker fixed')
else:
    print('ERROR: old block not found')

with open(path, 'w') as f:
    f.write(content)
print('Done')

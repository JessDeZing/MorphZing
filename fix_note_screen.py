path = './lib/presentation/pages/screens/note/note/note_screen.dart'
with open(path, 'r') as f:
    content = f.read()

old = '''      appBar: AppBar(
        backgroundColor: isDark ? darkBgColor : whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? whiteColor : blackTextColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Note',
          style: TextStyle(
            color: isDark ? whiteColor : blackTextColor,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Obx(() => controller.isSaving.value
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: Icon(Icons.save, color: isDark ? whiteColor : blackTextColor),
                  onPressed: controller.saveNote,
                )),
        ],
      ),'''

new = '''      appBar: AppBar(
        backgroundColor: isDark ? darkBgColor : whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? whiteColor : blackTextColor),
          onPressed: () => controller.saveNote(silent: true),
        ),
        title: Text(
          'Note',
          style: TextStyle(
            color: isDark ? whiteColor : blackTextColor,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (controller.isEditing)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: controller.deleteNote,
            ),
          Obx(() => controller.isSaving.value
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: Icon(Icons.save, color: isDark ? whiteColor : blackTextColor),
                  onPressed: controller.saveNote,
                )),
        ],
      ),'''

if old in content:
    content = content.replace(old, new)
    with open(path, 'w') as f:
        f.write(content)
    print('Done')
else:
    print('ERROR: old text not found - no changes made')

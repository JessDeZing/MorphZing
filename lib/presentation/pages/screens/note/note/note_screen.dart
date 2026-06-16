import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'note_controller.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NoteController());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final timeStr = TimeOfDay.fromDateTime(now).format(context);
    final dateStr = '${_monthName(now.month)} ${now.day}, ${now.year}';

    return Scaffold(
      backgroundColor: isDark ? darkBgColor : whiteColor,
      appBar: AppBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$timeStr\n$dateStr',
                style: TextStyle(
                  color: isDark ? whiteColor : blackTextColor,
                  fontFamily: 'SF Pro Display',
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.titleController,
              style: TextStyle(
                color: isDark ? whiteColor : blackTextColor,
                fontFamily: 'SF Pro Display',
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Title Name',
                hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
                filled: true,
                fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: controller.descriptionController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(
                  color: isDark ? whiteColor : blackTextColor,
                  fontFamily: 'SF Pro Display',
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: 'Descriptions',
                  hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = ['Jan','Feb','Mar','Apr','May','June','July','Aug','Sept','Oct','Nov','Dec'];
    return months[month - 1];
  }
}

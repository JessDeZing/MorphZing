import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/localization/translation_keys.dart';
import 'package:morphzing/utils/style/colors.dart';

class TemplateOptionBottomSheet extends StatelessWidget {
  final VoidCallback onPressedTemplate;
  final VoidCallback onPressedShare;
  final VoidCallback onPressedDelete;

  const TemplateOptionBottomSheet({
    super.key,
    required this.onPressedTemplate,
    required this.onPressedShare,
    required this.onPressedDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Container(
        height: 280,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              options.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? whiteColor : Color(0xFF050A41),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(7, 5, 10, 65),
              ),
              child: ListTile(
                onTap: () => onPressedTemplate(),
                leading: Icon(
                  Icons.menu_book,
                  color: isDark ? whiteColor : Color(0xFF050A41),
                ),
                title: Text(
                  templates.tr,
                  style: TextStyle(
                    fontSize: 17,
                    color: isDark ? whiteColor : Color(0xFF050A41),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(7, 5, 10, 65),
              ),
              child: ListTile(
                onTap: () => onPressedShare(),
                leading: Icon(
                  Icons.ios_share,
                  color: isDark ? whiteColor : Color(0xFF050A41),
                ),
                title: Text(
                  share.tr,
                  style: TextStyle(
                    fontSize: 17,
                    color: isDark ? whiteColor : Color(0xFF050A41),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(7, 5, 10, 65),
              ),
              child: ListTile(
                onTap: () => onPressedDelete(),
                leading: Icon(
                  Icons.delete,
                  color: Color(0xFFFF3B30),
                ),
                title: Text(
                  deleteJourney.tr,
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFFFF3B30),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

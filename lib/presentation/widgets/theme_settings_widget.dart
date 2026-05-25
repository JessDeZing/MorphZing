import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:morphzing/utils/theme_service.dart';

class ThemeSettingsWidget extends StatelessWidget {
  const ThemeSettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      final appController = Get.find<AppController>();
      final isDark = ThemeService.isDarkMode(context);

      return GetBuilder<AppController>(
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark ? darkCardColor : greyButton,
              border: Border.all(
                color: greyButton,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'theme'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SF Pro Display',
                    color: isDark
                        ? Theme.of(context).textTheme.bodyLarge?.color
                        : blackTextColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildThemeOption(
                  context,
                  controller,
                  ThemeModeType.system,
                  'system'.tr,
                  'followPhoneSettings'.tr,
                  Icons.brightness_auto,
                ),
                const SizedBox(height: 8),
                _buildThemeOption(
                  context,
                  controller,
                  ThemeModeType.light,
                  'light'.tr,
                  'alwaysLightTheme'.tr,
                  Icons.light_mode,
                ),
                const SizedBox(height: 8),
                _buildThemeOption(
                  context,
                  controller,
                  ThemeModeType.dark,
                  'dark'.tr,
                  'alwaysDarkTheme'.tr,
                  Icons.dark_mode,
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      // If AppController is not found, show a fallback widget
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.red.withOpacity(0.1),
          border: Border.all(
            color: Colors.red,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Settings (Error)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'SF Pro Display',
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'AppController not found: $e',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildThemeOption(
    BuildContext context,
    AppController controller,
    ThemeModeType mode,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = controller.themeModeType == mode;
    final isDark = ThemeService.isDarkMode(context);
    return GestureDetector(
      onTap: () {
        controller.setThemeMode(mode);
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? isDark
                  ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                  : Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? isDark
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? isDark
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor
                  : Theme.of(context).iconTheme.color,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontFamily: 'SF Pro Display',
                      color: isDark
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : blackTextColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Theme.of(context).textTheme.bodyMedium?.color
                          : blackTextColor,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: isDark
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

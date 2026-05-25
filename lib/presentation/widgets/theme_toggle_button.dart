import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/app_controller.dart';
import 'package:morphzing/utils/theme_service.dart';

class ThemeToggleButton extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const ThemeToggleButton({
    Key? key,
    this.size = 56.0,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return GetBuilder<AppController>(
      builder: (controller) {
        final isDark = controller.isDarkMode(context);

        return FloatingActionButton(
          onPressed: () => controller.toggleTheme(),
          backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          child: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: iconColor ?? Colors.white,
            size: size * 0.5,
          ),
          mini: size < 56.0,
        );
      },
    );
  }
}

class ThemeToggleIconButton extends StatelessWidget {
  final double size;
  final Color? color;
  final VoidCallback? onPressed;

  const ThemeToggleIconButton({
    Key? key,
    this.size = 24.0,
    this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return GetBuilder<AppController>(
      builder: (controller) {
        final isDark = controller.isDarkMode(context);

        return IconButton(
          onPressed: onPressed ?? () => controller.toggleTheme(),
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            size: size,
            color: color ?? Theme.of(context).iconTheme.color,
          ),
        );
      },
    );
  }
}

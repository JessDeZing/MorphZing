import 'package:flutter/material.dart';
import 'package:morphzing/utils/style/colors.dart';

class ThemeUtils {
  // Get theme-aware background color
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  // Get theme-aware surface color
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).cardColor;
  }

  // Get theme-aware text color
  static Color getTextColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.color ?? blackTextColor;
  }

  // Get theme-aware icon color
  static Color getIconColor(BuildContext context) {
    return Theme.of(context).iconTheme.color ?? blackTextColor;
  }

  // Get theme-aware border color
  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).dividerColor;
  }

  // Create theme-aware container decoration
  static BoxDecoration getContainerDecoration(
    BuildContext context, {
    double borderRadius = 10,
    Color? color,
  }) {
    return BoxDecoration(
      color: color ?? getSurfaceColor(context),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: getBorderColor(context),
        width: 1,
      ),
    );
  }

  // Create theme-aware text style
  static TextStyle getTextStyle(
    BuildContext context, {
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return TextStyle(
      color: color ?? getTextColor(context),
      fontFamily: 'SF Pro Display',
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}

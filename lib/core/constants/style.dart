import 'package:flutter/material.dart';

TextStyle staticTextStyle(double size, Color color) {
  return TextStyle(
    color: color,
    fontFamily: 'SF Pro Display',
    fontSize: size,
    fontWeight: FontWeight.bold,
  );
}

TextStyle customTextStyle({
  required double fontSize,
  required Color color,
  required FontWeight fontWeight,
  TextDecoration? textDecoration,
}) {
  return TextStyle(
    color: color,
    fontFamily: 'SF Pro Display',
    fontSize: fontSize,
    fontWeight: fontWeight,
    decoration: textDecoration,
  );
}

// Theme-aware text styles
TextStyle themeAwareTextStyle(BuildContext context, double size,
    {FontWeight? fontWeight}) {
  return TextStyle(
    color: Theme.of(context).textTheme.bodyLarge?.color,
    fontFamily: 'SF Pro Display',
    fontSize: size,
    fontWeight: fontWeight ?? FontWeight.normal,
  );
}

TextStyle themeAwareBoldTextStyle(BuildContext context, double size) {
  return themeAwareTextStyle(context, size, fontWeight: FontWeight.bold);
}

import 'package:flutter/material.dart';
import 'package:morphzing/utils/style/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      primaryColor: bgColor,
      scaffoldBackgroundColor: bgColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: whiteColor,
        foregroundColor: blackTextColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: blackTextColor,
          fontFamily: 'SF Pro Display',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: blackTextColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: blueColor,
          foregroundColor: whiteColor,
          elevation: 0,
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(
            color: whiteColor,
            fontSize: 16,
            fontFamily: "SF Pro Display",
          ),
          fixedSize: const Size(double.maxFinite, 50),
          minimumSize: const Size(double.maxFinite, 50),
          maximumSize: const Size(double.maxFinite, 50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: whiteColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: whiteColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: blueColor),
        ),
        hintStyle: const TextStyle(color: hintTextColor),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: blackTextColor),
        bodyMedium: TextStyle(color: blackTextColor),
        titleLarge: TextStyle(color: blackTextColor),
        titleMedium: TextStyle(color: blackTextColor),
        titleSmall: TextStyle(color: blackTextColor),
      ),
      iconTheme: const IconThemeData(color: blackTextColor),
      dividerTheme: const DividerThemeData(color: dividerColor),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: darkBgColor,
      scaffoldBackgroundColor: darkBgColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurfaceColor,
        foregroundColor: darkTextColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkTextColor,
          fontFamily: 'SF Pro Display',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: darkTextColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: blueColor,
          foregroundColor: whiteColor,
          elevation: 0,
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(
            color: whiteColor,
            fontSize: 16,
            fontFamily: "SF Pro Display",
          ),
          fixedSize: const Size(double.maxFinite, 50),
          minimumSize: const Size(double.maxFinite, 50),
          maximumSize: const Size(double.maxFinite, 50),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: darkCardColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: blueColor),
        ),
        hintStyle: const TextStyle(color: darkHintTextColor),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: darkTextColor),
        bodyMedium: TextStyle(color: darkTextColor),
        titleLarge: TextStyle(color: darkTextColor),
        titleMedium: TextStyle(color: darkTextColor),
        titleSmall: TextStyle(color: darkTextColor),
      ),
      iconTheme: const IconThemeData(color: darkTextColor),
      dividerTheme: const DividerThemeData(color: darkBorderColor),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: darkSurfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
    );
  }
}

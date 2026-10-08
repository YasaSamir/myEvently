import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class AppTheming {
  static ThemeMode themeMode = ThemeMode.light;
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.lightBG,
    ),
    scaffoldBackgroundColor: AppColors.lightBG,
    colorScheme: ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightPrimary,
      onSecondary: AppColors.white,
      onPrimaryContainer: AppColors.white,
      onSecondaryContainer: AppColors.white,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.lightPrimary,
        fontSize: 24.sp,
        fontWeight: .w600,
      ),
      titleLarge: TextStyle(
        color: AppColors.lightMainText,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: AppColors.lightSecText,
        fontSize: 16.sp,
      ),
      titleMedium: TextStyle(
        color: AppColors.lightPrimary,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        color: AppColors.lightSecText,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      ),
        labelLarge: TextStyle(
          color: AppColors.lightPrimary,
          fontSize: 14.sp,
          fontWeight:.w600,
        )
    )
  );
  static ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.darkBG,
    ),
    scaffoldBackgroundColor: AppColors.darkBG,
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkPrimary,
      onSecondary: AppColors.white,
      onPrimaryContainer: AppColors.darkFill,
      onSecondaryContainer: AppColors.darkStroke,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.white,
        fontSize: 24.sp,
        fontWeight: .w600,
      ),
      titleLarge: TextStyle(
        color: AppColors.white,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: AppColors.darkSecText,
        fontSize: 16.sp,
      ),
      titleMedium: TextStyle(
        color: AppColors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        color: AppColors.darkSecText,
        fontSize: 14.sp,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: TextStyle(
        color: AppColors.darkPrimary,
        fontSize: 14.sp,
        fontWeight:.w600,
      )
    ),
  );
}
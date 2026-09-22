import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flixora/resources/colors_app.dart';

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      surface: AppColors.transparent,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.white,
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? AppColors.white
              : AppColors.muted,
        ),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -.8,
      ),
      headlineMedium: TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -.6,
      ),
      titleLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -.3,
      ),
      titleMedium: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(fontSize: 14.sp, height: 1.45),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.white,
        minimumSize: Size(48.w, 48.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      ),
    ),
  );
}

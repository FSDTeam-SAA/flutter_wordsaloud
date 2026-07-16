import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.primaryWhite,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryBlue,
      onPrimary: AppColors.primaryWhite,
      surface: AppColors.primaryWhite,
      onSurface: AppColors.primaryBlack,
      surfaceContainer: AppColors.inputBgColorLight,
      surfaceContainerHighest: Color(0xFFE8E8E8),
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: AppColors.primaryWhite,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.primaryBlack,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.primaryBlack),
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.primaryBlack,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryBlue,
      onPrimary: AppColors.primaryWhite,
      surface: AppColors.primaryBlack,
      onSurface: AppColors.primaryWhite,
      surfaceContainer: AppColors.inputBgColorDark,
      surfaceContainerHighest: Color(0xFF1E1E1E),
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: AppColors.primaryBlack,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: AppColors.primaryWhite,
        fontWeight: FontWeight.w700,
        fontSize: 24,
      ),
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.primaryWhite),
    ),
  );
}

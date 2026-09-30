import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';
import 'button_style.dart';

/// Layoq app theme: flat design, not Material 3. No elevation, no
/// drop shadows, no default Material ripple depth — surfaces are told
/// apart with flat color and hairline borders instead.
///
/// Typeface: Nexa is a commercial font with no free redistribution
/// license, so it can't be bundled here. Poppins (Google Fonts) stands
/// in as a geometric-sans lookalike until licensed Nexa font files are
/// available — swap it out in one place by changing [_fontFamily]
/// below and adding the real font files under assets/fonts/.
///
/// Text styling is centralized in [AppTextStyles]; this maps that scale
/// onto Flutter's [TextTheme] so `Theme.of(context).textTheme` stays
/// consistent with it everywhere.
class AppTheme {
  AppTheme._();

  static final String? _fontFamily = GoogleFonts.poppins().fontFamily;

  static ThemeData light = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: _fontFamily,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      error: AppColors.red,
    ),
    textTheme: const TextTheme(
      headlineLarge: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      headlineSmall: AppTextStyles.h3,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.primaryDark,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.primaryDark,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: AppButtonStyle.primary()),
    outlinedButtonTheme: OutlinedButtonThemeData(style: AppButtonStyle.secondary()),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
      ),
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        side: BorderSide(color: AppColors.hairline),
      ),
      margin: EdgeInsets.zero,
    ),
  );
}

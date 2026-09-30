import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Layoq type scale. Font family is intentionally left unset so text
/// renders with each platform's native system font (SF Pro on iOS,
/// Roboto on Android) — see [AppTheme].
///
/// Scale:
/// - Heading: h1 (28/700), h2 (22/700), h3 (18/700)
/// - Body: bodyLarge (16/400), bodyMedium (14/400), bodySmall (12/400)
/// - Label: labelLarge (14/600), labelMedium (13/600), labelSmall (12/500)
/// - Button: button (16/600)
class AppTextStyles {
  AppTextStyles._();

  // Headings — page titles and section headers.
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
  );

  // Body — paragraph and field content.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryDark,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  // Labels — field labels, nav labels, small UI text.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDark,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 13,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryDark,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  // Button — CTA and interactive control text.
  static const TextStyle button = TextStyle(
    fontSize: 16,
    height: 1,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

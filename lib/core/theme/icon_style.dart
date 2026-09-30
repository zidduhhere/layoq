import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Preset icon sizes used across Layoq, so every icon picks from the
/// same small scale instead of an ad-hoc number.
class AppIconSize {
  AppIconSize._();

  /// Inline badges, e.g. the "Illuminated" tag's bolt.
  static const double xs = 12;

  /// Inline with body text, e.g. a location pin next to an address.
  static const double sm = 16;

  /// Standard tappable icon: search, calendar, menu rows, icon buttons.
  static const double md = 20;

  /// Bottom navigation icons.
  static const double lg = 24;

  /// Empty-state illustrations.
  static const double xl = 32;

  /// Large placeholder motifs, e.g. the listing photo header.
  static const double xxl = 96;
}

/// Preset icon colors used across Layoq, so every icon picks from the
/// same small palette instead of reaching for an arbitrary color.
class AppIconColor {
  AppIconColor._();

  /// Brand purple — selected/active state, primary accents.
  static const Color primary = AppColors.primary;

  /// Near-black — default icon color on a light surface.
  static const Color dark = AppColors.primaryDark;

  /// Muted — unselected/inactive state, secondary icons.
  static const Color muted = AppColors.textMuted;

  /// Warm accent — the illuminated/bolt indicator only.
  static const Color accent = AppColors.yellow;

  /// White — icons on a solid-color surface (e.g. inside a filled button).
  static const Color light = Colors.white;
}

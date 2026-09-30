import 'package:flutter/material.dart';

/// Layoq brand palette.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF490059);
  static const Color primaryDark = Color(0xFF2D1633);
  static const Color yellow = Color(0xFFFFA314);
  static const Color red = Color(0xFFB72818);
  static const Color blue = Color(0xFF4B75FF);
  static const Color green = Color(0xFF148D51); // Added for success states

  /// Semantic tokens mapped from the brand palette
  static const Color error = red;
  static const Color warning = yellow;
  static const Color info = blue;
  static const Color success = green;

  /// Neutral tokens tinted off the brand palette, used for field surfaces
  /// and dividers instead of flat generic greys.
  static const Color fieldFill = Color(0xFFF4F0F6);
  static const Color hairline = Color(0xFFE7E1E9);
  static const Color textMuted = Color(0xFF8A7B8F);
}

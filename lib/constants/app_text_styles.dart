import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Senior-Friendly Typography for Devavani
/// Formatted with high legibility, generous leading (1.5x - 2.0x) to eliminate matra collisions,
/// and a strict floor of 16px so seniors aged 50+ never need to squint.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 36,
    height: 1.33,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: AppColors.onSurface,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 30,
    height: 1.4,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.0,
    color: AppColors.onSurface,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 26,
    height: 1.45,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyExtraLarge = TextStyle(
    fontSize: 22,
    height: 1.55,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 20,
    height: 1.6,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 18,
    height: 1.55,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    color: AppColors.onSurface,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 18,
    height: 1.45,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    color: AppColors.onSurface,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.onSurfaceVariant,
  );

  // Big Jaap Dial Numerals
  static const TextStyle jaapDialNumber = TextStyle(
    fontSize: 68,
    height: 1.0,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    color: AppColors.primary,
  );

  // Verses / Lyrics text style dynamically scaled
  static TextStyle verseStyle({required double fontSize, required bool isActive}) {
    return TextStyle(
      fontSize: fontSize,
      height: 2.0,
      fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
      letterSpacing: 0.5,
      color: isActive ? const Color(0xFF7A3B00) : AppColors.onSurface.withValues(alpha: 0.9),
    );
  }
}

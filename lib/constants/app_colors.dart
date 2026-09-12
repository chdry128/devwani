import 'package:flutter/material.dart';

/// Sacred Color Palette for Devavani
/// Meticulously calibrated for elderly eyes (50+), high contrast (AAA > 7:1),
/// and traditional temple warmth (Kesariya, Kumkum, Chandan, Soft Parchment).
class AppColors {
  AppColors._();

  // Primary: Kesariya / Marigold / Warm Saffron
  static const Color primary = Color(0xFF944A00);
  static const Color primaryContainer = Color(0xFFE67E22);
  static const Color primaryFixed = Color(0xFFFFDCC5);
  static const Color primaryFixedDim = Color(0xFFFFB783);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF502600);

  // Secondary: Kumkum / Vermilion
  static const Color secondary = Color(0xFFB51A1B);
  static const Color secondaryContainer = Color(0xFFD93630);
  static const Color secondaryFixed = Color(0xFFFFDAD6);
  static const Color secondaryFixedDim = Color(0xFFFFB4AB);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryFixed = Color(0xFF410002);

  // Tertiary: Chandan / Warm Gold & Amber
  static const Color tertiary = Color(0xFF865300);
  static const Color tertiaryContainer = Color(0xFFD78800);
  static const Color tertiaryFixed = Color(0xFFFFDDB9);
  static const Color tertiaryFixedDim = Color(0xFFFFB961);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryFixed = Color(0xFF2B1700);

  // Background & Sacred Parchment Surfaces
  static const Color background = Color(0xFFFFF8F6);
  static const Color surface = Color(0xFFFFF8F6);
  static const Color surfaceCream = Color(0xFFFAF3E0);
  static const Color surfaceParchment = Color(0xFFFDFBF7);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFFFF1EB);
  static const Color surfaceContainer = Color(0xFFFAEBE4);
  static const Color surfaceContainerHigh = Color(0xFFF4E5DF);
  static const Color surfaceContainerHighest = Color(0xFFEFDFD9);

  // Ultra-High Contrast Senior Typography (Temple Soot / Charcoal)
  static const Color onSurface = Color(0xFF211A16);
  static const Color onSurfaceVariant = Color(0xFF564337);
  static const Color onBackground = Color(0xFF211A16);

  // Borders & Accents
  static const Color outline = Color(0xFF897365);
  static const Color outlineVariant = Color(0xFFDCC1B1);
  static const Color sacredGoldBorder = Color(0xFFE8D8B8);

  // Error & Caution
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);

  // Saffron Action Gradient
  static const LinearGradient saffronGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD96B14),
      Color(0xFFE67E22),
    ],
  );

  // Ambient Halo Shadow for Touch Cards
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0xFF2C2420).withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> activeDialShadow = [
    BoxShadow(
      color: const Color(0xFF944A00).withValues(alpha: 0.18),
      blurRadius: 28,
      offset: const Offset(0, 10),
    ),
  ];
}

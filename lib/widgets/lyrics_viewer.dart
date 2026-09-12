import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/aarti.dart';

/// Senior-Optimized Lyrics Viewer
/// Displays sacred Doha and Chaupai with:
/// 1. Prominent active verse highlighting
/// 2. Large font scaling buttons (A- / A+)
/// 3. Generous line height (2.0x) preventing matra collision
class LyricsViewer extends StatelessWidget {
  final List<AartiVerse> verses;
  final int activeVerseIndex;
  final double normalFontSize;
  final double activeFontSize;
  final VoidCallback onIncreaseFont;
  final VoidCallback onDecreaseFont;

  const LyricsViewer({
    super.key,
    required this.verses,
    required this.activeVerseIndex,
    required this.normalFontSize,
    required this.activeFontSize,
    required this.onIncreaseFont,
    required this.onDecreaseFont,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with Title and Font Scaling
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 26,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'पवित्र दोहा एवं चौपाई',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              // Font Scaling Buttons
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: onDecreaseFont,
                      borderRadius: BorderRadius.circular(99),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        child: const Text(
                          'अ A-',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: onIncreaseFont,
                      borderRadius: BorderRadius.circular(99),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(99),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryContainer.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'अ A+',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.surfaceContainer,
          ),
          const SizedBox(height: 16),
          // Verses Flow
          ...List.generate(verses.length, (index) {
            final verse = verses[index];
            final isActive = index == activeVerseIndex;

            if (isActive) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryFixed.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 2.0,
                  ),
                ),
                child: Text(
                  verse.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: activeFontSize,
                    height: 2.1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: const Color(0xFF7A3B00),
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                verse.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: normalFontSize,
                  height: 2.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: AppColors.onSurface.withValues(alpha: 0.85),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

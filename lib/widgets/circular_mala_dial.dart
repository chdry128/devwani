import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/devanagari_helper.dart';

/// Tactile Circular Japa Mala Dial
/// 270px central circle with animated stroke progress ring,
/// Devanagari numerals, watermarked ॐ symbol, and Rudraksha motif dots.
class CircularMalaDial extends StatelessWidget {
  final int count;
  final int target;
  final double progress;

  const CircularMalaDial({
    super.key,
    required this.count,
    this.target = 108,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final devanagariCount = DevanagariHelper.format(count);
    final devanagariTarget = DevanagariHelper.format(target);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 270px Circular Dial
        Container(
          width: 270,
          height: 270,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryFixed,
                AppColors.surfaceContainerHighest,
              ],
            ),
            boxShadow: AppColors.activeDialShadow,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Custom Painted Circular Progress Ring
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _MalaProgressPainter(
                      progress: progress,
                      trackColor: const Color(0xFFFAEBE4),
                      progressColor: AppColors.primaryContainer,
                      strokeWidth: 8.0,
                    ),
                  ),
                ),
              ),
              // Inner Core Disc
              Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerLowest,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2C2420).withValues(alpha: 0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Auspicious ॐ Watermark
                      Text(
                        'ॐ',
                        style: TextStyle(
                          fontSize: 120,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryFixedDim.withValues(alpha: 0.28),
                          height: 1.0,
                        ),
                      ),
                      // Core Numerals & Labels
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            devanagariCount,
                            style: const TextStyle(
                              fontSize: 66,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              height: 1.0,
                              letterSpacing: -1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'जाप पूर्ण',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              'लक्ष्य: $devanagariTarget',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.tertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        // Rudraksha Motif Beads Preview (static, cached via const)
        const _DecorativeRudrakshaRow(),
      ],
    );
  }
}

/// Static, const-cached decorative Rudraksha beads row that never rebuilds on tap
class _DecorativeRudrakshaRow extends StatelessWidget {
  const _DecorativeRudrakshaRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryFixed,
              width: 3.5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            color: AppColors.outlineVariant,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: AppColors.outlineVariant,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _MalaProgressPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  _MalaProgressPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    // Start at -pi / 2 (top center)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MalaProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor;
  }
}

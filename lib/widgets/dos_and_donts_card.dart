import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Clean Guidance Card for Seniors: "क्या करें" (Dos) & "क्या न करें" (Don'ts)
class DosAndDontsCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<String> items;
  final bool isNegative; // true for Don'ts, false for Dos

  const DosAndDontsCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.items,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isNegative ? AppColors.secondary : AppColors.primary;
    final badgeBgColor = isNegative
        ? AppColors.secondaryFixed.withValues(alpha: 0.6)
        : AppColors.surfaceContainerLow;
    final badgeIcon = isNegative ? Icons.cancel_rounded : Icons.check_circle_rounded;
    final itemBgColor = isNegative
        ? AppColors.secondaryFixed.withValues(alpha: 0.22)
        : AppColors.surfaceContainerLow;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: isNegative
              ? AppColors.secondary.withValues(alpha: 0.20)
              : AppColors.outlineVariant.withValues(alpha: 0.40),
          width: 1.5,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    badgeIcon,
                    size: 28,
                    color: iconColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        height: 1.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
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
          const SizedBox(height: 14),
          // Crisp Guidelines Items
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: itemBgColor,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, right: 10.0),
                      child: Icon(
                        isNegative ? Icons.close_rounded : Icons.check_rounded,
                        size: 22,
                        color: iconColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

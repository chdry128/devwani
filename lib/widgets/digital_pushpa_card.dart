import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/haptic_service.dart';

/// Digital Flower Offering (Pushpa Arpan) Widget
/// Offers seniors a gentle, interactive devotional ritual with visual & haptic affirmation.
class DigitalPushpaCard extends StatefulWidget {
  final String deityName;
  final VoidCallback? onOffered;

  const DigitalPushpaCard({
    super.key,
    this.deityName = 'गणपति बप्पा',
    this.onOffered,
  });

  @override
  State<DigitalPushpaCard> createState() => _DigitalPushpaCardState();
}

class _DigitalPushpaCardState extends State<DigitalPushpaCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  int _offeredCount = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleOfferFlower() {
    HapticService.buttonPress();
    setState(() {
      _offeredCount++;
    });

    _animController.forward(from: 0.0).then((_) {
      if (mounted) {
        _animController.reverse();
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF372F2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.spa_rounded,
                color: AppColors.primaryFixedDim,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'पुष्प समर्पित हुआ! ${widget.deityName} मोरिया!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }

    widget.onOffered?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          // Flower Icon with pulse animation
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.local_florist_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'डिजिटल पुष्प अर्पण',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'चरणों में पुष्प अर्पित करें ($_offeredCount पुष्प अर्पित)',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Large 56px Action Button
          ElevatedButton.icon(
            onPressed: _handleOfferFlower,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(120, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            icon: const Icon(Icons.spa_rounded, size: 20),
            label: const Text(
              'अर्पित करें',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

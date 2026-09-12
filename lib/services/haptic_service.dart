import 'package:flutter/services.dart';

/// Gentle tactile feedback service specifically tuned for elderly users
class HapticService {
  HapticService._();

  /// Soft tactile feedback for regular bead press
  static Future<void> beadFeedback() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {
      // Ignore if device has no vibrator
    }
  }

  /// Celebratory sacred vibration pattern upon completing 108 beads (1 full Mala)
  static Future<void> malaCompletedFeedback() async {
    try {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 150));
      await HapticFeedback.heavyImpact();
    } catch (_) {
      // Ignore if device has no vibrator
    }
  }

  /// Feedback for button presses
  static Future<void> buttonPress() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {
      // Ignore
    }
  }
}

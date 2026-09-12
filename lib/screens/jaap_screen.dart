import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/mantra.dart';
import '../providers/jaap_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/devanagari_helper.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/circular_mala_dial.dart';

/// Full-Screen Tappable Jaap Counter Screen
/// Tailored for elderly devotees with full-screen touch recognition,
/// soft vibration, temple bell chime, Devanagari numerals, and mantra picker.
class JaapScreen extends StatelessWidget {
  const JaapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jaap = context.watch<JaapProvider>();
    final lang = context.watch<SettingsProvider>().language;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        title: AppStrings.get('jaapTitle', lang: lang),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Column(
            children: [
              // 1. Interactive Full Tap Canvas
              _buildInteractiveTapZone(context, jaap, lang),
              const SizedBox(height: 16),

              // 2. Bento Stats (Today's Total & Malas Done)
              _buildBentoStats(context, jaap, lang),
              const SizedBox(height: 14),

              // 3. Satsang / Inspiration Tip Card
              _buildInspirationCard(context, lang),
              const SizedBox(height: 18),

              // 4. Accessible Bottom Controls (Haptics, Sound, Protected Reset)
              _buildBottomControls(context, jaap, lang),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Full-Screen Tappable Area
  Widget _buildInteractiveTapZone(
    BuildContext context,
    JaapProvider jaap,
    String lang,
  ) {
    return GestureDetector(
      key: const Key('jaap_tap_zone'),
      behavior: HitTestBehavior.opaque,
      onTap: () => jaap.incrementBead(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(28.0),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF944A00).withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top: Mantra Title & Change Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.flare_rounded,
                  size: 26,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    jaap.selectedMantra.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Accessible Mantra Change Pill Button
            ElevatedButton.icon(
              onPressed: () => _showMantraPicker(context, jaap, lang),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceContainerHigh,
                foregroundColor: AppColors.primary,
                minimumSize: const Size(160, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99),
                ),
                elevation: 1,
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              icon: const Icon(Icons.sync_alt_rounded, size: 22),
              label: Text(
                AppStrings.get('changeMantra', lang: lang),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Central Circular Mala Dial
            IgnorePointer(
              child: CircularMalaDial(
                count: jaap.count,
                target: jaap.selectedMantra.targetCount,
                progress: jaap.progress,
              ),
            ),
            const SizedBox(height: 22),

            // Friendly Tap Anywhere Instruction Pill
            IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.touch_app_rounded,
                      size: 26,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.get('tapAnywherePrompt', lang: lang),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Big Clear Bento Stats (Today's Total & Malas Done)
  Widget _buildBentoStats(
    BuildContext context,
    JaapProvider jaap,
    String lang,
  ) {
    return Row(
      children: [
        // Box 1: Today's Total
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(22.0),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 24,
                      color: AppColors.tertiary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppStrings.get('todayTotal', lang: lang),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      DevanagariHelper.format(jaap.dailyTotal),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppStrings.get('jaapUnit', lang: lang),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Box 2: Malas Completed
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(22.0),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 24,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppStrings.get('malasCompleted', lang: lang),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      DevanagariHelper.format(jaap.malasCompleted),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      AppStrings.get('malasSuffix', lang: lang),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Satsang Tip Card
  Widget _buildInspirationCard(BuildContext context, String lang) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(22.0),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.wb_twilight_rounded,
                size: 26,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.get('inspirationTitle', lang: lang),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.get('inspirationQuote', lang: lang),
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Accessible Bottom Controls: Vibration toggle, Sound toggle, Reset
  Widget _buildBottomControls(
    BuildContext context,
    JaapProvider jaap,
    String lang,
  ) {
    return Column(
      children: [
        Row(
          children: [
            // Vibration Toggle Button (Min height 56px)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => jaap.toggleVibration(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerHighest,
                  foregroundColor: AppColors.onSurface,
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                  elevation: 1,
                ),
                icon: Icon(
                  jaap.vibrationEnabled ? Icons.vibration : Icons.mobile_off,
                  size: 26,
                  color: AppColors.primary,
                ),
                label: Text(
                  jaap.vibrationEnabled
                      ? AppStrings.get('vibrationOn', lang: lang)
                      : AppStrings.get('vibrationOff', lang: lang),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Sound Toggle Button (Min height 58px)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => jaap.toggleSound(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerHighest,
                  foregroundColor: AppColors.onSurface,
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                  elevation: 1,
                ),
                icon: Icon(
                  jaap.soundEnabled ? Icons.volume_up : Icons.volume_off,
                  size: 26,
                  color: AppColors.primary,
                ),
                label: Text(
                  jaap.soundEnabled
                      ? AppStrings.get('soundBell', lang: lang)
                      : AppStrings.get('soundOff', lang: lang),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Protected Oversized Reset Bead Button (Protected against hand tremors)
        ElevatedButton.icon(
          onPressed: () => _confirmReset(context, jaap, lang),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryFixed,
            foregroundColor: AppColors.secondary,
            minimumSize: const Size.fromHeight(60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99),
            ),
            elevation: 2,
          ),
          icon: const Icon(Icons.restart_alt_rounded, size: 28),
          label: Text(
            AppStrings.get('resetCounter', lang: lang),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  /// Protected Reset Confirmation Dialog
  void _confirmReset(
    BuildContext context,
    JaapProvider jaap,
    String lang,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          AppStrings.get('resetConfirmTitle', lang: lang),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.secondary,
          ),
        ),
        content: Text(
          AppStrings.get('resetConfirmMsg', lang: lang),
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.onSurface,
            height: 1.5,
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              AppStrings.get('cancel', lang: lang),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              jaap.resetCount();
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              AppStrings.get('resetConfirmYes', lang: lang),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Accessible Mantra Selection Modal Sheet
  void _showMantraPicker(
    BuildContext context,
    JaapProvider jaap,
    String lang,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.get('selectMantraTitle', lang: lang),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 28),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...Mantra.defaultMantras.map((mantra) {
              final isSelected = jaap.selectedMantra.id == mantra.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                  onTap: () {
                    jaap.selectMantra(mantra);
                    Navigator.of(ctx).pop();
                  },
                  borderRadius: BorderRadius.circular(18),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                      vertical: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryFixed.withValues(alpha: 0.6)
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mantra.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                mantra.meaning,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          size: 28,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

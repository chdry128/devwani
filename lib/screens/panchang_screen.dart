import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/panchang_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/date_formatter.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/dos_and_donts_card.dart';

/// Simplified Panchang Screen for Senior Users
/// Focuses purely on what matters: Tithi, Sunrise/Sunset, 3 Dos, and 3 Don'ts.
class PanchangScreen extends StatelessWidget {
  final bool showBackButton;

  const PanchangScreen({
    super.key,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final panchang = context.watch<PanchangProvider>().data;
    final lang = context.watch<SettingsProvider>().language;
    final formattedDate = DateFormatter.formatFullDate(panchang.date, lang: lang);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        title: AppStrings.get('panchangTitle', lang: lang),
        showBackButton: showBackButton,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title & Date Header
              _buildHeader(context, formattedDate, lang),
              const SizedBox(height: 18),

              // Section 1: Main Tithi Card
              _buildTithiCard(context, panchang, lang),
              const SizedBox(height: 16),

              // Section 2: Sunrise & Sunset Twin Cards
              _buildSunriseSunsetCards(context, panchang, lang),
              const SizedBox(height: 18),

              // Section 3: आज क्या करें (Positive Guidelines - 3 Crisp Bullets)
              DosAndDontsCard(
                title: AppStrings.get('whatToDo', lang: lang),
                items: panchang.dos,
                isNegative: false,
              ),
              const SizedBox(height: 16),

              // Section 4: आज क्या न करें (Precautions - 3 Crisp Bullets)
              DosAndDontsCard(
                title: AppStrings.get('whatToAvoid', lang: lang),
                items: panchang.donts,
                isNegative: true,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String formattedDate, String lang) {
    return Column(
      children: [
        Text(
          AppStrings.get('panchangTitle', lang: lang),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          formattedDate,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Main Tithi Card
  Widget _buildTithiCard(
    BuildContext context,
    dynamic panchang,
    String lang,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.45),
          width: 2.0,
        ),
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
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.get('mainTithi', lang: lang),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            panchang.tithi,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.stars_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    panchang.specialDay,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Sunrise & Sunset Twin Cards
  Widget _buildSunriseSunsetCards(
    BuildContext context,
    dynamic panchang,
    String lang,
  ) {
    return Row(
      children: [
        // Sunrise Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(22.0),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.40),
                width: 1.5,
              ),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryFixed,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.wb_sunny_rounded,
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.get('sunrise', lang: lang),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  panchang.sunrise,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Sunset Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(18.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(22.0),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.40),
                width: 1.5,
              ),
              boxShadow: AppColors.cardShadow,
            ),
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.nights_stay_rounded,
                      size: 30,
                      color: AppColors.tertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.get('sunset', lang: lang),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  panchang.sunset,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

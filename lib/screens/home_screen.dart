import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../constants/asset_paths.dart';
import '../providers/settings_provider.dart';
import '../widgets/action_card.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/banner_ad_widget.dart';
import 'panchang_screen.dart';
import 'settings_screen.dart';

/// Devavani Home Screen
/// Simple, calm, and senior-friendly with 3 large actionable devotional cards
class HomeScreen extends StatelessWidget {
  final VoidCallback onOpenAarti;
  final VoidCallback onOpenJaap;

  const HomeScreen({
    super.key,
    required this.onOpenAarti,
    required this.onOpenJaap,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<SettingsProvider>().language;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        onProfile: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            ),
          );
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Peaceful Hero Atmosphere Area with Temple Diya Background
              _buildPeacefulHeroCard(context, lang),
              const SizedBox(height: 20),

              // 2. Main 3 Large Devotional Action Cards
              // Card 1: Today's Aarti & Chalisa
              ActionCard(
                title: AppStrings.get('aartiCardTitle', lang: lang),
                subtitle: AppStrings.get('aartiCardSub', lang: lang),
                badgeText: AppStrings.get('mainPrayerBadge', lang: lang),
                badgeIcon: Icons.local_fire_department_rounded,
                leadingIcon: Icons.play_arrow_rounded,
                isFeaturedGradient: true,
                onTap: onOpenAarti,
              ),
              const SizedBox(height: 16),

              // Card 2: Japa Mala Counter
              ActionCard(
                title: AppStrings.get('jaapCardTitle', lang: lang),
                subtitle: AppStrings.get('jaapCardSub', lang: lang),
                leadingIcon: Icons.radio_button_checked_rounded,
                leadingBgColor: AppColors.tertiaryFixed,
                leadingIconColor: AppColors.tertiary,
                onTap: onOpenJaap,
              ),
              const SizedBox(height: 16),

              // Card 3: Today's Panchang
              ActionCard(
                title: AppStrings.get('panchangCardTitle', lang: lang),
                subtitle: AppStrings.get('panchangCardSub', lang: lang),
                leadingIcon: Icons.calendar_month_rounded,
                leadingBgColor: AppColors.secondaryFixed,
                leadingIconColor: AppColors.secondary,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PanchangScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // 3. Clean Non-intrusive Banner Ad
              const BannerAdWidget(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeacefulHeroCard(BuildContext context, String lang) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Temple Diya image with warm gradient overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: Image.asset(
                AssetPaths.templeDiya,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.primaryFixed.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.surfaceContainerLow,
                    AppColors.surfaceContainerLow.withValues(alpha: 0.90),
                    AppColors.surfaceContainerLow.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.flare_rounded,
                      size: 24,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.get('morningGreeting', lang: lang),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.get('namaste', lang: lang),
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: AppColors.onSurface,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.get('auspiciousDay', lang: lang),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
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

}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/deity.dart';
import '../providers/settings_provider.dart';
import '../services/audio_player_service.dart';
import '../services/haptic_service.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/digital_pushpa_card.dart';
import '../widgets/dos_and_donts_card.dart';
import '../widgets/god_image.dart';
import 'settings_screen.dart';

/// More Screen featuring "God of the Day" (आज के देवता: श्री गणेश जी)
/// plus multi-language switcher and prayer reminder settings
class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _isPlayingMantra = false;

  Future<void> _toggleMantraAudio() async {
    final audioService = context.read<AudioPlayerService>();
    await HapticService.buttonPress();

    setState(() {
      _isPlayingMantra = !_isPlayingMantra;
    });

    if (_isPlayingMantra) {
      // Play sacred chime
      await audioService.playTempleBell();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final lang = settings.language;
    // Dynamically select today's deity based on weekday/festival/user preference
    final deity = DeityOfDay.fromToday(
      lang: lang,
      preferredGodIds: settings.selectedDeities,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(title: AppStrings.get('moreTitle', lang: lang)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Deity Hero Card
              _buildDeityHeroCard(context, deity, lang),
              const SizedBox(height: 18),

              // 2. Prominent Mantra Card
              _buildMantraCard(context, deity, lang),
              const SizedBox(height: 18),

              // 3. Guidance: क्या करें (Dos)
              DosAndDontsCard(
                title: AppStrings.get('whatToDo', lang: lang),
                subtitle: 'शुभ और फलदायी नियम',
                items: deity.dos,
                isNegative: false,
              ),
              const SizedBox(height: 16),

              // 4. Guidance: क्या न करें (Don'ts)
              DosAndDontsCard(
                title: AppStrings.get('whatToAvoid', lang: lang),
                subtitle: 'पूजा में इन बातों से बचें',
                items: deity.donts,
                isNegative: true,
              ),
              const SizedBox(height: 18),

              // 5. Digital Pushpa Arpan Card
              DigitalPushpaCard(deityName: deity.name),
              const SizedBox(height: 24),

              // 6. Preferences & Settings Card (Language, Brahma Muhurta)
              _buildSettingsCard(context, settings, lang),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Deity Hero Card
  Widget _buildDeityHeroCard(
    BuildContext context,
    DeityOfDay deity,
    String lang,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image with Badge
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: GodImage(
                  godId: deity.id,
                  fallbackPath: deity.imagePath,
                  iconSize: 60,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.70),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    deity.daySpecial,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deity.title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  deity.description,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Prominent Mantra Card
  Widget _buildMantraCard(BuildContext context, DeityOfDay deity, String lang) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.primaryFixed.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.20),
          width: 1.5,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'ॐ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                deity.mantraTitle,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Inner Sacred Mantra Disc
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2C2420).withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  deity.mantraText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  deity.mantraMeaning,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Play Mantra Audio Button
          ElevatedButton.icon(
            onPressed: _toggleMantraAudio,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
              elevation: 2,
            ),
            icon: Icon(
              _isPlayingMantra ? Icons.pause_rounded : Icons.volume_up_rounded,
              size: 28,
            ),
            label: Text(
              _isPlayingMantra
                  ? AppStrings.get('listeningMantra', lang: lang)
                  : AppStrings.get('listenMantraChant', lang: lang),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  /// App Preferences (Language Selector & Brahma Muhurta Alarm)
  Widget _buildSettingsCard(
    BuildContext context,
    SettingsProvider settings,
    String lang,
  ) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.40),
          width: 1.5,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.settings_rounded,
                size: 26,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.get('settingsHeader', lang: lang),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Language Selector
          Text(
            AppStrings.get('languageSetting', lang: lang),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildLanguageChip(context, settings, 'hi', 'हिन्दी'),
              const SizedBox(width: 8),
              _buildLanguageChip(context, settings, 'ne', 'नेपाली'),
              const SizedBox(width: 8),
              _buildLanguageChip(context, settings, 'en', 'English'),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: AppColors.surfaceContainer),
          const SizedBox(height: 16),

          // Brahma Muhurta Reminder Switch
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('brahmaMuhurtaReminder', lang: lang),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'दैनिक मंगल बेला में शांत स्मरण',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 1.15,
                child: Switch(
                  value: settings.brahmaMuhurtaEnabled,
                  activeTrackColor: AppColors.primaryContainer,
                  activeThumbColor: Colors.white,
                  onChanged: (val) => settings.toggleBrahmaMuhurta(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.surfaceContainer),
          const SizedBox(height: 14),

          // Offline Ready Assurance
          Row(
            children: [
              const Icon(
                Icons.cloud_done_rounded,
                size: 24,
                color: Color(0xFF2E7D32),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppStrings.get('offlineReady', lang: lang),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Open Full Settings Screen Button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceContainerHigh,
              foregroundColor: AppColors.primary,
              elevation: 0,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  width: 1.2,
                ),
              ),
            ),
            icon: const Icon(Icons.tune_rounded, size: 22),
            label: Text(
              AppStrings.get('settingsScreenTitle', lang: lang),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageChip(
    BuildContext context,
    SettingsProvider settings,
    String code,
    String label,
  ) {
    final isSelected = settings.language == code;

    return Expanded(
      child: InkWell(
        onTap: () => settings.setLanguage(code),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryContainer
                : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

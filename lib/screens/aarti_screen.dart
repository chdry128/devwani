// ══════════════════════════════════════════════════════════════════════════════
// AAJ KI AARTI SCREEN — Senior-Friendly Daily Devotional Aarti & Chalisa Player
// ══════════════════════════════════════════════════════════════════════════════
//
// Highlights:
// 1. Automatic Aarti selection based on 4-tier priority:
//    Priority 1: Major Hindu festival today
//    Priority 2: Traditional weekday deity mapping (Mon=Shiva, Tue=Hanuman, etc.)
//    Priority 3: User's preferred deity chosen during onboarding
//    Priority 4: Universal fallback (Hanuman Chalisa or Shiv Aarti)
// 2. Offline audio playback with just_audio (Play, Pause, Seek, 10s Skip, Loop)
// 3. Large auto-scrolling lyrics from matching .txt file (no distracting karaoke)
// 4. Elderly-first touch targets: 82px play button, thick progress bar, A-/A+ zoom
// 5. Calm cream and soft saffron visual harmony matching Devavani design system

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/aarti_item.dart';
import '../providers/audio_provider.dart';
import '../providers/settings_provider.dart';
import '../services/aaj_ki_aarti_service.dart';
import '../services/haptic_service.dart';
import '../utils/devanagari_helper.dart';
import '../widgets/aarti_lyrics_scroller.dart';
import '../widgets/app_top_bar.dart';

class AartiScreen extends StatefulWidget {
  final bool showBackButton;
  final bool autoSelectToday;
  final AartiItem? aartiItem;

  const AartiScreen({
    super.key,
    this.showBackButton = false,
    this.autoSelectToday = false,
    this.aartiItem,
  });

  @override
  State<AartiScreen> createState() => _AartiScreenState();
}

class _AartiScreenState extends State<AartiScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final audio = context.read<AudioProvider>();
      if (widget.aartiItem != null) {
        audio.selectAarti(widget.aartiItem!);
      } else if (widget.autoSelectToday) {
        final settings = context.read<SettingsProvider>();
        audio.loadTodayAarti(preferredGodIds: settings.selectedDeities);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioProvider>();
    final lang = context.watch<SettingsProvider>().language;
    final aarti = audio.currentAartiItem;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        title: AppStrings.get('aartiPlayerTitle', lang: lang),
        showBackButton: widget.showBackButton,
        actions: [
          // Quick Aarti Switcher icon for senior devotees
          IconButton(
            tooltip: 'अन्य आरतियां',
            icon: const Icon(
              Icons.queue_music_rounded,
              color: AppColors.primary,
              size: 28,
            ),
            onPressed: () => _showAartiSelectionSheet(context, audio, lang),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Sacred Deity Card with Today's Aarti Metadata & Image
              _buildDeityCard(context, audio, aarti, lang),
              const SizedBox(height: 18),

              // 2. Large Auto-Scrolling Lyrics Viewer (.txt file contents)
              AartiLyricsScroller(
                lyrics: audio.lyricsText,
                isLoading: audio.isLyricsLoading,
                isPlaying: audio.isPlaying,
                progress: audio.progress,
                fontSize: audio.normalFontSize,
                onIncreaseFont: () => audio.increaseFontSize(),
                onDecreaseFont: () => audio.decreaseFontSize(),
                canIncreaseFont: audio.fontStage < 2,
                canDecreaseFont: audio.fontStage > 0,
              ),
              const SizedBox(height: 18),

              // 3. Audio Progress Bar with Senior-Friendly Touch Area
              _buildProgressBar(context, audio, lang),
              const SizedBox(height: 18),

              // 4. Media Controls (10s Rewind, 82px Play/Pause, 10s Forward, Loop)
              _buildMediaControls(context, audio, lang),
              const SizedBox(height: 18),

              // 5. Calm Bottom Reassurance Note
              _buildPeaceNote(context, lang),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Sacred Deity Card with Image, Dynamic Priority Badge, and Large Title
  Widget _buildDeityCard(
    BuildContext context,
    AudioProvider audio,
    AartiItem aarti,
    String lang,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
        children: [
          // Deity Image with Soft Ambient Vignette & Priority Badge
          ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.asset(
                    aarti.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.primaryFixed,
                      child: const Center(
                        child: Icon(
                          Icons.temple_hindu_rounded,
                          size: 64,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),

                // Gradient Vignette Overlay
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
                        stops: const [0.55, 1.0],
                      ),
                    ),
                  ),
                ),

                // Selection Priority Badge at Bottom
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Selection Reason Badge
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(99),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            aarti.getBadge(lang),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Bhakti Ras Pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          AppStrings.get('bhaktiRasBadge', lang: lang),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Large Aarti Title (Hindi primary / Nepali / English)
          Text(
            aarti.getTitle(lang),
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: AppColors.onSurface,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // Aarti Subtitle
          Text(
            aarti.getSubtitle(lang),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Audio Progress Bar with Senior Touch Area (10px track, large 24px thumb)
  Widget _buildProgressBar(
    BuildContext context,
    AudioProvider audio,
    String lang,
  ) {
    final elapsedStr = DevanagariHelper.formatDuration(audio.currentPosition);
    final totalStr = DevanagariHelper.formatDuration(audio.totalDuration);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22.0),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.12),
          width: 1.5,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          // Slider with thick 9px track and 26px touch thumb
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 9.0,
              activeTrackColor: AppColors.primaryContainer,
              inactiveTrackColor: AppColors.surfaceContainerHighest,
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 13.0,
                elevation: 4.0,
              ),
              overlayColor: AppColors.primaryContainer.withValues(alpha: 0.2),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
            ),
            child: Slider(
              value: audio.progress,
              onChanged: (value) => audio.seekToPercent(value),
            ),
          ),

          // High-contrast Time Indicators in Devanagari
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      elapsedStr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      AppStrings.get('elapsedTime', lang: lang),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      totalStr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      AppStrings.get('totalTime', lang: lang),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Media Controls: 10s Rewind, 82px Glowing Play/Pause, 10s Forward, Repeat Loop
  Widget _buildMediaControls(
    BuildContext context,
    AudioProvider audio,
    String lang,
  ) {
    return Container(
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 10-Second Rewind Button (62x62px)
              IconButton(
                iconSize: 32,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 62,
                  minHeight: 62,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainer,
                  foregroundColor: AppColors.primary,
                  shape: const CircleBorder(),
                  side: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                onPressed: () => audio.seekBackward10(),
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.replay_10_rounded),
                    Text(
                      AppStrings.get('rewind10', lang: lang),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                tooltip: '१० सेकंड पीछे',
              ),

              // Massive Glowing Play/Pause Button (82x82px)
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryContainer.withValues(alpha: 0.45),
                      blurRadius: 28,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.primaryFixed,
                    width: 4.0,
                  ),
                ),
                child: IconButton(
                  iconSize: 46,
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  onPressed: () => audio.togglePlay(),
                  icon: Icon(
                    audio.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                  ),
                  tooltip: audio.isPlaying ? 'विराम दें' : 'प्रारंभ करें',
                ),
              ),

              // 10-Second Forward Button (62x62px)
              IconButton(
                iconSize: 32,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 62,
                  minHeight: 62,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainer,
                  foregroundColor: AppColors.primary,
                  shape: const CircleBorder(),
                  side: BorderSide(
                    color: AppColors.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                onPressed: () => audio.seekForward10(),
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.forward_10_rounded),
                    Text(
                      AppStrings.get('forward10', lang: lang),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                tooltip: '१० सेकंड आगे',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Dedicated Wide Repeat / Loop Button
          ElevatedButton.icon(
            onPressed: () => audio.toggleLoop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: audio.isLooping
                  ? AppColors.primaryContainer
                  : AppColors.surfaceContainerLow,
              foregroundColor:
                  audio.isLooping ? Colors.white : AppColors.primary,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              elevation: audio.isLooping ? 2 : 0,
            ),
            icon: Icon(
              audio.isLooping ? Icons.repeat_one_rounded : Icons.repeat_rounded,
              size: 26,
            ),
            label: Text(
              AppStrings.get('loopAarti', lang: lang),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Calm Bottom Reassurance Note
  Widget _buildPeaceNote(BuildContext context, String lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              AppStrings.get('peaceFooter', lang: lang),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Elderly-friendly bottom sheet to choose another Aarti from the collection
  void _showAartiSelectionSheet(
    BuildContext context,
    AudioProvider audio,
    String lang,
  ) {
    HapticService.buttonPress();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'सभी पवित्र आरतियां',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurface,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 28),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'अपनी रुचि अनुसार किसी भी आरती का चयन करें:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: AajKiAartiService.allAartis.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = AajKiAartiService.allAartis[index];
                      final isSelected = audio.currentAartiItem.id == item.id;

                      return InkWell(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          audio.selectAarti(item);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryFixed.withValues(alpha: 0.5)
                                : AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.outlineVariant.withValues(alpha: 0.4),
                              width: isSelected ? 2.0 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.outline,
                                size: 26,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.getTitle(lang),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.getSubtitle(lang),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

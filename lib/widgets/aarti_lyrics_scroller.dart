// ══════════════════════════════════════════════════════════════════════════════
// AARTI LYRICS SCROLLER — Senior-Friendly Smooth Auto-Scrolling Lyrics Reader
// ══════════════════════════════════════════════════════════════════════════════
//
// Highlights:
// 1. High-contrast large Devanagari text with generous 2.1x line height
// 2. Continuous, calm auto-scrolling synchronized with audio playback
// 3. NO word or line highlighting (avoids distracting timing mismatches)
// 4. Touch-aware: gracefully pauses auto-scroll when senior touches/drags
// 5. Senior-accessible font scaling controls (A- / A+)
// 6. Clean, calm cream background matching Devavani temple aesthetics

import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AartiLyricsScroller extends StatefulWidget {
  final String? lyrics;
  final bool isLoading;
  final bool isPlaying;
  final double progress; // 0.0 to 1.0 from audio player
  final double fontSize;
  final VoidCallback onIncreaseFont;
  final VoidCallback onDecreaseFont;
  final bool canIncreaseFont;
  final bool canDecreaseFont;

  const AartiLyricsScroller({
    super.key,
    required this.lyrics,
    this.isLoading = false,
    required this.isPlaying,
    required this.progress,
    required this.fontSize,
    required this.onIncreaseFont,
    required this.onDecreaseFont,
    this.canIncreaseFont = true,
    this.canDecreaseFont = true,
  });

  @override
  State<AartiLyricsScroller> createState() => _AartiLyricsScrollerState();
}

class _AartiLyricsScrollerState extends State<AartiLyricsScroller> {
  final ScrollController _scrollController = ScrollController();
  bool _userIsDragging = false;
  bool _autoScrollEnabled = true;
  Timer? _resumeAutoScrollTimer;

  @override
  void didUpdateWidget(covariant AartiLyricsScroller oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If audio is playing, auto-scroll is enabled, and user is not manually scrolling
    if (widget.isPlaying && _autoScrollEnabled && !_userIsDragging) {
      _performSmoothScroll();
    }
  }

  void _performSmoothScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    // Calculate desired scroll offset proportional to playback progress
    final targetOffset = (widget.progress * maxScroll).clamp(0.0, maxScroll);
    final currentOffset = _scrollController.offset;

    // Only scroll if there is a meaningful difference
    if ((targetOffset - currentOffset).abs() > 3.0) {
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 900),
        curve: Curves.linear,
      );
    }
  }

  void _onUserTouch() {
    // When elderly user touches to read at their own pace, pause auto-scroll
    _userIsDragging = true;
    _resumeAutoScrollTimer?.cancel();

    // Auto-scroll gently resumes after 6 seconds of inactivity if audio is still playing
    _resumeAutoScrollTimer = Timer(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _userIsDragging = false;
        });
      }
    });
  }

  void _toggleAutoScroll() {
    setState(() {
      _autoScrollEnabled = !_autoScrollEnabled;
      if (_autoScrollEnabled) {
        _userIsDragging = false;
        _performSmoothScroll();
      }
    });
  }

  @override
  void dispose() {
    _resumeAutoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.16),
          width: 1.5,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Header: Sacred Book Icon, Title, & Zoom Controls ───────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 16.0, 18.0, 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 28,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'पवित्र आरती के बोल',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'पवित्र दोहा एवं चौपाई',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Font Zoom Controls (A- / A+)
                Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Font Decrease Button
                      InkWell(
                        onTap: widget.canDecreaseFont ? widget.onDecreaseFont : null,
                        borderRadius: BorderRadius.circular(99),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Text(
                            'अ A-',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: widget.canDecreaseFont
                                  ? AppColors.onSurfaceVariant
                                  : AppColors.outline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                      // Font Increase Button
                      InkWell(
                        onTap: widget.canIncreaseFont ? widget.onIncreaseFont : null,
                        borderRadius: BorderRadius.circular(99),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.canIncreaseFont
                                ? AppColors.primaryContainer
                                : AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            'अ A+',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: widget.canIncreaseFont
                                  ? Colors.white
                                  : AppColors.outline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ─── Subtle Auto-Scroll Status Bar with Senior Toggle ──────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: _toggleAutoScroll,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _autoScrollEnabled
                              ? (_userIsDragging
                                  ? Icons.pause_circle_outline_rounded
                                  : Icons.play_circle_filled_rounded)
                              : Icons.pause_circle_filled_rounded,
                          size: 16,
                          color: _autoScrollEnabled && !_userIsDragging
                              ? const Color(0xFF2E7D32) // Soft Green
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _autoScrollEnabled
                              ? (_userIsDragging
                                  ? 'स्वतः स्क्रॉल रुका (स्पर्श पर)'
                                  : 'धीमा स्वतः स्क्रॉल सक्रिय')
                              : 'स्वतः स्क्रॉल बंद है',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _autoScrollEnabled && !_userIsDragging
                                ? const Color(0xFF2E7D32)
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  widget.isPlaying ? 'आरती प्रवाहमान' : 'आरती रुकी हुई',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.surfaceContainer,
          ),

          // ─── Lyrics Text Body with Touch Listener ───────────────────────
          SizedBox(
            height: 340,
            child: widget.isLoading
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 3.0,
                        ),
                        SizedBox(height: 14),
                        Text(
                          'आरती के पावन बोल लोड हो रहे हैं...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollStartNotification &&
                          notification.dragDetails != null) {
                        _onUserTouch();
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 18.0,
                      ),
                      child: Text(
                        widget.lyrics ?? 'आरती के बोल शीघ्र उपलब्ध होंगे...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: widget.fontSize,
                          height: 2.1, // Generous line height prevents matra collisions
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.35,
                          color: const Color(0xFF2C2420), // High-contrast deep devotional tone
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

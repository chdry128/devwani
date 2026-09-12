import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/settings_provider.dart';
import '../services/haptic_service.dart';
import '../services/notification_service.dart';

/// Elderly-Friendly Settings & Preferences Screen
/// Features generous touch targets (56px+), high-contrast text,
/// 3-language selector, and complete Daily Devotional Reminder system.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Morning preset hours (6:00 AM, 7:00 AM, 8:00 AM)
  static const List<({int hour, int minute, String label})> _morningPresets = [
    (hour: 6, minute: 0, label: '06:00 AM'),
    (hour: 7, minute: 0, label: '07:00 AM'),
    (hour: 8, minute: 0, label: '08:00 AM'),
  ];

  // Evening preset hours (6:00 PM, 7:00 PM, 8:00 PM)
  static const List<({int hour, int minute, String label})> _eveningPresets = [
    (hour: 18, minute: 0, label: '06:00 PM'),
    (hour: 19, minute: 0, label: '07:00 PM'),
    (hour: 20, minute: 0, label: '08:00 PM'),
  ];

  Future<void> _pickCustomTime({
    required BuildContext context,
    required bool isEvening,
    required int initialHour,
    required int initialMinute,
  }) async {
    await HapticService.buttonPress();

    if (!context.mounted) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
      helpText: isEvening ? 'संध्या स्मरण समय चुनें' : 'प्रातः स्मरण समय चुनें',
      cancelText: 'रद्द करें',
      confirmText: 'स्वीकार करें',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.onSurface,
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              hourMinuteTextStyle: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
              dayPeriodTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      final settings = context.read<SettingsProvider>();
      if (isEvening) {
        await settings.setEveningReminder(
          true,
          hour: picked.hour,
          minute: picked.minute,
        );
      } else {
        await settings.setMorningReminder(
          true,
          hour: picked.hour,
          minute: picked.minute,
        );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Text(
              '${isEvening ? 'संध्या' : 'प्रातः'} स्मरण समय ${_formatTime(picked.hour, picked.minute)} पर निर्धारित हुआ। 🙏',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        );
      }
    }
  }

  String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    final displayMinute = minute.toString().padLeft(2, '0');
    final formattedHour = displayHour.toString().padLeft(2, '0');
    return '$formattedHour:$displayMinute $period';
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final lang = settings.language;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildCustomAppBar(context, lang),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Screen Header Banner
              _buildDevotionalHeaderCard(lang),
              const SizedBox(height: 24),

              // ─────────────────────────────────────────────────────────────
              // SECTION 1: भाषा चुनें (Language Preference)
              // ─────────────────────────────────────────────────────────────
              _buildSectionTitle(
                icon: Icons.translate_rounded,
                title: AppStrings.get('chooseLanguage', lang: lang),
                subtitle: 'अपनी सुविधाजनक भाषा चुनें',
              ),
              const SizedBox(height: 14),
              _buildLanguageSelector(context, settings),
              const SizedBox(height: 28),

              // ─────────────────────────────────────────────────────────────
              // SECTION 2: दैनिक स्मरण (Daily Reminders Notification System)
              // ─────────────────────────────────────────────────────────────
              _buildSectionTitle(
                icon: Icons.notifications_active_rounded,
                title: AppStrings.get('dailyRemindersTitle', lang: lang),
                subtitle: 'नियमित आरती, चालीसा और पूजा के लिए पावन स्मरण',
              ),
              const SizedBox(height: 16),

              // Consent Assurance Note
              _buildConsentNotice(lang),
              const SizedBox(height: 16),

              // Card 1: Morning Reminder (सुबह का स्मरण)
              _buildMorningReminderCard(context, settings, lang),
              const SizedBox(height: 20),

              // Card 2: Evening Reminder (शाम का स्मरण)
              _buildEveningReminderCard(context, settings, lang),
              const SizedBox(height: 24),

              // Quick Test Notification Trigger
              _buildTestNotificationCard(context, settings, lang),
              const SizedBox(height: 28),

              // Respectful Footer & Offline Assurance
              _buildDevotionalFooter(lang),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // App Bar
  // ─────────────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildCustomAppBar(BuildContext context, String lang) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(68.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.98),
          border: Border(
            bottom: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.4),
              width: 1.0,
            ),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                IconButton(
                  iconSize: 32,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 52,
                    minHeight: 52,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainerLow,
                    foregroundColor: AppColors.primary,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    HapticService.buttonPress();
                    Navigator.of(context).maybePop();
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: AppStrings.get('back', lang: lang),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.get('settingsScreenTitle', lang: lang),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          height: 1.15,
                        ),
                      ),
                      Text(
                        AppStrings.get('appName', lang: lang),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                // Sacred Om Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'ॐ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Devotional Header Banner
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildDevotionalHeaderCard(String lang) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.18),
          width: 1.5,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryFixed,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'मेरी प्राथमिकताएँ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'सुगम, शांत और आपकी रुचि अनुसार धार्मिक अनुभव',
                  style: TextStyle(
                    fontSize: 15,
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

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 26),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 36.0),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SECTION 1: Language Options (3 Large Easy-to-tap Buttons)
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildLanguageSelector(
    BuildContext context,
    SettingsProvider settings,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
        children: [
          _buildLanguageOptionTile(
            title: 'हिन्दी',
            sub: 'मुख्य भाषा (Devanagari)',
            code: 'hi',
            isSelected: settings.language == 'hi',
            onTap: () async {
              HapticService.buttonPress();
              await settings.setLanguage('hi');
            },
          ),
          const SizedBox(height: 12),
          _buildLanguageOptionTile(
            title: 'नेपाली',
            sub: 'नेपाली भाषा (Nepali)',
            code: 'ne',
            isSelected: settings.language == 'ne',
            onTap: () async {
              HapticService.buttonPress();
              await settings.setLanguage('ne');
            },
          ),
          const SizedBox(height: 12),
          _buildLanguageOptionTile(
            title: 'English',
            sub: 'English Language',
            code: 'en',
            isSelected: settings.language == 'en',
            onTap: () async {
              HapticService.buttonPress();
              await settings.setLanguage('en');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOptionTile({
    required String title,
    required String sub,
    required String code,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer.withValues(alpha: 0.12)
              : AppColors.surfaceContainerLow.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.outlineVariant.withValues(alpha: 0.45),
            width: isSelected ? 2.5 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceContainerHigh,
              ),
              child: Icon(
                isSelected ? Icons.check_rounded : Icons.circle_outlined,
                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                      color: isSelected ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.onSurface
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Text(
                  'चयनित',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

  // ─────────────────────────────────────────────────────────────────────────
  // SECTION 2: Notification UX Consent Notice
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildConsentNotice(String lang) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFD591),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: Color(0xFFD46B08),
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'सम्मानजनक व शांत स्मरण नीति',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF873800),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'स्मरण केवल तभी भेजा जाएगा जब आप इसे चालू करेंगे। कोई भी अवांछित सूचना नहीं भेजी जाती।',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF873800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Card 1: Morning Reminder (सुबह का स्मरण)
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildMorningReminderCard(
    BuildContext context,
    SettingsProvider settings,
    String lang,
  ) {
    final isEnabled = settings.morningReminderEnabled;
    final currentHour = settings.morningHour;
    final currentMinute = settings.morningMinute;

    // Contextual Preview
    final preview = NotificationService.getContextualReminder(
      date: DateTime.now(),
      isEvening: false,
      lang: lang,
    );

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: isEnabled
              ? AppColors.primary.withValues(alpha: 0.35)
              : AppColors.outlineVariant.withValues(alpha: 0.40),
          width: isEnabled ? 2.0 : 1.5,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header + Large Switch
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? AppColors.primaryFixed
                      : AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wb_sunny_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('morningReminder', lang: lang),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      AppStrings.get('morningReminderSub', lang: lang),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Large Elder-Friendly Switch
              Transform.scale(
                scale: 1.25,
                child: Switch(
                  value: isEnabled,
                  activeTrackColor: AppColors.primaryContainer,
                  activeThumbColor: Colors.white,
                  inactiveTrackColor: AppColors.surfaceContainerHigh,
                  onChanged: (val) async {
                    HapticService.buttonPress();
                    final success = await settings.setMorningReminder(val);
                    if (!success && val && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'कृपया डिवाइस सेटिंग्स में नोटिफिकेशन अनुमति दें।',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),

          if (isEnabled) ...[
            const SizedBox(height: 18),
            const Divider(height: 1, color: AppColors.surfaceContainer),
            const SizedBox(height: 16),

            // Time Selector Label + Active Time Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'स्मरण समय चुनें:',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.alarm_on_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatTime(currentHour, currentMinute),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Presets + Custom Button
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final preset in _morningPresets)
                  _buildTimePresetChip(
                    label: preset.label,
                    isSelected: currentHour == preset.hour &&
                        currentMinute == preset.minute,
                    onTap: () async {
                      await HapticService.buttonPress();
                      await settings.setMorningReminder(
                        true,
                        hour: preset.hour,
                        minute: preset.minute,
                      );
                    },
                  ),
                // Custom Time Button
                _buildCustomTimeButton(
                  label: AppStrings.get('customTime', lang: lang),
                  isSelected: !_morningPresets.any((p) =>
                      p.hour == currentHour && p.minute == currentMinute),
                  onTap: () => _pickCustomTime(
                    context: context,
                    isEvening: false,
                    initialHour: currentHour,
                    initialMinute: currentMinute,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Contextual Message Preview Box
            _buildMessagePreviewBox(
              title: preview.title,
              body: preview.body,
              lang: lang,
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Card 2: Evening Reminder (शाम का स्मरण)
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildEveningReminderCard(
    BuildContext context,
    SettingsProvider settings,
    String lang,
  ) {
    final isEnabled = settings.eveningReminderEnabled;
    final currentHour = settings.eveningHour;
    final currentMinute = settings.eveningMinute;

    // Contextual Preview
    final preview = NotificationService.getContextualReminder(
      date: DateTime.now(),
      isEvening: true,
      lang: lang,
    );

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: isEnabled
              ? AppColors.secondary.withValues(alpha: 0.35)
              : AppColors.outlineVariant.withValues(alpha: 0.40),
          width: isEnabled ? 2.0 : 1.5,
        ),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header + Large Switch
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? AppColors.secondaryFixed
                      : AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  color: AppColors.secondary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.get('eveningReminder', lang: lang),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      AppStrings.get('eveningReminderSub', lang: lang),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Large Elder-Friendly Switch
              Transform.scale(
                scale: 1.25,
                child: Switch(
                  value: isEnabled,
                  activeTrackColor: AppColors.secondaryContainer,
                  activeThumbColor: Colors.white,
                  inactiveTrackColor: AppColors.surfaceContainerHigh,
                  onChanged: (val) async {
                    HapticService.buttonPress();
                    final success = await settings.setEveningReminder(val);
                    if (!success && val && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'कृपया डिवाइस सेटिंग्स में नोटिफिकेशन अनुमति दें।',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),

          if (isEnabled) ...[
            const SizedBox(height: 18),
            const Divider(height: 1, color: AppColors.surfaceContainer),
            const SizedBox(height: 16),

            // Time Selector Label + Active Time Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'स्मरण समय चुनें:',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryFixed,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.alarm_on_rounded,
                        size: 18,
                        color: AppColors.secondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatTime(currentHour, currentMinute),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Presets + Custom Button
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final preset in _eveningPresets)
                  _buildTimePresetChip(
                    label: preset.label,
                    isSelected: currentHour == preset.hour &&
                        currentMinute == preset.minute,
                    onTap: () async {
                      await HapticService.buttonPress();
                      await settings.setEveningReminder(
                        true,
                        hour: preset.hour,
                        minute: preset.minute,
                      );
                    },
                  ),
                // Custom Time Button
                _buildCustomTimeButton(
                  label: AppStrings.get('customTime', lang: lang),
                  isSelected: !_eveningPresets.any((p) =>
                      p.hour == currentHour && p.minute == currentMinute),
                  onTap: () => _pickCustomTime(
                    context: context,
                    isEvening: true,
                    initialHour: currentHour,
                    initialMinute: currentMinute,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Contextual Message Preview Box
            _buildMessagePreviewBox(
              title: preview.title,
              body: preview.body,
              lang: lang,
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Widgets: Time Preset & Custom Buttons
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildTimePresetChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.outlineVariant.withValues(alpha: 0.5),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTimeButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.outlineVariant.withValues(alpha: 0.6),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 18,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                color: isSelected ? Colors.white : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Contextual Preview Box
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildMessagePreviewBox({
    required String title,
    required String body,
    required String lang,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.sacredGoldBorder.withValues(alpha: 0.8),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.mark_email_read_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                AppStrings.get('notificationPreviewTitle', lang: lang),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '💡 सूचना पर स्पर्श करने से सीधे आरती स्क्रीन खुलेगी।',
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Quick Test Notification Trigger
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildTestNotificationCard(
    BuildContext context,
    SettingsProvider settings,
    String lang,
  ) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'सूचना परीक्षण (Test Reminder)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'यह देखने के लिए कि आपके फोन पर सूचना कैसी दिखाई देती है, नीचे दिए गए बटन को दबाएं।',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: () async {
              await HapticService.buttonPress();
              await settings.sendTestReminder(isEvening: false);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    content: const Text(
                      '🔔 परीक्षण सूचना भेजी गई। स्क्रीन के ऊपर नोटिफिकेशन बार देखें।',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 1,
            ),
            icon: const Icon(Icons.notifications_active_rounded, size: 24),
            label: Text(
              AppStrings.get('testNotificationBtn', lang: lang),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Devotional Footer
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildDevotionalFooter(String lang) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud_done_rounded, color: Color(0xFF2E7D32), size: 22),
            SizedBox(width: 8),
            Text(
              'सभी सेटिंग्स स्वतः सुरक्षित (Save) हो जाती हैं',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'ॐ शांति शांति शांति • सर्वे भवन्तु सुखिनः',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'देववाणी संस्करण 1.0.0 (ऑफ़लाइन समर्थित)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

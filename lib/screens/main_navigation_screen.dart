import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/audio_provider.dart';
import '../providers/settings_provider.dart';
import '../services/haptic_service.dart';
import 'home_screen.dart';
import 'aarti_screen.dart';
import 'jaap_screen.dart';
import 'more_screen.dart';

/// Global Navigation Controller Key to switch tabs from any screen
class MainNavigationController {
  static final GlobalKey<MainNavigationScreenState> key =
      GlobalKey<MainNavigationScreenState>();
  static MainNavigationScreenState? activeState;

  static void navigateToTab(int index) {
    if (activeState != null) {
      activeState!.setTabIndex(index);
    } else {
      key.currentState?.setTabIndex(index);
    }
  }
}

/// Main Navigation Screen with 4 sacred elderly-friendly bottom navigation tabs
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    MainNavigationController.activeState = this;
    _screens = [
      HomeScreen(
        onOpenAarti: () {
          final settings = context.read<SettingsProvider>();
          context.read<AudioProvider>().loadTodayAarti(
            preferredGodIds: settings.selectedDeities,
          );
          setTabIndex(1);
        },
        onOpenJaap: () => setTabIndex(2),
      ),
      const AartiScreen(autoSelectToday: true),
      const JaapScreen(),
      const MoreScreen(),
    ];
  }

  @override
  void dispose() {
    if (MainNavigationController.activeState == this) {
      MainNavigationController.activeState = null;
    }
    super.dispose();
  }

  void setTabIndex(int index) {
    if (index >= 0 && index < 4 && _currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<SettingsProvider>().language;


    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildDevotionalBottomNavBar(lang),
    );
  }

  Widget _buildDevotionalBottomNavBar(String lang) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.98),
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.35),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C2420).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 76,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.temple_hindu_rounded,
                label: AppStrings.get('navHome', lang: lang),
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.local_fire_department_rounded,
                label: AppStrings.get('navAarti', lang: lang),
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.radio_button_checked_rounded,
                label: AppStrings.get('navJaap', lang: lang),
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.more_horiz_rounded,
                label: AppStrings.get('navMore', lang: lang),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () {
        HapticService.buttonPress();
        setTabIndex(index);
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        height: 64,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryFixed.withValues(alpha: 0.6)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

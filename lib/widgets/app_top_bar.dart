import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/asset_paths.dart';
import '../screens/settings_screen.dart';

/// Sacred Devavani App Top Bar
/// Features 48px+ generous touch targets for elderly fingers
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final VoidCallback? onProfile;
  final List<Widget>? actions;

  const AppTopBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.onBack,
    this.onProfile,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.96),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left: Back button or Om Logo + Brand Name
              Row(
                children: [
                  if (showBackButton) ...[
                    IconButton(
                      iconSize: 32,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainerLow,
                        foregroundColor: AppColors.primary,
                        shape: const CircleBorder(),
                      ),
                      onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'पीछे जाएं',
                    ),
                    const SizedBox(width: 10),
                  ],
                  // Sacred Om Emblem & Brand
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          AssetPaths.omEmblem,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Text(
                              'ॐ',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'देववाणी',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              height: 1.1,
                            ),
                          ),
                          if (title != null)
                            Text(
                              title!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                                height: 1.1,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              // Right: Profile/Account Button or Custom Actions
              if (actions != null && actions!.isNotEmpty)
                Row(mainAxisSize: MainAxisSize.min, children: actions!)
              else
                IconButton(
                  iconSize: 28,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainerHigh,
                    foregroundColor: AppColors.onSurface,
                    shape: const CircleBorder(),
                  ),
                  onPressed: onProfile ??
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                  icon: const Icon(Icons.person_outline),
                  tooltip: 'सेटिंग्स व प्रोफाइल',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

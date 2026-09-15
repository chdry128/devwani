import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'constants/app_colors.dart';

import 'providers/audio_provider.dart';
import 'providers/jaap_provider.dart';
import 'providers/panchang_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/deity_selection_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'services/audio_player_service.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DevavaniBootstrap());
}

class DevavaniBootstrap extends StatefulWidget {
  const DevavaniBootstrap({super.key});

  @override
  State<DevavaniBootstrap> createState() => _DevavaniBootstrapState();
}

class _DevavaniBootstrapState extends State<DevavaniBootstrap> {
  late final Future<StorageService> _storageFuture;
  late final AudioPlayerService _audioPlayerService;
  late final NotificationService _notificationService;
  bool _backgroundInitializationStarted = false;

  @override
  void initState() {
    super.initState();
    _storageFuture = StorageService.init();
    _audioPlayerService = AudioPlayerService();
    _notificationService = NotificationService();
  }

  void _startBackgroundInitialization() {
    if (_backgroundInitializationStarted) return;
    _backgroundInitializationStarted = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_initializeNotifications());
      unawaited(_initializeAds());
    });
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notificationService.init();
    } catch (e) {
      debugPrint('NotificationService initialization skipped: $e');
    }
  }

  Future<void> _initializeAds() async {
    try {
      if (!kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)) {
        await MobileAds.instance.initialize();
      }
    } catch (e) {
      debugPrint('Google Mobile Ads initialization skipped: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StorageService>(
      future: _storageFuture,
      builder: (context, snapshot) {
        final storageService = snapshot.data;
        if (storageService == null) {
          return const DevavaniSplash();
        }

        _startBackgroundInitialization();

        return MultiProvider(
          providers: [
            Provider<StorageService>.value(value: storageService),
            Provider<AudioPlayerService>.value(value: _audioPlayerService),
            Provider<NotificationService>.value(value: _notificationService),
            ChangeNotifierProvider<JaapProvider>(
              create: (_) => JaapProvider(storageService, _audioPlayerService),
            ),
            ChangeNotifierProvider<AudioProvider>(
              create: (_) => AudioProvider(_audioPlayerService, storageService),
            ),
            ChangeNotifierProvider<PanchangProvider>(
              create: (_) =>
                  PanchangProvider(initialLang: storageService.getLanguage()),
            ),
            ChangeNotifierProvider<SettingsProvider>(
              create: (context) {
                final settings = SettingsProvider(
                  storageService,
                  _notificationService,
                );
                settings.onLanguageChanged = (lang) {
                  context.read<PanchangProvider>().setLanguage(lang);
                };
                return settings;
              },
            ),
          ],
          child: const DevavaniApp(),
        );
      },
    );
  }
}

class DevavaniSplash extends StatelessWidget {
  const DevavaniSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFFFF8F4),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFFD96510),
            strokeWidth: 3,
          ),
        ),
      ),
    );
  }
}

/// Root Application Widget
class DevavaniApp extends StatelessWidget {
  const DevavaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'देववाणी',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: AppColors.onPrimaryContainer,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          error: AppColors.error,
          onError: AppColors.onError,
        ),
        fontFamily: 'Noto Sans',
        // Accessible slider & button theme defaults
        sliderTheme: const SliderThemeData(
          trackHeight: 8.0,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 13.0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
      ),
      home: const SplashRouter(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SplashRouter: decides onboarding vs home exactly once; never rebuilds.
// Avoids the GlobalKey conflict caused by DevavaniApp rebuilds re-evaluating home:.
// ─────────────────────────────────────────────────────────────────────────────

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  @override
  void initState() {
    super.initState();
    // Schedule after first frame so BuildContext is fully available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final storage = context.read<StorageService>();
      final route = storage.hasCompletedOnboarding()
          ? MaterialPageRoute<void>(
              builder: (_) => const MainNavigationScreen(),
            )
          : MaterialPageRoute<void>(
              builder: (_) => const DeitySelectionScreen(),
            );
      Navigator.of(context).pushReplacement(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Warm saffron splash while routing decision is made.
    return const Scaffold(
      backgroundColor: Color(0xFFFFF8F4),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFD96510),
          strokeWidth: 3,
        ),
      ),
    );
  }
}

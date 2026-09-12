import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/asset_paths.dart';
import '../providers/settings_provider.dart';
import '../services/storage_service.dart';
import 'main_navigation_screen.dart';

/// Data model for a single deity card.
class _DeityData {
  final String id;
  final String name;
  final String subtitle;
  final String imagePath;

  const _DeityData({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.imagePath,
  });
}

/// Full-screen onboarding screen where the user selects up to 2 deities.
/// Shown only once on first launch.
class DeitySelectionScreen extends StatefulWidget {
  const DeitySelectionScreen({super.key});

  @override
  State<DeitySelectionScreen> createState() => _DeitySelectionScreenState();
}

class _DeitySelectionScreenState extends State<DeitySelectionScreen> {
  static const int _maxSelection = 2;

  static const List<_DeityData> _deities = [
    _DeityData(id: 'hanuman',  name: 'हनुमान जी',    subtitle: 'संकट मोचन',           imagePath: AssetPaths.hanumanJi),
    _DeityData(id: 'ganesha',  name: 'श्री गणेश',     subtitle: 'विघ्नहर्ता',           imagePath: AssetPaths.ganeshaJi),
    _DeityData(id: 'shiva',    name: 'भगवान शिव',    subtitle: 'महादेव',               imagePath: AssetPaths.shivaJi),
    _DeityData(id: 'durga',    name: 'माता दुर्गा',   subtitle: 'शक्ति स्वरूपा',       imagePath: AssetPaths.durgaMaa),
    _DeityData(id: 'krishna',  name: 'श्री कृष्ण',   subtitle: 'मुरलीधर',             imagePath: AssetPaths.krishnaJi),
    _DeityData(id: 'ram',      name: 'भगवान राम',    subtitle: 'मर्यादा पुरुषोत्तम', imagePath: AssetPaths.ramJi),
  ];

  final Set<String> _selected = {};
  bool _loading = false;

  Future<void> _proceed() async {
    if (_loading) return;
    setState(() => _loading = true);

    final deities = _selected.toList();
    final storage = context.read<StorageService>();
    final settings = context.read<SettingsProvider>();

    // Persist to storage first (fast, synchronous read next launch).
    await storage.saveSelectedDeities(deities);
    await storage.setOnboardingComplete();

    if (!mounted) return;
    // Navigate immediately — do NOT call settings.setSelectedDeities() before
    // navigation as it triggers notifyListeners() which rebuilds DevavaniApp
    // and causes a duplicate GlobalKey crash.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      (_) => false,
    );

    // Update provider after the new route is in place (fire-and-forget).
    settings.setSelectedDeities(deities);
  }

  Future<void> _skip() async {
    if (_loading) return;
    setState(() => _loading = true);

    final storage = context.read<StorageService>();
    await storage.setOnboardingComplete();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      (_) => false,
    );
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        if (_selected.length >= _maxSelection) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'आप अधिकतम २ देवताओं को ही चुन सकते हैं।\nकृपया पहले चुने किसी देवता को हटाकर पुनः चुनें।',
                style: TextStyle(fontSize: 15, height: 1.4),
              ),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              duration: const Duration(seconds: 3),
            ),
          );
          return;
        }
        _selected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F4),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    // Brand badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1E8),
                        border: Border.all(color: const Color(0xFFF3DFC7)),
                        borderRadius: BorderRadius.circular(99),
                        boxShadow: [BoxShadow(color: Colors.brown.withValues(alpha: 0.08), blurRadius: 8)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/images/om_emblem.png', width: 22, height: 22, fit: BoxFit.contain),
                          const SizedBox(width: 8),
                          const Text(
                            'देववाणी स्वागतम',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFFA64B0A), letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Headline
                    const Text(
                      'आप किस देवता की उपासना करते हैं?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF241A14), height: 1.3),
                    ),
                    const SizedBox(height: 10),

                    // Subtitle pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3EA),
                        border: Border.all(color: const Color(0xFFF5E2D3)),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 14, color: Color(0xFF6B5A50), fontWeight: FontWeight.w500),
                          children: [
                            TextSpan(text: 'आप '),
                            TextSpan(text: '१ या २ देवताओं', style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFFA64B0A))),
                            TextSpan(text: ' को चुन सकते हैं'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Counter
                    Text(
                      'चयनित देवता: ${_selected.length} / $_maxSelection',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF8C7667)),
                    ),
                    const SizedBox(height: 16),

                    // Deity grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _deities.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        final d = _deities[index];
                        return _DeityCard(
                          data: d,
                          isSelected: _selected.contains(d.id),
                          onTap: () => _toggle(d.id),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    // Helper note
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Color(0xFFD96510)),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'चिंता न करें, आप इसे बाद में सेटिंग्स से बदल सकते हैं',
                            style: TextStyle(fontSize: 12, color: Color(0xFF7C6A5E), fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom action bar
            Container(
              color: const Color(0xFFFFF8F4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: _selected.isNotEmpty ? _proceed : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD96510),
                        disabledBackgroundColor: const Color(0xFFD96510).withValues(alpha: 0.45),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 4,
                        shadowColor: const Color(0xFFD96510).withValues(alpha: 0.4),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 24, height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('आगे बढ़ें', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                                SizedBox(width: 10),
                                Icon(Icons.arrow_forward_rounded, size: 22),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _loading ? null : _skip,
                    child: const Text(
                      'बाद में चुनें (आगे बढ़ें)',
                      style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF8C7667),
                        decoration: TextDecoration.underline, decorationColor: Color(0xFF8C7667),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual deity card
// ─────────────────────────────────────────────────────────────────────────────

class _DeityCard extends StatelessWidget {
  final _DeityData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _DeityCard({required this.data, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF3E8) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? const Color(0xFFD96510) : const Color(0xFFEAD5C5),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected ? const Color(0xFFD96510).withValues(alpha: 0.18) : Colors.brown.withValues(alpha: 0.07),
            blurRadius: isSelected ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8EDE3),
                            border: Border.all(color: const Color(0xFFE9CCA8), width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.asset(
                            data.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => const Center(
                              child: Icon(Icons.brightness_5_rounded, size: 48, color: Color(0xFFD96510)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700,
                        color: isSelected ? const Color(0xFFA64B0A) : const Color(0xFF2E231C),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(data.subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF7A6150), fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? const Color(0xFFD96510) : Colors.white.withValues(alpha: 0.9),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : const Color(0xFFD0BFB2),
                        width: 2,
                      ),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)],
                    ),
                    child: isSelected ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/services.dart';

/// Resolves a deity image from the files bundled in assets/images/.
///
/// The exact filename is intentionally not part of the selection logic. A new
/// image named after the deity, such as `krishna.png` or `krishna_ji.jpg`, is
/// picked up automatically after the asset bundle is rebuilt.
class GodImageService {
  GodImageService._();

  static final Map<String, Future<String>> _cache = {};

  static Future<String> resolve(
    String godId, {
    String? fallbackPath,
    AssetBundle? bundle,
  }) {
    final cacheKey = '$godId|${fallbackPath ?? ''}';
    return _cache[cacheKey] ??= _resolve(
      godId,
      fallbackPath: fallbackPath,
      bundle: bundle ?? rootBundle,
    );
  }

  static Future<String> _resolve(
    String godId, {
    required String? fallbackPath,
    required AssetBundle bundle,
  }) async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(bundle);
      final imageAssets = manifest
          .listAssets()
          .where((path) => path.startsWith('assets/images/'))
          .where((path) => _isImageFile(path))
          .toList();

      if (fallbackPath != null && imageAssets.contains(fallbackPath)) {
        return fallbackPath;
      }

      final aliases = _aliases[godId] ?? <String>[godId];
      for (final alias in aliases) {
        final normalizedAlias = _normalize(alias);
        for (final path in imageAssets) {
          final filename = path.split('/').last;
          final stem = filename.substring(0, filename.lastIndexOf('.'));
          if (_normalize(stem) == normalizedAlias) return path;
        }
      }
    } catch (_) {
      // Keep the supplied canonical path usable on older/custom asset bundles.
    }

    return fallbackPath ?? 'assets/images/temple_diya.png';
  }

  static bool _isImageFile(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp');
  }

  static String _normalize(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  static const Map<String, List<String>> _aliases = {
    'hanuman': ['hanuman', 'hanuman_ji'],
    'shiva': ['shiva', 'shiva_ji'],
    'ganesha': ['ganesha', 'ganesh', 'ganesha_ji', 'ganesh_ji'],
    'durga': ['durga', 'durga_ji', 'durga_maa'],
    'krishna': ['krishna', 'krishna_ji'],
    'ram': ['ram', 'ram_ji'],
  };
}

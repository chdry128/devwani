/// ══════════════════════════════════════════════════════════════════════════════
/// CANONICAL ASSET PATHS — Single source of truth for all asset references
/// ══════════════════════════════════════════════════════════════════════════════
///
/// Every image and audio file in the app is referenced through this class.
/// When adding a new God or Aarti, add the corresponding asset path here.
///
/// NOTE: Make sure each asset file exists in the respective assets/ folder
/// and is listed in pubspec.yaml under flutter > assets.
class AssetPaths {
  AssetPaths._();

  // ─────────────────────────────────────────────────────────────────────────
  // God Images (assets/images/)
  // ─────────────────────────────────────────────────────────────────────────

  static const String hanumanJi = 'assets/images/hanuman_ji.png';
  static const String shivaJi = 'assets/images/shiva_ji.png';
  static const String ganeshaJi = 'assets/images/ganesha_ji.png';
  static const String durgaMaa = 'assets/images/durga_maa.png';
  static const String krishnaJi = 'assets/images/krishna_ji.png';
  static const String ramJi = 'assets/images/ram_ji.png';

  // ─────────────────────────────────────────────────────────────────────────
  // Decorative / UI Images
  // ─────────────────────────────────────────────────────────────────────────

  static const String omEmblem = 'assets/images/om_emblem.png';
  static const String templeDiya = 'assets/images/temple_diya.png';

  // ─────────────────────────────────────────────────────────────────────────
  // Audio Files (assets/audio/)
  // ─────────────────────────────────────────────────────────────────────────

  /// Temple bell chime for Jaap counter feedback
  static const String templeBellAudio = 'assets/audio/temple_bell.wav';

  /// Aarti audio files — one per Aarti
  static const String hanumanChalisaAudio = 'assets/audio/hanuman_chalisa.mp3';
  static const String shivAartiAudio = 'assets/audio/shiv_aarti.mp3';
  static const String ganeshAartiAudio = 'assets/audio/ganesh_aarti.mp3';
  static const String durgaAartiAudio = 'assets/audio/durga_aarti.mp3';
  static const String krishnaAartiAudio = 'assets/audio/krishna_aarti.mp3';
  static const String ramAartiAudio = 'assets/audio/ram_aarti.mp3';
}

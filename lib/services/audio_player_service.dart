import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../constants/asset_paths.dart';

/// Comprehensive Audio Service for Devavani
/// Handles:
/// 1. Tactile sacred temple bell chime for Jaap counter taps (instant low-latency playback)
/// 2. Aarti / Chalisa recitations with seek, looping, duration tracking, and offline asset caching
class AudioPlayerService {
  final AudioPlayer? _bellPlayer;
  final AudioPlayer? _aartiPlayer;
  final bool _enablePlatformAudio;

  bool _isBellReady = false;
  bool _isLooping = false;

  AudioPlayerService({bool enablePlatformAudio = true})
      : _enablePlatformAudio = enablePlatformAudio,
        _bellPlayer = enablePlatformAudio ? AudioPlayer() : null,
        _aartiPlayer = enablePlatformAudio ? AudioPlayer() : null {
    if (_enablePlatformAudio) {
      _initBell();
    }
  }

  Future<void> _initBell() async {
    try {
      await _bellPlayer?.setAsset(AssetPaths.templeBellAudio);
      await _bellPlayer?.setVolume(0.85);
      _isBellReady = true;
    } catch (e) {
      debugPrint('AudioPlayerService: could not preload bell: $e');
    }
  }

  /// Plays the soothing sacred temple bell tone on each bead tap
  Future<void> playTempleBell() async {
    if (!_enablePlatformAudio) return;
    try {
      if (_isBellReady) {
        await _bellPlayer?.seek(Duration.zero);
        await _bellPlayer?.play();
      } else {
        await _bellPlayer?.setAsset(AssetPaths.templeBellAudio);
        _isBellReady = true;
        await _bellPlayer?.play();
      }
    } catch (e) {
      debugPrint('Error playing temple bell: $e');
    }
  }

  // --- Aarti Player Control ---

  Stream<PlayerState> get aartiPlayerStateStream =>
      _aartiPlayer?.playerStateStream ?? const Stream.empty();
  Stream<Duration> get aartiPositionStream =>
      _aartiPlayer?.positionStream ?? const Stream.empty();
  Stream<Duration?> get aartiDurationStream =>
      _aartiPlayer?.durationStream ?? const Stream.empty();

  Duration get currentPosition => _aartiPlayer?.position ?? Duration.zero;
  Duration? get totalDuration => _aartiPlayer?.duration;
  bool get isPlaying => _aartiPlayer?.playing ?? false;
  bool get isLooping => _isLooping;

  Future<void> loadAarti({String? assetPath, String? url}) async {
    if (!_enablePlatformAudio) return;
    try {
      if (assetPath != null) {
        await _aartiPlayer?.setAsset(assetPath);
      } else if (url != null) {
        await _aartiPlayer?.setUrl(url);
      }
    } catch (e) {
      debugPrint('AudioPlayerService: loadAarti error: $e');
    }
  }

  Future<void> playAarti() async {
    if (!_enablePlatformAudio) return;
    try {
      await _aartiPlayer?.play();
    } catch (e) {
      debugPrint('AudioPlayerService: play error: $e');
    }
  }

  Future<void> pauseAarti() async {
    if (!_enablePlatformAudio) return;
    try {
      await _aartiPlayer?.pause();
    } catch (e) {
      debugPrint('AudioPlayerService: pause error: $e');
    }
  }

  Future<void> stopAarti() async {
    if (!_enablePlatformAudio) return;
    try {
      await _aartiPlayer?.stop();
      await _aartiPlayer?.seek(Duration.zero);
    } catch (e) {
      debugPrint('AudioPlayerService: stop error: $e');
    }
  }

  Future<void> seekTo(Duration position) async {
    if (!_enablePlatformAudio) return;
    try {
      await _aartiPlayer?.seek(position);
    } catch (e) {
      debugPrint('AudioPlayerService: seek error: $e');
    }
  }

  Future<void> seekForward([Duration delta = const Duration(seconds: 10)]) async {
    if (!_enablePlatformAudio) return;
    final newPos = (_aartiPlayer?.position ?? Duration.zero) + delta;
    final total = _aartiPlayer?.duration ?? const Duration(minutes: 4, seconds: 30);
    if (newPos < total) {
      await seekTo(newPos);
    } else {
      await seekTo(total);
    }
  }

  Future<void> seekBackward([Duration delta = const Duration(seconds: 10)]) async {
    if (!_enablePlatformAudio) return;
    final newPos = (_aartiPlayer?.position ?? Duration.zero) - delta;
    if (newPos > Duration.zero) {
      await seekTo(newPos);
    } else {
      await seekTo(Duration.zero);
    }
  }

  Future<void> toggleLoop() async {
    _isLooping = !_isLooping;
    if (!_enablePlatformAudio) return;
    try {
      await _aartiPlayer?.setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
    } catch (e) {
      debugPrint('AudioPlayerService: setLoopMode error: $e');
    }
  }

  void dispose() {
    _bellPlayer?.dispose();
    _aartiPlayer?.dispose();
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/aarti.dart';
import '../models/aarti_item.dart';
import '../services/aaj_ki_aarti_service.dart';
import '../services/audio_player_service.dart';
import '../services/haptic_service.dart';
import '../services/storage_service.dart';

/// Manages reactive state for Aarti Player, Lyrics Synchronizer, and Font Scaling
class AudioProvider extends ChangeNotifier {
  final AudioPlayerService _audioPlayerService;
  final StorageService _storageService;

  AartiItem _currentAartiItem = AajKiAartiService.hanumanChalisa;
  Aarti _currentAarti = Aarti.defaultHanumanChalisa;
  String? _lyricsText;
  bool _isLyricsLoading = false;

  // Correct initial state: nothing is playing or loaded yet
  bool _isPlaying = false;
  bool _isLooping = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(minutes: 4, seconds: 30);
  int _fontStage = 1; // 0: Normal, 1: Large (+25%), 2: Extra Large (+40%)

  StreamSubscription? _posSub;
  StreamSubscription? _durSub;
  StreamSubscription? _stateSub;

  AudioProvider(this._audioPlayerService, this._storageService) {
    _init();
  }

  Aarti get currentAarti => _currentAarti;
  AartiItem get currentAartiItem => _currentAartiItem;
  String? get lyricsText => _lyricsText;
  bool get isLyricsLoading => _isLyricsLoading;
  bool get isPlaying => _isPlaying;
  bool get isLooping => _isLooping;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  int get fontStage => _fontStage;

  double get progress {
    if (_totalDuration.inMilliseconds == 0) return 0.0;
    return (_currentPosition.inMilliseconds / _totalDuration.inMilliseconds)
        .clamp(0.0, 1.0);
  }

  /// Calculates font size based on stage
  double get normalFontSize {
    switch (_fontStage) {
      case 0:
        return 20.0;
      case 2:
        return 27.0;
      case 1:
      default:
        return 23.0;
    }
  }

  double get activeFontSize {
    switch (_fontStage) {
      case 0:
        return 22.0;
      case 2:
        return 30.0;
      case 1:
      default:
        return 26.0;
    }
  }

  /// Active verse index based on playback progress
  int get activeVerseIndex {
    final verses = _currentAarti.verses;
    if (verses.isEmpty) return 0;
    for (int i = verses.length - 1; i >= 0; i--) {
      if (_currentPosition >= verses[i].startTime) {
        return i;
      }
    }
    return 0;
  }

  void _init() {
    _fontStage = _storageService.getFontStage();

    // Subscribe to real-time position from just_audio (no redundant timer needed)
    _posSub = _audioPlayerService.aartiPositionStream.listen((pos) {
      _currentPosition = pos;
      notifyListeners();
    });

    _durSub = _audioPlayerService.aartiDurationStream.listen((dur) {
      if (dur != null) {
        _totalDuration = dur;
        notifyListeners();
      }
    });

    _stateSub = _audioPlayerService.aartiPlayerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    // Load initial lyrics
    loadLyricsForCurrent();
  }

  /// Loads today's Aarti using the priority logic and prepares playback
  Future<void> loadTodayAarti({
    List<String> preferredGodIds = const [],
    DateTime? date,
  }) async {
    final selected = AajKiAartiService.selectTodaysAarti(
      preferredGodIds: preferredGodIds,
      date: date,
    );
    await selectAarti(selected);
  }

  /// Selects and loads a specific Aarti item
  Future<void> selectAarti(AartiItem item) async {
    _currentAartiItem = item;
    _currentAarti = Aarti.fromNew(item.toAartiModel());
    _totalDuration = item.duration;
    _currentPosition = Duration.zero;
    _isPlaying = false;
    notifyListeners();

    await loadLyricsForCurrent();
    await _audioPlayerService.loadAarti(assetPath: item.audioPath);
  }

  /// Loads the matching .txt lyrics file from assets
  Future<void> loadLyricsForCurrent() async {
    if (_isLyricsLoading) return;
    _isLyricsLoading = true;
    notifyListeners();

    try {
      final text = await AajKiAartiService.loadLyrics(_currentAartiItem.lyricsPath);
      _lyricsText = text;
      _currentAartiItem = _currentAartiItem.copyWith(rawLyrics: text);
    } catch (e) {
      debugPrint('AudioProvider: Error loading lyrics: $e');
    } finally {
      _isLyricsLoading = false;
      notifyListeners();
    }
  }

  Future<void> togglePlay() async {
    _isPlaying = !_isPlaying;
    await HapticService.buttonPress();
    if (_isPlaying) {
      await _audioPlayerService.playAarti();
    } else {
      await _audioPlayerService.pauseAarti();
    }
    notifyListeners();
  }

  Future<void> toggleLoop() async {
    _isLooping = !_isLooping;
    await HapticService.buttonPress();
    await _audioPlayerService.toggleLoop();
    notifyListeners();
  }

  Future<void> seekForward10() async {
    await HapticService.buttonPress();
    final newPos = _currentPosition + const Duration(seconds: 10);
    if (newPos < _totalDuration) {
      _currentPosition = newPos;
    } else {
      _currentPosition = _totalDuration;
    }
    await _audioPlayerService.seekTo(_currentPosition);
    notifyListeners();
  }

  Future<void> seekBackward10() async {
    await HapticService.buttonPress();
    final newPos = _currentPosition - const Duration(seconds: 10);
    if (newPos > Duration.zero) {
      _currentPosition = newPos;
    } else {
      _currentPosition = Duration.zero;
    }
    await _audioPlayerService.seekTo(_currentPosition);
    notifyListeners();
  }

  Future<void> seekToPercent(double percent) async {
    final newSecs = (_totalDuration.inSeconds * percent).toInt();
    _currentPosition = Duration(seconds: newSecs);
    await _audioPlayerService.seekTo(_currentPosition);
    notifyListeners();
  }

  Future<void> increaseFontSize() async {
    if (_fontStage < 2) {
      _fontStage++;
      await _storageService.saveFontStage(_fontStage);
      await HapticService.buttonPress();
      notifyListeners();
    }
  }

  Future<void> decreaseFontSize() async {
    if (_fontStage > 0) {
      _fontStage--;
      await _storageService.saveFontStage(_fontStage);
      await HapticService.buttonPress();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    _stateSub?.cancel();
    super.dispose();
  }
}

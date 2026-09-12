import 'package:flutter/foundation.dart';
import '../models/mantra.dart';
import '../services/storage_service.dart';
import '../services/haptic_service.dart';
import '../services/audio_player_service.dart';

/// Manages reactive state for the elderly-friendly Jaap Counter
class JaapProvider extends ChangeNotifier {
  final StorageService _storageService;
  final AudioPlayerService _audioPlayerService;

  late int _count;
  late int _dailyTotal;
  late int _malasCompleted;
  late bool _vibrationEnabled;
  late bool _soundEnabled;
  late Mantra _selectedMantra;

  JaapProvider(this._storageService, this._audioPlayerService) {
    _loadState();
  }

  int get count => _count;
  int get dailyTotal => _dailyTotal;
  int get malasCompleted => _malasCompleted;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get soundEnabled => _soundEnabled;
  Mantra get selectedMantra => _selectedMantra;

  double get progress => (_count / (_selectedMantra.targetCount > 0 ? _selectedMantra.targetCount : 108)).clamp(0.0, 1.0);

  void _loadState() {
    _count = _storageService.getJaapCount();
    _dailyTotal = _storageService.getDailyTotal();
    _malasCompleted = _storageService.getMalasCompleted();
    _vibrationEnabled = _storageService.getVibrationEnabled();
    _soundEnabled = _storageService.getSoundEnabled();

    final savedMantraId = _storageService.getSelectedMantraId();
    _selectedMantra = Mantra.defaultMantras.firstWhere(
      (m) => m.id == savedMantraId,
      orElse: () => Mantra.defaultMantras.first,
    );
  }

  /// Increments bead on full-screen tap
  Future<void> incrementBead() async {
    _count += 1;
    _dailyTotal += 1;

    final target = _selectedMantra.targetCount;
    final isCompleted = _count >= target;
    if (isCompleted) {
      _count = 0;
      _malasCompleted += 1;
    }

    // Notify UI immediately for responsive tactile feedback
    notifyListeners();

    if (isCompleted) {
      if (_vibrationEnabled) {
        await HapticService.malaCompletedFeedback();
      }
    } else {
      if (_vibrationEnabled) {
        await HapticService.beadFeedback();
      }
    }

    if (_soundEnabled) {
      await _audioPlayerService.playTempleBell();
    }

    // Persist immediately in background
    await _storageService.saveJaapCount(_count);
    await _storageService.saveDailyTotal(_dailyTotal);
    await _storageService.saveMalasCompleted(_malasCompleted);
  }

  /// Protected reset of current mala bead count (with confirmation in UI)
  Future<void> resetCount() async {
    _count = 0;
    await _storageService.saveJaapCount(_count);
    notifyListeners();
  }

  /// Toggle tactile haptic vibration
  Future<void> toggleVibration() async {
    _vibrationEnabled = !_vibrationEnabled;
    await _storageService.saveVibrationEnabled(_vibrationEnabled);
    if (_vibrationEnabled) {
      await HapticService.buttonPress();
    }
    notifyListeners();
  }

  /// Toggle sacred bell chime sound
  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    await _storageService.saveSoundEnabled(_soundEnabled);
    if (_soundEnabled) {
      await _audioPlayerService.playTempleBell();
    }
    notifyListeners();
  }

  /// Switch the active sacred mantra
  Future<void> selectMantra(Mantra mantra) async {
    _selectedMantra = mantra;
    await _storageService.saveSelectedMantraId(mantra.id);
    notifyListeners();
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// JAAP MODEL — Japa session state
// ══════════════════════════════════════════════════════════════════════════════
//
// Captures the current state of a Jaap (chanting) session.
// This is a data class — the actual mutation logic lives in [JaapProvider].

/// Represents the current Jaap session state.
///
/// Separated from [MantraModel] because the mantra is a *definition*
/// while this is a *runtime state* that changes with every tap.
class JaapSession {
  /// ID of the currently selected mantra (links to MantraModel.id)
  final String selectedMantraId;

  /// Current bead count within the current mala (0 to target-1)
  final int currentCount;

  /// Total chants done today (resets daily)
  final int todayTotal;

  /// Number of full malas (108) completed all-time
  final int malasCompleted;

  /// Target count per mala (usually 108)
  final int target;

  const JaapSession({
    required this.selectedMantraId,
    this.currentCount = 0,
    this.todayTotal = 0,
    this.malasCompleted = 0,
    this.target = 108,
  });

  /// Convenience getters matching requested JaapModel field names
  int get count => currentCount;
  String get selectedMantra => selectedMantraId;

  /// Progress fraction for the circular dial (0.0 to 1.0)
  double get progress => target > 0 ? currentCount / target : 0.0;

  /// Whether the current mala is complete
  bool get isMalaComplete => currentCount >= target;

  /// Creates a copy with updated fields
  JaapSession copyWith({
    String? selectedMantraId,
    int? currentCount,
    int? todayTotal,
    int? malasCompleted,
    int? target,
  }) {
    return JaapSession(
      selectedMantraId: selectedMantraId ?? this.selectedMantraId,
      currentCount: currentCount ?? this.currentCount,
      todayTotal: todayTotal ?? this.todayTotal,
      malasCompleted: malasCompleted ?? this.malasCompleted,
      target: target ?? this.target,
    );
  }

  @override
  String toString() =>
      'JaapSession(mantra=$selectedMantraId, count=$currentCount/$target, today=$todayTotal, malas=$malasCompleted)';
}

/// Alias for JaapSession matching naming convention
typedef JaapModel = JaapSession;


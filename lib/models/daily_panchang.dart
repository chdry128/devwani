// ══════════════════════════════════════════════════════════════════════════════
// DAILY PANCHANG MODEL — Clean, Senior-Friendly Hindu Almanac Data
// ══════════════════════════════════════════════════════════════════════════════

/// Represents one day's Panchang data tailored for senior users.
///
/// Contains the 4 essential sections:
/// 1. [tithi] — Today's localized Tithi name
/// 2. [sunrise] & [sunset] — Localized sunrise and sunset times (e.g. "05:46 AM")
/// 3. [doList] — Top 3 recommended positive spiritual actions
/// 4. [avoidList] — Top 3 precautions / things to avoid
class DailyPanchang {
  /// Localized Tithi string (e.g. 'शुक्ल पक्ष एकादशी', 'पूर्णिमा')
  final String tithi;

  /// Formatted sunrise time (e.g. '05:46 AM')
  final String sunrise;

  /// Formatted sunset time (e.g. '06:15 PM')
  final String sunset;

  /// Maximum 3 recommended positive actions for today
  final List<String> doList;

  /// Maximum 3 precautions / things to avoid today
  final List<String> avoidList;

  /// Date this panchang applies to
  final DateTime date;

  /// Special day or rule badge (e.g. 'एकादशी (अति शुभ पावन व्रत)')
  final String specialDay;

  /// Location used for calculations (e.g. 'Kathmandu', 'Delhi')
  final String location;

  const DailyPanchang({
    required this.tithi,
    required this.sunrise,
    required this.sunset,
    required this.doList,
    required this.avoidList,
    DateTime? date,
    this.specialDay = '',
    this.location = 'Kathmandu',
  }) : date = date ?? const _DefaultDate();

  /// Aliases for compatibility with existing cards and widgets
  List<String> get dos => doList;
  List<String> get donts => avoidList;

  /// Default sample Panchang for offline fallback or instant UI preview
  static final DailyPanchang sampleToday = DailyPanchang(
    date: DateTime.now(),
    tithi: 'शुक्ल पक्ष एकादशी',
    specialDay: 'अमलकी एकादशी (अति शुभ दिन)',
    sunrise: '06:28 AM',
    sunset: '06:34 PM',
    doList: const [
      'भगवान विष्णु और पीपल वृक्ष को जल अर्पित करें',
      'तुलसी जी के पास शुद्ध घी का दीपक जलाएं',
      'सात्विक फलाहार लें और दान-पुण्य करें',
    ],
    avoidList: const [
      'चावल और भारी भोजन का सेवन न करें',
      'तामसिक भोजन और क्रोध से बचें',
      'किसी का अनादर या कटु वचन न बोलें',
    ],
    location: 'Kathmandu',
  );

  @override
  String toString() =>
      'DailyPanchang(tithi: $tithi, sunrise: $sunrise, sunset: $sunset, dos: ${doList.length}, donts: ${avoidList.length})';
}

/// Fallback constant date helper for const constructor
class _DefaultDate implements DateTime {
  const _DefaultDate();

  @override
  DateTime add(Duration duration) => DateTime.now().add(duration);
  @override
  DateTime subtract(Duration duration) => DateTime.now().subtract(duration);
  @override
  int compareTo(DateTime other) => DateTime.now().compareTo(other);
  @override
  Duration difference(DateTime other) => DateTime.now().difference(other);
  @override
  bool isAfter(DateTime other) => DateTime.now().isAfter(other);
  @override
  bool isBefore(DateTime other) => DateTime.now().isBefore(other);
  @override
  bool isAtSameMomentAs(DateTime other) => DateTime.now().isAtSameMomentAs(other);
  @override
  int get year => DateTime.now().year;
  @override
  int get month => DateTime.now().month;
  @override
  int get day => DateTime.now().day;
  @override
  int get hour => DateTime.now().hour;
  @override
  int get minute => DateTime.now().minute;
  @override
  int get second => DateTime.now().second;
  @override
  int get millisecond => DateTime.now().millisecond;
  @override
  int get microsecond => DateTime.now().microsecond;
  @override
  int get weekday => DateTime.now().weekday;
  @override
  bool get isUtc => false;
  @override
  DateTime toLocal() => DateTime.now();
  @override
  DateTime toUtc() => DateTime.now().toUtc();
  @override
  String get timeZoneName => DateTime.now().timeZoneName;
  @override
  Duration get timeZoneOffset => DateTime.now().timeZoneOffset;
  @override
  String toIso8601String() => DateTime.now().toIso8601String();
  @override
  int get millisecondsSinceEpoch => DateTime.now().millisecondsSinceEpoch;
  @override
  int get microsecondsSinceEpoch => DateTime.now().microsecondsSinceEpoch;
}

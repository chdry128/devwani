/// Helper utility to convert numbers and digit strings to sacred Devanagari numerals.
class DevanagariHelper {
  DevanagariHelper._();

  static const List<String> devanagariDigits = [
    '०', '१', '२', '३', '४', '५', '६', '७', '८', '९'
  ];

  /// Converts an integer or numeric string into Devanagari numerals.
  /// Example: 108 -> "१०८"
  static String format(dynamic value) {
    if (value == null) return '०';
    final str = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final codeUnit = str.codeUnitAt(i);
      // '0' is 48, '9' is 57
      if (codeUnit >= 48 && codeUnit <= 57) {
        buffer.write(devanagariDigits[codeUnit - 48]);
      } else {
        buffer.write(str[i]);
      }
    }
    return buffer.toString();
  }

  /// Formats duration (seconds) into MM:SS in Devanagari or standard digits
  static String formatDuration(Duration duration, {bool toDevanagari = false}) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final timeStr = '$minutes:$seconds';
    return toDevanagari ? format(timeStr) : timeStr;
  }
}

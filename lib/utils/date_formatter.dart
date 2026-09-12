import 'devanagari_helper.dart';

/// Formats calendar dates in sacred Hindi/Nepali devotional style.
class DateFormatter {
  DateFormatter._();

  static const List<String> _hindiWeekdays = [
    'सोमवार', // Monday = 1
    'मंगलवार',
    'बुधवार',
    'गुरुवार',
    'शुक्रवार',
    'शनिवार',
    'रविवार', // Sunday = 7
  ];

  static const List<String> _hindiMonths = [
    'जनवरी',
    'फ़रवरी',
    'मार्च',
    'अप्रैल',
    'मई',
    'जून',
    'जुलाई',
    'अगस्त',
    'सितम्बर',
    'अक्टूबर',
    'नवम्बर',
    'दिसम्बर',
  ];

  static const List<String> _nepaliWeekdays = [
    'सोमबार',
    'मंगलबार',
    'बुधबार',
    'बिहीबार',
    'शुक्रबार',
    'शनिबार',
    'आइतबार',
  ];

  /// Returns localized formatted date, e.g.:
  /// "बुधवार, २० मार्च २०२४"
  static String formatFullDate(DateTime date, {String lang = 'hi'}) {
    final weekdayIndex = date.weekday - 1;
    final monthIndex = date.month - 1;

    final weekday = lang == 'ne'
        ? _nepaliWeekdays[weekdayIndex]
        : _hindiWeekdays[weekdayIndex];
    final month = _hindiMonths[monthIndex];
    final dayStr = DevanagariHelper.format(date.day);
    final yearStr = DevanagariHelper.format(date.year);

    if (lang == 'en') {
      const enDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      const enMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      return '${enDays[weekdayIndex]}, ${date.day} ${enMonths[monthIndex]} ${date.year}';
    }

    return '$weekday, $dayStr $month $yearStr';
  }
}

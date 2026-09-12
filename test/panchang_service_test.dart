import 'package:flutter_test/flutter_test.dart';
import 'package:devavani/services/panchang_service.dart';
import 'package:devavani/constants/panchang_rules.dart';

void main() {
  group('PanchangService & tithi_engine Tests', () {
    test('Calculates panchang with Kathmandu as default location', () {
      final panchang = PanchangService.getPanchang(
        date: DateTime(2026, 9, 9),
        lang: 'hi',
      );

      expect(panchang.location, 'Kathmandu');
      expect(panchang.tithi, isNotEmpty);
      expect(panchang.sunrise, matches(RegExp(r'^\d{2}:\d{2}\s+(AM|PM)$')));
      expect(panchang.sunset, matches(RegExp(r'^\d{2}:\d{2}\s+(AM|PM)$')));
      expect(panchang.doList.length, inInclusiveRange(1, 3));
      expect(panchang.avoidList.length, inInclusiveRange(1, 3));
      expect(panchang.dos, equals(panchang.doList));
      expect(panchang.donts, equals(panchang.avoidList));
    });

    test('Calculates panchang with Delhi location', () {
      final panchang = PanchangService.getPanchang(
        date: DateTime(2026, 9, 9),
        city: 'Delhi',
        lang: 'hi',
      );

      expect(panchang.location, 'Delhi');
      expect(panchang.sunrise, isNotEmpty);
      expect(panchang.sunset, isNotEmpty);
    });

    test('Supports all 3 languages (Hindi, Nepali, English)', () {
      final date = DateTime(2026, 9, 9);

      final hi = PanchangService.getPanchang(date: date, lang: 'hi');
      final ne = PanchangService.getPanchang(date: date, lang: 'ne');
      final en = PanchangService.getPanchang(date: date, lang: 'en');

      expect(hi.tithi, isNotEmpty);
      expect(ne.tithi, isNotEmpty);
      expect(en.tithi, isNotEmpty);

      // Verify that English gives Latin characters
      expect(en.tithi, matches(RegExp(r'[A-Za-z]+')));

      // Verify doList in each language has items
      expect(hi.doList.first, isNotEmpty);
      expect(ne.doList.first, isNotEmpty);
      expect(en.doList.first, isNotEmpty);
    });

    test('Gracefully handles calculation errors with fallback', () {
      // Pass an extreme out-of-range date or unsupported city
      final fallback = PanchangService.getPanchang(
        date: DateTime(3000, 1, 1),
        city: 'NonExistentCity12345',
        lang: 'hi',
      );

      expect(fallback.tithi, isNotEmpty);
      expect(fallback.sunrise, isNotEmpty);
      expect(fallback.sunset, isNotEmpty);
      expect(fallback.doList.isNotEmpty, true);
      expect(fallback.avoidList.isNotEmpty, true);
    });
  });

  group('PanchangRules Tests', () {
    test('Ekadashi rules take precedence and contain fasting advice', () {
      final rulesHi = PanchangRules.evaluate(
        rawTithiName: 'Ekadashi',
        tithiNumber: 11,
        weekday: DateTime.tuesday, // Even on Tuesday, Ekadashi takes precedence
        lang: 'hi',
      );

      expect(rulesHi.specialDay, contains('एकादशी'));
      expect(rulesHi.doList.length, 3);
      expect(rulesHi.avoidList.length, 3);
      // Verify avoidList contains rice prohibition
      expect(rulesHi.avoidList.any((point) => point.contains('चावल')), true);

      final rulesEn = PanchangRules.evaluate(
        rawTithiName: 'Ekadashi',
        tithiNumber: 11,
        weekday: DateTime.tuesday,
        lang: 'en',
      );
      expect(rulesEn.avoidList.any((point) => point.toLowerCase().contains('rice')), true);
    });

    test('Purnima rules provide full moon and Satyanarayan guidance', () {
      final rules = PanchangRules.evaluate(
        rawTithiName: 'Purnima',
        tithiNumber: 15,
        weekday: DateTime.friday,
        lang: 'hi',
      );

      expect(rules.specialDay, contains('पूर्णिमा'));
      expect(rules.doList.length, 3);
      expect(rules.avoidList.length, 3);
      expect(rules.doList.any((point) => point.contains('सत्यनारायण')), true);
    });

    test('Amavasya rules provide ancestor remembrance guidance', () {
      final rules = PanchangRules.evaluate(
        rawTithiName: 'Amavasya',
        tithiNumber: 30,
        weekday: DateTime.sunday,
        lang: 'hi',
      );

      expect(rules.specialDay, contains('अमावस्या'));
      expect(rules.doList.length, 3);
      expect(rules.avoidList.length, 3);
      expect(rules.doList.any((point) => point.contains('पितरों')), true);
    });

    test('Tuesday rules provide Hanuman devotion guidance when not a special tithi', () {
      final rules = PanchangRules.evaluate(
        rawTithiName: 'Tritiya',
        tithiNumber: 3,
        weekday: DateTime.tuesday,
        lang: 'hi',
      );

      expect(rules.specialDay, contains('मंगलवार'));
      expect(rules.doList.length, 3);
      expect(rules.avoidList.length, 3);
      expect(rules.doList.any((point) => point.contains('हनुमान')), true);
    });

    test('Monday rules provide Shiva devotion guidance when not a special tithi', () {
      final rules = PanchangRules.evaluate(
        rawTithiName: 'Panchami',
        tithiNumber: 5,
        weekday: DateTime.monday,
        lang: 'hi',
      );

      expect(rules.specialDay, contains('सोमवार'));
      expect(rules.doList.length, 3);
      expect(rules.avoidList.length, 3);
      expect(rules.doList.any((point) => point.contains('शिव') || point.contains('शिवाय')), true);
    });

    test('Normal day rules provide positive general guidance', () {
      final rules = PanchangRules.evaluate(
        rawTithiName: 'Saptami',
        tithiNumber: 7,
        weekday: DateTime.wednesday,
        lang: 'hi',
      );

      expect(rules.specialDay, contains('पंचांग'));
      expect(rules.doList.length, 3);
      expect(rules.avoidList.length, 3);
      expect(rules.doList.any((point) => point.contains('सूर्यदेव')), true);
    });
  });
}

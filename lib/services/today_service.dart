// ══════════════════════════════════════════════════════════════════════════════
// TODAY SERVICE — "Aaj ki Aarti" & "God of the Day" selection logic
// ══════════════════════════════════════════════════════════════════════════════
//
// This is the brain of the app's daily content selection.
//
// Priority logic (highest to lowest):
//   1. 🎪 Festival today?  → Show that festival's God + Aarti
//   2. 📅 Weekday mapping  → Show weekday's traditional God + Aarti
//   3. 🙏 User preference  → Show user's preferred God + Aarti
//   4. 🔄 Fallback         → Hanuman (the universal protector)
//
// Usage:
// ```dart
// final todayResult = TodayService.getToday(
//   preferredGodIds: ['shiva', 'ganesha'],
// );
// print(todayResult.god.name.forLang('hi'));   // Today's God
// print(todayResult.aarti.title.forLang('hi')); // Today's Aarti
// print(todayResult.reason);                    // Why this was selected
// ```

import '../models/god_model.dart';
import '../models/aarti_model.dart';
import '../models/festival_model.dart';
import '../constants/app_gods.dart';
import '../constants/app_aartis.dart';
import '../constants/app_festivals.dart';

/// Reason why a particular God/Aarti was selected today.
enum SelectionReason {
  /// A major Hindu festival is active today
  festival,

  /// Selected based on weekday → God mapping
  weekday,

  /// User's preferred God
  userPreference,

  /// Default fallback (Hanuman)
  fallback,
}

/// The result of today's content selection.
///
/// Contains the God, Aarti, optional festival, and the reason for selection.
class TodayResult {
  /// The God to display as "God of the Day"
  final GodModel god;

  /// The Aarti to play as "Aaj ki Aarti"
  final AartiModel aarti;

  /// The active festival, if any (null when selection is weekday/preference/fallback)
  final FestivalModel? festival;

  /// Why this God/Aarti was selected
  final SelectionReason reason;

  /// Tri-language badge text (e.g. "मंगलवार विशेष • हनुमान जी")
  final LocalizedText badge;

  const TodayResult({
    required this.god,
    required this.aarti,
    this.festival,
    required this.reason,
    required this.badge,
  });

  @override
  String toString() =>
      'TodayResult(god=${god.id}, aarti=${aarti.id}, reason=$reason)';
}

/// Stateless service that determines today's God and Aarti.
///
/// All methods are static — no instance needed.
/// This keeps things simple and testable.
class TodayService {
  TodayService._();

  /// Main entry point: determines today's God and Aarti.
  ///
  /// [preferredGodIds] — user's preferred Gods from onboarding (max 2).
  /// [date] — optional, defaults to DateTime.now(). Useful for testing.
  static TodayResult getToday({
    List<String> preferredGodIds = const [],
    DateTime? date,
  }) {
    final today = date ?? DateTime.now();

    // ─── Priority 1: Festival ─────────────────────────────────────────
    final festival = AppFestivals.getActiveFestival(today);
    if (festival != null) {
      final god = AppGods.getByIdOrDefault(festival.relatedGodId);
      final aarti = AppAartis.getDefaultForGod(god.id);
      return TodayResult(
        god: god,
        aarti: aarti,
        festival: festival,
        reason: SelectionReason.festival,
        badge: LocalizedText(
          hi: '🎪 ${festival.name.hi}',
          ne: '🎪 ${festival.name.ne}',
          en: '🎪 ${festival.name.en}',
        ),
      );
    }

    // ─── Priority 2: Weekday mapping ─────────────────────────────────
    final weekdayGodId = AppGods.weekdayGodMap[today.weekday];
    if (weekdayGodId != null) {
      final god = AppGods.getByIdOrDefault(weekdayGodId);
      final aarti = AppAartis.getDefaultForGod(god.id);
      final dayBadge = AppGods.getWeekdayBadge(today.weekday);
      return TodayResult(
        god: god,
        aarti: aarti,
        reason: SelectionReason.weekday,
        badge: dayBadge,
      );
    }

    // ─── Priority 3: User preference ─────────────────────────────────
    if (preferredGodIds.isNotEmpty) {
      final god = AppGods.getByIdOrDefault(preferredGodIds.first);
      final aarti = AppAartis.getDefaultForGod(god.id);
      return TodayResult(
        god: god,
        aarti: aarti,
        reason: SelectionReason.userPreference,
        badge: LocalizedText(
          hi: '🙏 आपके आराध्य • ${god.name.hi}',
          ne: '🙏 तपाईंका आराध्य • ${god.name.ne}',
          en: '🙏 Your Deity • ${god.name.en}',
        ),
      );
    }

    // ─── Priority 4: Fallback (Hanuman) ──────────────────────────────
    return TodayResult(
      god: AppGods.hanuman,
      aarti: AppAartis.hanumanChalisa,
      reason: SelectionReason.fallback,
      badge: const LocalizedText(
        hi: '🙏 श्री हनुमान जी',
        ne: '🙏 श्री हनुमान जी',
        en: '🙏 Lord Hanuman',
      ),
    );
  }

  /// Convenience: get just today's God.
  static GodModel getTodaysGod({
    List<String> preferredGodIds = const [],
    DateTime? date,
  }) {
    return getToday(preferredGodIds: preferredGodIds, date: date).god;
  }

  /// Convenience: get just today's Aarti.
  static AartiModel getTodaysAarti({
    List<String> preferredGodIds = const [],
    DateTime? date,
  }) {
    return getToday(preferredGodIds: preferredGodIds, date: date).aarti;
  }

  /// Convenience: get today's active festival (or null).
  static FestivalModel? getTodaysFestival([DateTime? date]) {
    return AppFestivals.getActiveFestival(date);
  }

  /// Get the do/don't guidance for the God of the Day.
  ///
  /// Returns tri-language dos and donts based on the God.
  /// This provides the "Aaj kya karein / kya na karein" data.
  static ({List<LocalizedText> dos, List<LocalizedText> donts}) getDailyGuidance({
    List<String> preferredGodIds = const [],
    DateTime? date,
  }) {
    final result = getToday(preferredGodIds: preferredGodIds, date: date);
    return _getGuidanceForGod(result.god.id);
  }

  /// Internal: Returns dos/donts for a given God.
  static ({List<LocalizedText> dos, List<LocalizedText> donts}) _getGuidanceForGod(String godId) {
    switch (godId) {
      case 'hanuman':
        return (
          dos: const [
            LocalizedText(
              hi: 'हनुमान चालीसा का पाठ करें और सिंदूर चढ़ाएं',
              ne: 'हनुमान चालीसा पाठ गर्नुहोस् र सिंदूर चढाउनुहोस्',
              en: 'Recite Hanuman Chalisa and offer sindoor',
            ),
            LocalizedText(
              hi: 'ब्रह्मचर्य का पालन करें और सात्विक भोजन लें',
              ne: 'ब्रह्मचर्यको पालन गर्नुहोस् र सात्विक भोजन लिनुहोस्',
              en: 'Practice self-discipline and eat sattvic food',
            ),
            LocalizedText(
              hi: 'गरीबों को भोजन दान करें',
              ne: 'गरिबहरूलाई भोजन दान गर्नुहोस्',
              en: 'Donate food to the needy',
            ),
          ],
          donts: const [
            LocalizedText(
              hi: 'मांसाहार और मदिरा का सेवन न करें',
              ne: 'मांसाहार र मदिराको सेवन नगर्नुहोस्',
              en: 'Avoid non-vegetarian food and alcohol',
            ),
            LocalizedText(
              hi: 'किसी से झूठ न बोलें और क्रोध न करें',
              ne: 'कसैलाई झूठ नबोल्नुहोस् र क्रोध नगर्नुहोस्',
              en: 'Do not lie or get angry',
            ),
            LocalizedText(
              hi: 'तुलसी दल न तोड़ें',
              ne: 'तुलसी दल नतोड्नुहोस्',
              en: 'Do not pluck Tulsi leaves',
            ),
          ],
        );
      case 'shiva':
        return (
          dos: const [
            LocalizedText(
              hi: 'शिवलिंग पर जल और बिल्वपत्र अर्पित करें',
              ne: 'शिवलिङ्गमा जल र बिल्वपत्र अर्पित गर्नुहोस्',
              en: 'Offer water and Bilva leaves on Shivling',
            ),
            LocalizedText(
              hi: 'ॐ नमः शिवाय मंत्र का जप करें',
              ne: 'ॐ नमः शिवाय मन्त्रको जप गर्नुहोस्',
              en: 'Chant Om Namah Shivaya mantra',
            ),
            LocalizedText(
              hi: 'उपवास रखें या सात्विक भोजन करें',
              ne: 'उपवास राख्नुहोस् वा सात्विक भोजन गर्नुहोस्',
              en: 'Observe fast or eat sattvic food',
            ),
          ],
          donts: const [
            LocalizedText(
              hi: 'शिव पूजा में तुलसी न चढ़ाएं',
              ne: 'शिव पूजामा तुलसी नचढाउनुहोस्',
              en: 'Do not offer Tulsi in Shiva puja',
            ),
            LocalizedText(
              hi: 'शिवलिंग को पूरी तरह घुमाकर प्रदक्षिणा न करें',
              ne: 'शिवलिङ्गलाई पूरै घुमाएर प्रदक्षिणा नगर्नुहोस्',
              en: 'Do not do full circumambulation of Shivling',
            ),
            LocalizedText(
              hi: 'क्रोध और कटु वचन से बचें',
              ne: 'क्रोध र कटु वचनबाट बच्नुहोस्',
              en: 'Avoid anger and harsh words',
            ),
          ],
        );
      case 'ganesha':
        return (
          dos: const [
            LocalizedText(
              hi: 'दूर्वा (दूब घास) और मोदक या लड्डू का भोग लगाएं',
              ne: 'दूर्वा (दुबो घाँस) र मोदक वा लड्डूको भोग लगाउनुहोस्',
              en: 'Offer Durva grass and Modak or Laddu',
            ),
            LocalizedText(
              hi: 'माथे पर लाल सिंदूर या चंदन का तिलक लगाएं',
              ne: 'निधारमा रातो सिंदूर वा चन्दनको टीका लगाउनुहोस्',
              en: 'Apply red sindoor or sandalwood tilak on forehead',
            ),
            LocalizedText(
              hi: 'ॐ गं गणपतये नमः मंत्र का शांत मन से जप करें',
              ne: 'ॐ गं गणपतये नमः मन्त्रको शान्त मनले जप गर्नुहोस्',
              en: 'Chant Om Gam Ganapataye Namah with a peaceful mind',
            ),
          ],
          donts: const [
            LocalizedText(
              hi: 'गणेश जी की पूजा में तुलसी दल कभी न चढ़ाएं',
              ne: 'गणेश जीको पूजामा तुलसी दल कहिल्यै नचढाउनुहोस्',
              en: 'Never offer Tulsi leaves in Ganesha puja',
            ),
            LocalizedText(
              hi: 'घर में किसी भी प्रकार का क्लेश या क्रोध न करें',
              ne: 'घरमा कुनै प्रकारको क्लेश वा क्रोध नगर्नुहोस्',
              en: 'Avoid any kind of conflict or anger at home',
            ),
            LocalizedText(
              hi: 'पूजा में टूटे या खंडित अक्षत (चावल) न अर्पित करें',
              ne: 'पूजामा टुटेका वा खण्डित अक्षत (चामल) नचढाउनुहोस्',
              en: 'Do not offer broken rice in puja',
            ),
          ],
        );
      case 'durga':
        return (
          dos: const [
            LocalizedText(
              hi: 'माँ दुर्गा को लाल फूल और चुनरी अर्पित करें',
              ne: 'माँ दुर्गालाई रातो फूल र चुनरी अर्पित गर्नुहोस्',
              en: 'Offer red flowers and Chunari to Goddess Durga',
            ),
            LocalizedText(
              hi: 'दुर्गा सप्तशती या चालीसा का पाठ करें',
              ne: 'दुर्गा सप्तशती वा चालीसा पाठ गर्नुहोस्',
              en: 'Recite Durga Saptashati or Chalisa',
            ),
            LocalizedText(
              hi: 'कन्याओं को भोजन कराएं और दान करें',
              ne: 'कन्याहरूलाई भोजन खुवाउनुहोस् र दान गर्नुहोस्',
              en: 'Feed young girls and give charity',
            ),
          ],
          donts: const [
            LocalizedText(
              hi: 'नवरात्रि में प्याज-लहसुन का सेवन न करें',
              ne: 'नवरात्रिमा प्याज-लसुनको सेवन नगर्नुहोस्',
              en: 'Avoid onion and garlic during Navratri',
            ),
            LocalizedText(
              hi: 'अपशब्द न बोलें और नकारात्मक न सोचें',
              ne: 'अपशब्द नबोल्नुहोस् र नकारात्मक नसोच्नुहोस्',
              en: 'Do not use foul language or think negatively',
            ),
            LocalizedText(
              hi: 'बालों और नाखूनों को न काटें',
              ne: 'कपाल र नङ नकाट्नुहोस्',
              en: 'Do not cut hair or nails',
            ),
          ],
        );
      case 'krishna':
        return (
          dos: const [
            LocalizedText(
              hi: 'भगवान कृष्ण को माखन-मिश्री का भोग लगाएं',
              ne: 'भगवान कृष्णलाई माखन-मिश्रीको भोग लगाउनुहोस्',
              en: 'Offer butter and sugar to Lord Krishna',
            ),
            LocalizedText(
              hi: 'गीता का एक अध्याय पढ़ें या सुनें',
              ne: 'गीताको एक अध्याय पढ्नुहोस् वा सुन्नुहोस्',
              en: 'Read or listen to one chapter of Gita',
            ),
            LocalizedText(
              hi: 'तुलसी और पीले फूल अर्पित करें',
              ne: 'तुलसी र पहेंलो फूल अर्पित गर्नुहोस्',
              en: 'Offer Tulsi and yellow flowers',
            ),
          ],
          donts: const [
            LocalizedText(
              hi: 'किसी से ईर्ष्या या द्वेष न रखें',
              ne: 'कसैसँग ईर्ष्या वा द्वेष नराख्नुहोस्',
              en: 'Do not harbor jealousy or hatred',
            ),
            LocalizedText(
              hi: 'अहंकार और लालच से बचें',
              ne: 'अहंकार र लालचबाट बच्नुहोस्',
              en: 'Avoid ego and greed',
            ),
            LocalizedText(
              hi: 'व्यर्थ की बातों में समय न गंवाएं',
              ne: 'व्यर्थ कुरामा समय नगुमाउनुहोस्',
              en: 'Do not waste time on frivolous matters',
            ),
          ],
        );
      case 'ram':
        return (
          dos: const [
            LocalizedText(
              hi: 'रामचरितमानस या रामायण का पाठ करें',
              ne: 'रामचरितमानस वा रामायणको पाठ गर्नुहोस्',
              en: 'Recite Ramcharitmanas or Ramayana',
            ),
            LocalizedText(
              hi: 'सत्य बोलें और धर्म का आचरण करें',
              ne: 'सत्य बोल्नुहोस् र धर्मको आचरण गर्नुहोस्',
              en: 'Speak truth and practice righteousness',
            ),
            LocalizedText(
              hi: 'बड़ों का आदर करें और दान-पुण्य करें',
              ne: 'ठूलाहरूको आदर गर्नुहोस् र दान-पुण्य गर्नुहोस्',
              en: 'Respect elders and do charity',
            ),
          ],
          donts: const [
            LocalizedText(
              hi: 'किसी का अपमान या निंदा न करें',
              ne: 'कसैको अपमान वा निन्दा नगर्नुहोस्',
              en: 'Do not insult or criticize anyone',
            ),
            LocalizedText(
              hi: 'झूठ, चोरी और अन्याय से बचें',
              ne: 'झूठ, चोरी र अन्यायबाट बच्नुहोस्',
              en: 'Avoid lies, theft, and injustice',
            ),
            LocalizedText(
              hi: 'मर्यादा का उल्लंघन न करें',
              ne: 'मर्यादाको उल्लंघन नगर्नुहोस्',
              en: 'Do not violate moral boundaries',
            ),
          ],
        );
      default:
        // Fallback to Hanuman guidance
        return _getGuidanceForGod('hanuman');
    }
  }
}

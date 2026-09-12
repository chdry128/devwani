// ══════════════════════════════════════════════════════════════════════════════
// APP AARTIS — Complete Aarti registry with weekday & festival linkage
// ══════════════════════════════════════════════════════════════════════════════
//
// Each Aarti is linked to:
// - A God (via [relatedGodId])
// - Weekdays when it is traditionally recited (via [days])
// - Festivals when it is especially relevant (via [festivalIds])
//
// The [TodayService] uses these links to pick the right Aarti each day.
// To add a new Aarti, add an [AartiModel] below and include it in [allAartis].

import '../models/aarti_model.dart';
import '../models/god_model.dart';
import 'asset_paths.dart';

/// All Aartis available in the app.
class AppAartis {
  AppAartis._();

  // ─────────────────────────────────────────────────────────────────────────
  // Hanuman Chalisa — Tuesday / Saturday / Hanuman Jayanti
  // ─────────────────────────────────────────────────────────────────────────

  static final AartiModel hanumanChalisa = AartiModel(
    id: 'hanuman_chalisa',
    title: const LocalizedText(
      hi: 'श्री हनुमान चालीसा',
      ne: 'श्री हनुमान चालीसा',
      en: 'Shri Hanuman Chalisa',
    ),
    subtitle: const LocalizedText(
      hi: 'संकट मोचन कृपा',
      ne: 'सङ्कट मोचन कृपा',
      en: 'Dispeller of all Sorrows',
    ),
    audioPath: AssetPaths.hanumanChalisaAudio,
    duration: const Duration(minutes: 4, seconds: 30),
    imagePath: AssetPaths.hanumanJi,
    relatedGodId: 'hanuman',
    days: [DateTime.tuesday, DateTime.saturday],
    festivalIds: ['hanuman_jayanti'],
    isDefault: true,
    timeCategory: const LocalizedText(
      hi: 'प्रातः आरती', ne: 'प्रातः आरती', en: 'Morning Aarti',
    ),
    mood: const LocalizedText(
      hi: 'भक्ति रस', ne: 'भक्ति रस', en: 'Devotion',
    ),
    verses: const [
      // दोहा 1
      AartiVerse(
        index: 0,
        type: 'दोहा',
        startTime: Duration.zero,
        text: 'श्रीगुरु चरन सरोज रज निज मनु मुकुरु सुधारि।\nबरनउं रघुबर बिमल जसु जो दायकु फल चारि॥',
      ),
      // दोहा 2
      AartiVerse(
        index: 1,
        type: 'दोहा',
        startTime: Duration(seconds: 18),
        text: 'बुद्धिहीन तनु जानिके, सुमिरौं पवन-कुमार।\nबल बुद्धि बिद्या देहु मोहिं, हरहु कलेस बिकार॥',
      ),
      // चौपाई 1
      AartiVerse(
        index: 2,
        type: 'चौपाई',
        startTime: Duration(seconds: 35),
        text: 'जय हनुमान ज्ञान गुन सागर।\nजय कपीस तिहुँ लोक उजागर॥',
      ),
      // चौपाई 2
      AartiVerse(
        index: 3,
        type: 'चौपाई',
        startTime: Duration(seconds: 52),
        text: 'रामदूत अतुलित बल धामा।\nअंजनि-पुत्र पवनसुत नामा॥',
      ),
      // चौपाई 3
      AartiVerse(
        index: 4,
        type: 'चौपाई',
        startTime: Duration(minutes: 1, seconds: 10),
        text: 'महाबीर बिक्रम बजरंगी।\nकुमति निवार सुमति के संगी॥',
      ),
      // चौपाई 4
      AartiVerse(
        index: 5,
        type: 'चौपाई',
        startTime: Duration(minutes: 1, seconds: 28),
        text: 'कंचन बरन बिराज सुबेसा।\nकानन कुंडल कुंचित केसा॥',
      ),
      // चौपाई 5
      AartiVerse(
        index: 6,
        type: 'चौपाई',
        startTime: Duration(minutes: 1, seconds: 45),
        text: 'हाथ बज्र औ ध्वजा बिराजै।\nकांधे मूँज जनेऊ साजै॥',
      ),
      // चौपाई 6
      AartiVerse(
        index: 7,
        type: 'चौपाई',
        startTime: Duration(minutes: 2, seconds: 2),
        text: 'संकर सुवन केसरीनंदन।\nतेज प्रताप महा जग बन्दन॥',
      ),
      // चौपाई 7
      AartiVerse(
        index: 8,
        type: 'चौपाई',
        startTime: Duration(minutes: 2, seconds: 20),
        text: 'विद्यावान गुनी अति चातुर।\nराम काज करिबे को आतुर॥',
      ),
      // चौपाई 8
      AartiVerse(
        index: 9,
        type: 'चौपाई',
        startTime: Duration(minutes: 2, seconds: 38),
        text: 'प्रभु चरित्र सुनिबे को रसिया।\nराम लखन सीता मन बसिया॥',
      ),
      // चौपाई 9
      AartiVerse(
        index: 10,
        type: 'चौपाई',
        startTime: Duration(minutes: 2, seconds: 55),
        text: 'सूक्ष्म रूप धरि सियहिं दिखावा।\nबिकट रूप धरि लंक जरावा॥',
      ),
      // चौपाई 10
      AartiVerse(
        index: 11,
        type: 'चौपाई',
        startTime: Duration(minutes: 3, seconds: 12),
        text: 'भीम रूप धरि असुर संहारे।\nरामचंद्र के काज संवारे॥',
      ),
      // चौपाई 11
      AartiVerse(
        index: 12,
        type: 'चौपाई',
        startTime: Duration(minutes: 3, seconds: 30),
        text: 'लाय सजीवन लखन जियाये।\nश्रीरघुबीर हरषि उर लाये॥',
      ),
      // चौपाई 12
      AartiVerse(
        index: 13,
        type: 'चौपाई',
        startTime: Duration(minutes: 3, seconds: 48),
        text: 'संकट कटै मिटै सब पीरा।\nजो सुमिरै हनुमत बलबीरा॥',
      ),
      // अंतिम दोहा
      AartiVerse(
        index: 14,
        type: 'दोहा',
        startTime: Duration(minutes: 4, seconds: 5),
        text: 'पवनतनय संकट हरन, मंगल मूरति रूप।\nराम लखन सीता सहित, हृदय बसहु सुर भूप॥',
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Shiv Aarti — Monday / Mahashivratri
  // ─────────────────────────────────────────────────────────────────────────

  static const AartiModel shivAarti = AartiModel(
    id: 'shiv_aarti',
    title: LocalizedText(
      hi: 'ॐ जय शिव ओमकारा',
      ne: 'ॐ जय शिव ओमकारा',
      en: 'Om Jai Shiv Omkara',
    ),
    subtitle: LocalizedText(
      hi: 'भोलेनाथ की स्तुति',
      ne: 'भोलेनाथको स्तुति',
      en: 'Hymn to Lord Shiva',
    ),
    audioPath: AssetPaths.shivAartiAudio,
    duration: Duration(minutes: 5, seconds: 0),
    imagePath: AssetPaths.shivaJi,
    relatedGodId: 'shiva',
    days: [DateTime.monday],
    festivalIds: ['mahashivratri'],
    isDefault: true,
    timeCategory: LocalizedText(
      hi: 'सायं आरती', ne: 'सायं आरती', en: 'Evening Aarti',
    ),
    mood: LocalizedText(
      hi: 'भक्ति रस', ne: 'भक्ति रस', en: 'Devotion',
    ),
    verses: [
      AartiVerse(
        index: 0,
        type: 'आरती',
        startTime: Duration.zero,
        text: 'ॐ जय शिव ओमकारा, स्वामी जय शिव ओमकारा।\nब्रह्मा विष्णु सदाशिव, अर्द्धांगी धारा॥',
      ),
      AartiVerse(
        index: 1,
        type: 'आरती',
        startTime: Duration(seconds: 30),
        text: 'एकानन चतुरानन पंचानन राजे।\nहंसासन गरुड़ासन वृषवाहन साजे॥',
      ),
      AartiVerse(
        index: 2,
        type: 'आरती',
        startTime: Duration(minutes: 1),
        text: 'दो भुज चार चतुर्भुज दसभुज अति सोहे।\nत्रिगुण रूप निरखते त्रिभुवन जन मोहे॥',
      ),
      AartiVerse(
        index: 3,
        type: 'आरती',
        startTime: Duration(minutes: 1, seconds: 30),
        text: 'अक्षमाला वनमाला मुण्डमाला धारी।\nत्रिपुरारी कंसारी कर माला धारी॥',
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Ganesh Aarti — Wednesday / Ganesh Chaturthi
  // ─────────────────────────────────────────────────────────────────────────

  static const AartiModel ganeshAarti = AartiModel(
    id: 'ganesh_aarti',
    title: LocalizedText(
      hi: 'जय गणेश जय गणेश देवा',
      ne: 'जय गणेश जय गणेश देवा',
      en: 'Jai Ganesh Jai Ganesh Deva',
    ),
    subtitle: LocalizedText(
      hi: 'विघ्नहर्ता की आरती',
      ne: 'विघ्नहर्ताको आरती',
      en: 'Aarti of the Obstacle Remover',
    ),
    audioPath: AssetPaths.ganeshAartiAudio,
    duration: Duration(minutes: 4, seconds: 0),
    imagePath: AssetPaths.ganeshaJi,
    relatedGodId: 'ganesha',
    days: [DateTime.wednesday],
    festivalIds: ['ganesh_chaturthi'],
    isDefault: true,
    timeCategory: LocalizedText(
      hi: 'प्रातः आरती', ne: 'प्रातः आरती', en: 'Morning Aarti',
    ),
    mood: LocalizedText(
      hi: 'भक्ति रस', ne: 'भक्ति रस', en: 'Devotion',
    ),
    verses: [
      AartiVerse(
        index: 0,
        type: 'आरती',
        startTime: Duration.zero,
        text: 'जय गणेश जय गणेश जय गणेश देवा।\nमाता जाकी पार्वती पिता महादेवा॥',
      ),
      AartiVerse(
        index: 1,
        type: 'आरती',
        startTime: Duration(seconds: 25),
        text: 'एकदंत दयावंत चार भुजा धारी।\nमाथे पर तिलक सोहे मूसे की सवारी॥',
      ),
      AartiVerse(
        index: 2,
        type: 'आरती',
        startTime: Duration(seconds: 50),
        text: 'पान चढ़े फूल चढ़े और चढ़े मेवा।\nलड्डुअन का भोग लगे संत करें सेवा॥',
      ),
      AartiVerse(
        index: 3,
        type: 'आरती',
        startTime: Duration(minutes: 1, seconds: 15),
        text: 'अंधन को आँख देत कोढ़िन को काया।\nबांझन को पुत्र देत निर्धन को माया॥',
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Durga Aarti — Friday / Navratri
  // ─────────────────────────────────────────────────────────────────────────

  static const AartiModel durgaAarti = AartiModel(
    id: 'durga_aarti',
    title: LocalizedText(
      hi: 'जय अम्बे गौरी',
      ne: 'जय अम्बे गौरी',
      en: 'Jai Ambe Gauri',
    ),
    subtitle: LocalizedText(
      hi: 'माँ दुर्गा की आरती',
      ne: 'माँ दुर्गाको आरती',
      en: 'Aarti of Goddess Durga',
    ),
    audioPath: AssetPaths.durgaAartiAudio,
    duration: Duration(minutes: 5, seconds: 30),
    imagePath: AssetPaths.durgaMaa,
    relatedGodId: 'durga',
    days: [DateTime.friday],
    festivalIds: ['navratri'],
    isDefault: true,
    timeCategory: LocalizedText(
      hi: 'सायं आरती', ne: 'सायं आरती', en: 'Evening Aarti',
    ),
    mood: LocalizedText(
      hi: 'शक्ति भाव', ne: 'शक्ति भाव', en: 'Power & Devotion',
    ),
    verses: [
      AartiVerse(
        index: 0,
        type: 'आरती',
        startTime: Duration.zero,
        text: 'जय अम्बे गौरी, मैया जय श्यामा गौरी।\nतुमको निशदिन ध्यावत, हरि ब्रह्मा शिवजी॥',
      ),
      AartiVerse(
        index: 1,
        type: 'आरती',
        startTime: Duration(seconds: 30),
        text: 'मांग सिंदूर बिराजत, टीको मृगमद को।\nउज्जवल से दोउ नैना, चंद्रबदन नीको॥',
      ),
      AartiVerse(
        index: 2,
        type: 'आरती',
        startTime: Duration(minutes: 1),
        text: 'कनक समान कलेवर, रक्ताम्बर राजे।\nरक्तपुष्प गल माला, कंठन पर साजे॥',
      ),
      AartiVerse(
        index: 3,
        type: 'आरती',
        startTime: Duration(minutes: 1, seconds: 30),
        text: 'केहरि वाहन राजत, खड्ग खप्पर धारी।\nसुर नर मुनि जन सेवत, तिनके दुखहारी॥',
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Krishna Aarti — Janmashtami
  // ─────────────────────────────────────────────────────────────────────────

  static const AartiModel krishnaAarti = AartiModel(
    id: 'krishna_aarti',
    title: LocalizedText(
      hi: 'ॐ जय जगदीश हरे',
      ne: 'ॐ जय जगदीश हरे',
      en: 'Om Jai Jagdish Hare',
    ),
    subtitle: LocalizedText(
      hi: 'श्री कृष्ण की आरती',
      ne: 'श्री कृष्णको आरती',
      en: 'Aarti of Lord Krishna',
    ),
    audioPath: AssetPaths.krishnaAartiAudio,
    duration: Duration(minutes: 5, seconds: 0),
    imagePath: AssetPaths.krishnaJi,
    relatedGodId: 'krishna',
    days: [], // No specific weekday; played on Janmashtami + user preference
    festivalIds: ['janmashtami'],
    isDefault: true,
    timeCategory: LocalizedText(
      hi: 'सायं आरती', ne: 'सायं आरती', en: 'Evening Aarti',
    ),
    mood: LocalizedText(
      hi: 'प्रेम भाव', ne: 'प्रेम भाव', en: 'Love & Devotion',
    ),
    verses: [
      AartiVerse(
        index: 0,
        type: 'आरती',
        startTime: Duration.zero,
        text: 'ॐ जय जगदीश हरे, स्वामी जय जगदीश हरे।\nभक्त जनों के संकट, दास जनों के संकट, क्षण में दूर करे॥',
      ),
      AartiVerse(
        index: 1,
        type: 'आरती',
        startTime: Duration(seconds: 30),
        text: 'जो ध्यावे फल पावे, दुख बिनसे मन का।\nसुख सम्पत्ति घर आवे, कष्ट मिटे तन का॥',
      ),
      AartiVerse(
        index: 2,
        type: 'आरती',
        startTime: Duration(minutes: 1),
        text: 'मात पिता तुम मेरे, शरण गहूं किसकी।\nतुम बिन और न दूजा, आस करूं जिसकी॥',
      ),
      AartiVerse(
        index: 3,
        type: 'आरती',
        startTime: Duration(minutes: 1, seconds: 30),
        text: 'तुम पूरण परमात्मा, तुम अन्तर्यामी।\nपारब्रह्म परमेश्वर, तुम सबके स्वामी॥',
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Ram Aarti — Sunday / Thursday / Ram Navami / Diwali
  // ─────────────────────────────────────────────────────────────────────────

  static const AartiModel ramAarti = AartiModel(
    id: 'ram_aarti',
    title: LocalizedText(
      hi: 'श्री रामचन्द्र कृपालु भजु मन',
      ne: 'श्री रामचन्द्र कृपालु भजु मन',
      en: 'Shri Ramchandra Kripalu Bhaju Man',
    ),
    subtitle: LocalizedText(
      hi: 'श्री राम स्तुति',
      ne: 'श्री राम स्तुति',
      en: 'Hymn to Lord Ram',
    ),
    audioPath: AssetPaths.ramAartiAudio,
    duration: Duration(minutes: 4, seconds: 45),
    imagePath: AssetPaths.ramJi,
    relatedGodId: 'ram',
    days: [DateTime.sunday, DateTime.thursday],
    festivalIds: ['ram_navami', 'diwali'],
    isDefault: true,
    timeCategory: LocalizedText(
      hi: 'प्रातः आरती', ne: 'प्रातः आरती', en: 'Morning Aarti',
    ),
    mood: LocalizedText(
      hi: 'भक्ति रस', ne: 'भक्ति रस', en: 'Devotion',
    ),
    verses: [
      AartiVerse(
        index: 0,
        type: 'स्तुति',
        startTime: Duration.zero,
        text: 'श्री रामचन्द्र कृपालु भजु मन हरण भवभय दारुणं।\nनव कंज लोचन कंज मुख कर कंज पद कंजारुणं॥',
      ),
      AartiVerse(
        index: 1,
        type: 'स्तुति',
        startTime: Duration(seconds: 35),
        text: 'कन्दर्प अगणित अमित छवि नव नील नीरद सुन्दरं।\nपटपीत मानहुँ तड़ित रुचि शुचि नौमि जनक सुतावरं॥',
      ),
      AartiVerse(
        index: 2,
        type: 'स्तुति',
        startTime: Duration(minutes: 1, seconds: 10),
        text: 'भजु दीनबन्धु दिनेश दानव दैत्य वंश निकन्दनं।\nरघुनन्द आनन्दकन्द कोसलचन्द दशरथ नन्दनं॥',
      ),
      AartiVerse(
        index: 3,
        type: 'स्तुति',
        startTime: Duration(minutes: 1, seconds: 45),
        text: 'शिर मुकुट कुण्डल तिलक चारु उदारु अंग विभूषणं।\nआजानुभुज शर चाप धर सुर सेवय हित भूषणं॥',
      ),
    ],
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Complete list of all Aartis
  // ─────────────────────────────────────────────────────────────────────────

  /// Master list of all Aartis. Add new Aartis here.
  static final List<AartiModel> allAartis = [
    hanumanChalisa,
    shivAarti,
    ganeshAarti,
    durgaAarti,
    krishnaAarti,
    ramAarti,
  ];

  /// Returns the default Aarti for a given God.
  /// Falls back to Hanuman Chalisa if no default found.
  static AartiModel getDefaultForGod(String godId) {
    for (final aarti in allAartis) {
      if (aarti.relatedGodId == godId && aarti.isDefault) {
        return aarti;
      }
    }
    // Fallback: any aarti for this god
    for (final aarti in allAartis) {
      if (aarti.relatedGodId == godId) return aarti;
    }
    // Ultimate fallback
    return hanumanChalisa;
  }

  /// Returns all Aartis linked to a given weekday.
  static List<AartiModel> getAartisForDay(int weekday) {
    return allAartis
        .where((a) => a.days.contains(weekday))
        .toList();
  }

  /// Returns all Aartis linked to a given festival.
  static List<AartiModel> getAartisForFestival(String festivalId) {
    return allAartis
        .where((a) => a.festivalIds.contains(festivalId))
        .toList();
  }

  /// Returns all Aartis for a given God.
  static List<AartiModel> getAartisForGod(String godId) {
    return allAartis
        .where((a) => a.relatedGodId == godId)
        .toList();
  }

  /// Quick lookup by ID. Returns null if not found.
  static AartiModel? getById(String id) {
    for (final aarti in allAartis) {
      if (aarti.id == id) return aarti;
    }
    return null;
  }
}

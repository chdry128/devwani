// ══════════════════════════════════════════════════════════════════════════════
// PANCHANG RULES — Senior-Friendly "What to Do" & "What to Avoid" Guidance
// ══════════════════════════════════════════════════════════════════════════════

/// Result containing the 3 Do's, 3 Don'ts, and the special day badge.
class PanchangRuleResult {
  final List<String> doList;
  final List<String> avoidList;
  final String specialDay;

  const PanchangRuleResult({
    required this.doList,
    required this.avoidList,
    required this.specialDay,
  });
}

/// Rule-based guidance engine providing culturally authentic, simple, and
/// positive daily advice for elderly users in India and Nepal.
///
/// Priority Order:
/// 1. Ekadashi (Sacred fasting & Vishnu devotion)
/// 2. Purnima (Full moon & Satyanarayan prayer)
/// 3. Amavasya (New moon & Ancestor remembrance)
/// 4. Tuesday (Hanuman Ji devotion)
/// 5. Monday (Lord Shiva worship)
/// 6. Normal Day (General righteous living & peace)
class PanchangRules {
  PanchangRules._();

  /// Evaluates rules based on tithi and weekday, returning localized points.
  static PanchangRuleResult evaluate({
    required String rawTithiName,
    required int tithiNumber,
    required int weekday,
    String lang = 'hi',
  }) {
    final nameLower = rawTithiName.trim().toLowerCase();

    // 1. Ekadashi Check (11th tithi of Shukla or Krishna paksha)
    if (nameLower.contains('ekadashi') || tithiNumber == 11 || tithiNumber == 26) {
      return _getEkadashiRules(lang);
    }

    // 2. Purnima Check (15th tithi, Full Moon)
    if (nameLower.contains('purnima') || tithiNumber == 15) {
      return _getPurnimaRules(lang);
    }

    // 3. Amavasya Check (30th tithi, New Moon)
    if (nameLower.contains('amavasya') || tithiNumber == 30) {
      return _getAmavasyaRules(lang);
    }

    // 4. Tuesday Check (Hanuman Ji)
    if (weekday == DateTime.tuesday) {
      return _getTuesdayRules(lang);
    }

    // 5. Monday Check (Lord Shiva)
    if (weekday == DateTime.monday) {
      return _getMondayRules(lang);
    }

    // 6. Normal Day Fallback
    return _getNormalDayRules(lang);
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 1. EKADASHI RULES
  // ──────────────────────────────────────────────────────────────────────────
  static PanchangRuleResult _getEkadashiRules(String lang) {
    switch (lang) {
      case 'ne':
        return const PanchangRuleResult(
          specialDay: 'एकादशी (अति शुभ पावन व्रत)',
          doList: [
            'भगवान विष्णु र पीपलको रुखमा जल चढाउनुहोस्',
            'तुलसी जीको अगाडि शुद्ध घ्यूको दियो बाल्नुहोस्',
            'सात्विक फलाहार लिनुहोस् र ॐ नमो भगवते वासुदेवाय जप गर्नुहोस्',
          ],
          avoidList: [
            'चामल, अन्न र भारी भोजन सेवन नगर्नुहोस्',
            'तामसिक भोजन, लसुन-प्याजबाट टाढा रहनुहोस्',
            'रिस, कटु वचन र कसैको अनादर नगर्नुहोस्',
          ],
        );
      case 'en':
        return const PanchangRuleResult(
          specialDay: 'Ekadashi (Auspicious Fasting Day)',
          doList: [
            'Offer water to Lord Vishnu and the sacred Peepal tree',
            'Light a pure ghee lamp before the holy Tulsi plant',
            'Take light sattvic fruits and chant Vishnu Mahamantra',
          ],
          avoidList: [
            'Avoid eating rice, grains, and heavy meals',
            'Avoid tamasic foods, onions, and garlic completely',
            'Avoid anger, harsh words, and disrespecting anyone',
          ],
        );
      case 'hi':
      default:
        return const PanchangRuleResult(
          specialDay: 'एकादशी (अति शुभ पावन व्रत)',
          doList: [
            'भगवान विष्णु और पीपल वृक्ष को जल अर्पित करें',
            'तुलसी जी के समक्ष शुद्ध घी का दीपक जलाएं',
            'सात्विक फलाहार लें और ॐ नमो भगवते वासुदेवाय का जप करें',
          ],
          avoidList: [
            'चावल, अन्न और भारी भोजन का सेवन न करें',
            'तामसिक भोजन, लहसुन-प्याज से परहेज करें',
            'क्रोध, कटु वचन और किसी का अनादर न करें',
          ],
        );
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 2. PURNIMA RULES
  // ──────────────────────────────────────────────────────────────────────────
  static PanchangRuleResult _getPurnimaRules(String lang) {
    switch (lang) {
      case 'ne':
        return const PanchangRuleResult(
          specialDay: 'पूर्णिमा (सत्यनारायण तथा दीपदान पर्व)',
          doList: [
            'श्री सत्यनारायण कथा र चन्द्रमालाई अर्घ्य दिनुहोस्',
            'घरको मुख्य ढोकामा दियो बाल्नुहोस् र शान्ति राख्नुहोस्',
            'असहाय तथा खाँचोमा परेकालाई अन्न वा वस्त्र दान गर्नुहोस्',
          ],
          avoidList: [
            'अबेर रातिसम्म जाग्ने र नकारात्मक विचारबाट बच्नुहोस्',
            'तामसिक तथा बासी खाना नखानुहोस्',
            'कसैसँग अनावश्यक झगडा वा वादविवाद नगर्नुहोस्',
          ],
        );
      case 'en':
        return const PanchangRuleResult(
          specialDay: 'Purnima (Full Moon Day)',
          doList: [
            'Perform Satyanarayan prayer and offer water to the full Moon',
            'Light lamps at the entrance and maintain a peaceful home',
            'Donate food, clothing, or charity to the needy',
          ],
          avoidList: [
            'Avoid staying awake late and negative thinking',
            'Avoid stale, impure, or tamasic food',
            'Avoid unnecessary disputes and arguments',
          ],
        );
      case 'hi':
      default:
        return const PanchangRuleResult(
          specialDay: 'पूर्णिमा (सत्यनारायण व दीपदान पर्व)',
          doList: [
            'श्री सत्यनारायण कथा और चंद्रमा को अर्घ्य दें',
            'घर के मुख्य द्वार पर दीपक जलाएं और शांति बनाए रखें',
            'गरीबों व जरूरतमंदों को अन्न या वस्त्र का दान करें',
          ],
          avoidList: [
            'देर रात तक जागने और नकारात्मक विचारों से बचें',
            'तामसिक और बासी भोजन ग्रहण न करें',
            'किसी से व्यर्थ विवाद या कलह न करें',
          ],
        );
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 3. AMAVASYA RULES
  // ──────────────────────────────────────────────────────────────────────────
  static PanchangRuleResult _getAmavasyaRules(String lang) {
    switch (lang) {
      case 'ne':
        return const PanchangRuleResult(
          specialDay: 'औंसी (पितृ स्मरण तथा शान्ति दिन)',
          doList: [
            'पितृहरूको स्मरण गर्दै तर्पण र प्रार्थना गर्नुहोस्',
            'पीपलको बोटमा जल चढाउनुहोस् र दीपदान गर्नुहोस्',
            'पशुपन्छीलाई दाना-पानी दिनुहोस् र परोपकार गर्नुहोस्',
          ],
          avoidList: [
            'आज कुनै नयाँ ठूलो काम वा गृह प्रवेश नगर्नुहोस्',
            'एकान्त वा सुनसान ठाउँमा जानबाट बच्नुहोस्',
            'तामसिक खाना र कपाल-नङ काट्नबाट बच्नुहोस्',
          ],
        );
      case 'en':
        return const PanchangRuleResult(
          specialDay: 'Amavasya (New Moon Day)',
          doList: [
            'Offer quiet prayers and peaceful remembrance to ancestors',
            'Offer water and light a lamp near a sacred Peepal tree',
            'Feed cows, birds, or donate food to the underprivileged',
          ],
          avoidList: [
            'Avoid starting major new ventures or housewarming today',
            'Avoid isolated places and conflicting situations',
            'Avoid tamasic food and cutting hair or nails',
          ],
        );
      case 'hi':
      default:
        return const PanchangRuleResult(
          specialDay: 'अमावस्या (पितृ स्मरण व शांति दिवस)',
          doList: [
            'पितरों के निमित्त ध्यान, तर्पण और प्रार्थना करें',
            'पीपल के पेड़ में जल दें और दीपदान करें',
            'पशु-पक्षियों को भोजन दें और परोपकार करें',
          ],
          avoidList: [
            'आज कोई नया बड़ा कार्य या गृह प्रवेश न करें',
            'सुनसान स्थानों पर जाने और वाद-विवाद से बचें',
            'तामसिक आहार और बाल-नाखून काटने से बचें',
          ],
        );
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 4. TUESDAY (HANUMAN) RULES
  // ──────────────────────────────────────────────────────────────────────────
  static PanchangRuleResult _getTuesdayRules(String lang) {
    switch (lang) {
      case 'ne':
        return const PanchangRuleResult(
          specialDay: 'मङ्गलबार विशेष (हनुमान जीको कृपा)',
          doList: [
            'श्री हनुमान चालीसा वा सुन्दरकाण्ड पाठ गर्नुहोस्',
            'हनुमान जीलाई सिन्दूर, रातो फूल वा गुड-चना चढाउनुहोस्',
            'गाई वा बाँदरलाई गुड-रोटी खुवाउनुहोस् र धैर्य राख्नुहोस्',
          ],
          avoidList: [
            'आज नुन कम खानुहोस् र मासु-मदिराबाट टाढा रहनुहोस्',
            'कपाल र दाह्री-जुँगा काट्नबाट बच्नुहोस्',
            'कसैसँग ऋण लेनदेन वा झगडा नगर्नुहोस्',
          ],
        );
      case 'en':
        return const PanchangRuleResult(
          specialDay: 'Tuesday Special (Hanuman Blessings)',
          doList: [
            'Recite Shri Hanuman Chalisa with sincere devotion',
            'Offer red flowers, jaggery, and roasted gram to Hanuman Ji',
            'Feed cows or birds and cultivate courage and positivity',
          ],
          avoidList: [
            'Avoid excessive salt, non-veg food, and intoxicants',
            'Avoid cutting hair or shaving today',
            'Avoid lending/borrowing money and interpersonal strife',
          ],
        );
      case 'hi':
      default:
        return const PanchangRuleResult(
          specialDay: 'मंगलवार विशेष (हनुमान जी की कृपा)',
          doList: [
            'श्री हनुमान चालीसा अथवा सुंदरकांड का पाठ करें',
            'हनुमान जी को सिंदूर, लाल पुष्प या गुड़-चना अर्पित करें',
            'गाय या बंदरों को गुड़-रोटी खिलाएं और मन में साहस रखें',
          ],
          avoidList: [
            'आज नमक का कम सेवन करें और तामसिक भोजन से बचें',
            'बाल और दाढ़ी-मूंछ काटने से परहेज करें',
            'किसी से उधार लेन-देन या झगड़ा न करें',
          ],
        );
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 5. MONDAY (SHIVA) RULES
  // ──────────────────────────────────────────────────────────────────────────
  static PanchangRuleResult _getMondayRules(String lang) {
    switch (lang) {
      case 'ne':
        return const PanchangRuleResult(
          specialDay: 'सोमबार विशेष (भगवान शिवको पावन दिन)',
          doList: [
            'शिवलिङ्गमा शुद्ध जल, दूध र बेलपत्र चढाउनुहोस्',
            "'ॐ नमः शिवाय' मन्त्र शान्त भावले जप गर्नुहोस्",
            'आमाबुबाको आशीर्वाद लिनुहोस् र सेतो वस्तु दान गर्नुहोस्',
          ],
          avoidList: [
            'शिवजीको पूजामा केतकीको फूल र तुलसी नचढाउनुहोस्',
            'कटु वचन र मनमा अशान्ति ल्याउने विचारबाट बच्नुहोस्',
            'तामसिक खाना र नराम्रो बानीबाट टाढा रहनुहोस्',
          ],
        );
      case 'en':
        return const PanchangRuleResult(
          specialDay: 'Monday Special (Lord Shiva Devotion)',
          doList: [
            'Offer pure water, milk, and Bilva leaves to Shiva Lingam',
            "Peacefully chant the sacred mantra 'Om Namah Shivaya'",
            'Seek blessings of elders and donate milk or rice',
          ],
          avoidList: [
            'Do not offer Ketaki flowers or Tulsi leaves to Lord Shiva',
            'Avoid harsh words and unsettling thoughts',
            'Avoid tamasic food and unhealthy habits',
          ],
        );
      case 'hi':
      default:
        return const PanchangRuleResult(
          specialDay: 'सोमवार विशेष (भगवान शिव का पावन दिन)',
          doList: [
            'शिवलिंग पर शुद्ध जल, कच्चा दूध और बेलपत्र अर्पित करें',
            "'ॐ नमः शिवाय' महामंत्र का शांत मन से जप करें",
            'माता-पिता का आशीर्वाद लें और सफेद वस्तु (दूध/चावल) का दान करें',
          ],
          avoidList: [
            'शिव पूजा में केतकी के फूल व तुलसी दल न चढ़ाएं',
            'कटु वचन और मन में अशांति लाने वाले विचारों से बचें',
            'तामसिक भोजन और व्यसन से पूरी तरह दूर रहें',
          ],
        );
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // 6. NORMAL DAY RULES
  // ──────────────────────────────────────────────────────────────────────────
  static PanchangRuleResult _getNormalDayRules(String lang) {
    switch (lang) {
      case 'ne':
        return const PanchangRuleResult(
          specialDay: 'शुभ दैनिक पञ्चाङ्ग',
          doList: [
            'बिहान सूर्यदेवलाई जल चढाउनुहोस् र इष्ट मन्त्र जप गर्नुहोस्',
            'आमाबुबा तथा मान्यजनको आदर गर्नुहोस् र मीठो बोल्नुहोस्',
            'चराचुरुङ्गीलाई दाना र गाईलाई पहिलो रोटी दिनुहोस्',
          ],
          avoidList: [
            'सूर्योदयपछि अबेरसम्म सुत्नबाट बच्नुहोस्',
            'कसैको कुरा काट्ने, निन्दा वा झूट बोल्नबाट बच्नुहोस्',
            'अन्नको अनादर वा खाना खेर नफाल्नुहोस्',
          ],
        );
      case 'en':
        return const PanchangRuleResult(
          specialDay: 'Auspicious Daily Panchang',
          doList: [
            'Offer water to the rising Sun and chant your chosen mantra',
            'Speak gently and show reverence to parents and elders',
            'Feed birds or animals and share kind deeds with others',
          ],
          avoidList: [
            'Avoid sleeping late past the morning sunrise',
            'Avoid gossiping, criticism, and untruthful speech',
            'Avoid disrespecting or wasting food',
          ],
        );
      case 'hi':
      default:
        return const PanchangRuleResult(
          specialDay: 'शुभ दैनिक पंचांग',
          doList: [
            'प्रातः सूर्यदेव को जल दें और गायत्री अथवा इष्ट मंत्र जपें',
            'माता-पिता व बड़ों का सम्मान करें और मधुर वाणी बोलें',
            'पक्षियों को दाना और गाय को पहली रोटी प्रेमपूर्वक दें',
          ],
          avoidList: [
            'सूर्योदय के बाद देर तक सोने से बचें',
            'किसी की निंदा, चुगली या असत्य बोलने से बचें',
            'अन्न का अनादर अथवा भोजन व्यर्थ न करें',
          ],
        );
    }
  }
}

class NumberToWordConverter {
  static String toEnglish(int number) {
    if (number == 0) return 'Zero';
    final sign = number < 0 ? 'Minus ' : '';
    final word = _toEnglishHelper(number.abs()).trim().replaceAll(RegExp(r'\s+'), ' ');
    return '$sign$word';
  }

  static String _toEnglishHelper(int number) {
    final ones = [
      '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten',
      'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'
    ];

    final tens = [
      '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
    ];

    if (number < 20) {
      return ones[number];
    }
    if (number < 100) {
      return '${tens[number ~/ 10]} ${ones[number % 10]}'.trim();
    }

    String result = '';

    // Trillions
    if (number >= 1000000000000) {
      int trillions = number ~/ 1000000000000;
      result += '${_toEnglishHelper(trillions)} Trillion ';
      number %= 1000000000000;
    }

    // Billions
    if (number >= 1000000000) {
      int billions = number ~/ 1000000000;
      result += '${_toEnglishHelper(billions)} Billion ';
      number %= 1000000000;
    }

    // Millions
    if (number >= 1000000) {
      int millions = number ~/ 1000000;
      result += '${_toEnglishHelper(millions)} Million ';
      number %= 1000000;
    }

    // Thousands
    if (number >= 1000) {
      int thousands = number ~/ 1000;
      result += '${_toEnglishHelper(thousands)} Thousand ';
      number %= 1000;
    }

    // Hundreds
    if (number >= 100) {
      int hundreds = number ~/ 100;
      result += '${_toEnglishHelper(hundreds)} Hundred ';
      number %= 100;
    }

    // Remaining
    if (number > 0) {
      if (number < 20) {
        result += ones[number];
      } else {
        result += '${tens[number ~/ 10]} ${ones[number % 10]}'.trim();
      }
    }

    return result;
  }

  static String toHindi(int number) {
    if (number == 0) return 'शून्य';
    final sign = number < 0 ? 'ऋण ' : '';
    final word = _toHindiHelper(number.abs()).trim().replaceAll(RegExp(r'\s+'), ' ');
    return '$sign$word';
  }

  static String _toHindiHelper(int number) {
    final hindiNames = [
      '', 'एक', 'दो', 'तीन', 'चार', 'पाँच', 'छह', 'सात', 'आठ', 'नौ', 'दस',
      'ग्यारह', 'बारह', 'तेरह', 'चौदह', 'पंद्रह', 'सोलह', 'सत्रह', 'अठारह', 'उन्नीस', 'बीस',
      'इक्कीस', 'बाईस', 'तेईस', 'चौबीस', 'पच्चीस', 'छब्बीस', 'सत्ताईस', 'अठाईस', 'उनतीस', 'तीस',
      'इकतीस', 'बत्तीस', 'तैंतीस', 'चौंतीस', 'पैंतीस', 'छत्तीस', 'सैंतीस', 'अड़तीस', 'उनतालीस', 'चालीस',
      'इकतालीस', 'बयालीस', 'तैंतालीस', 'चियालीस', 'पैंतालीस', 'छियालीस', 'सैंतालीस', 'अड़तालीस', 'उनचास', 'पचास',
      'इक्यावन', 'बावन', 'तिर्पन', 'चौवन', 'पचपन', 'छप्पन', 'सत्तावन', 'अठावन', 'उनसठ', 'साठ',
      'इकसठ', 'बासठ', 'तिरसठ', 'चौंसठ', 'पैंसठ', 'छियासठ', 'सरसठ', 'अड़सठ', 'उनहत्तर', 'सत्तर',
      'इकहत्तर', 'बहत्तर', 'तिहत्तर', 'चौहत्तर', 'पचहत्तर', 'छिहत्तर', 'सतहत्तर', 'अठहत्तर', 'उन्यासी', 'अस्सी',
      'इक्यासी', 'बयासी', 'तिरासी', 'चौरासी', 'पचासी', 'छियासी', 'सत्तासी', 'अठासी', 'नवासी', 'नब्बे',
      'इक्यान्वे', 'बयान्वे', 'तिरान्वे', 'चौरान्वे', 'पंचानवे', 'छियान्वे', 'सत्तान्वे', 'अठान्वे', 'निन्यान्वे'
    ];

    if (number < 100) {
      return hindiNames[number];
    }

    String result = '';
    
    // Crores
    if (number >= 10000000) {
      int crores = number ~/ 10000000;
      result += '${_toHindiHelper(crores)} करोड़ ';
      number %= 10000000;
    }
    
    // Lakhs
    if (number >= 100000) {
      int lakhs = number ~/ 100000;
      result += '${_toHindiHelper(lakhs)} लाख ';
      number %= 100000;
    }
    
    // Thousands
    if (number >= 1000) {
      int thousands = number ~/ 1000;
      result += '${_toHindiHelper(thousands)} हजार ';
      number %= 1000;
    }
    
    // Hundreds
    if (number >= 100) {
      int hundreds = number ~/ 100;
      result += '${_toHindiHelper(hundreds)} सौ ';
      number %= 100;
    }
    
    // Remaining
    if (number > 0) {
      result += hindiNames[number];
    }
    
    return result;
  }

  static String toBengali(int number) {
    if (number == 0) return 'শূন্য';
    final sign = number < 0 ? 'ঋণাত্মক ' : '';
    final word = _toBengaliHelper(number.abs()).trim().replaceAll(RegExp(r'\s+'), ' ');
    return '$sign$word';
  }

  static String _toBengaliHelper(int number) {
    final bengaliNames = [
      '', 'এক', 'দুই', 'তিন', 'চার', 'পাঁচ', 'ছয়', 'সাত', 'আট', 'নয়', 'দশ',
      'এগারো', 'বারো', 'তেরো', 'চৌদ্দ', 'পনেরো', 'ষোলো', 'সতেরো', 'আঠারো', 'উনিশ', 'বিশ',
      'একুশ', 'বাইশ', 'তেইশ', 'চব্বিশ', 'পঁচিশ', 'ছাব্বিশ', 'সাতাশ', 'আটাশ', 'উনত্রিশ', 'ত্রিশ',
      'একত্রিশ', 'বত্রিশ', 'তেত্রিশ', 'চৌত্রিশ', 'পঁয়ত্রিশ', 'ছত্রিশ', 'সাইত্রিশ', 'আটত্রিশ', 'উনচল্লিশ', 'চল্লিশ',
      'একচল্লিশ', 'বিয়াল্লিশ', 'তেতাল্লিশ', 'চুয়াল্লিশ', 'পঁয়তাল্লিশ', 'ছেচল্লিশ', 'সাতচল্লিশ', 'আটচল্লিশ', 'উনপঞ্চাশ', 'পঞ্চাশ',
      'একান্ন', 'বায়ান্ন', 'তিপ্পান্ন', 'চুয়ান্ন', 'পঞ্চান্ন', 'ছাপ্পান্ন', 'সাতান্ন', 'আটান্ন', 'উনষাট', 'ষাট',
      'একষট্টি', 'বাষট্টি', 'তেষট্টি', 'চৌষট্টি', 'পঁয়ষট্টি', 'ছেষট্টি', 'সাতষট্টি', 'আটষট্টি', 'উনসত্তর', 'সত্তর',
      'একাত্তর', 'বাহাত্তর', 'তিয়াত্তর', 'চুয়াত্তর', 'পঁচাত্তর', 'ছিয়াত্তর', 'সাতাত্তর', 'আটাত্তর', 'ঊনআশি', 'আশি',
      'একাশি', 'বিরাশি', 'তিরাশি', 'চুরাশি', 'পঁচাশী', 'ছিয়াশি', 'সাতাশি', 'আটাশি', 'ঊননব্বই', 'নব্বই',
      'একানব্বই', 'বিরানব্বই', 'তিরানব্বই', 'চুরানব্বই', 'পঁচানব্বই', 'ছিয়ানব্বই', 'সাতানব্বই', 'আটানব্বই', 'নিরানব্বই'
    ];

    final bengaliHundreds = [
      '', 'একশত', 'দুইশত', 'তিনশত', 'চারশত', 'পাঁচশত', 'ছয়শত', 'সাতশত', 'আটশত', 'নয়শত'
    ];

    if (number < 100) {
      return bengaliNames[number];
    }

    String result = '';
    
    // Crores
    if (number >= 10000000) {
      int crores = number ~/ 10000000;
      result += '${_toBengaliHelper(crores)} কোটি ';
      number %= 10000000;
    }
    
    // Lakhs
    if (number >= 100000) {
      int lakhs = number ~/ 100000;
      result += '${_toBengaliHelper(lakhs)} লক্ষ ';
      number %= 100000;
    }
    
    // Thousands
    if (number >= 1000) {
      int thousands = number ~/ 1000;
      result += '${_toBengaliHelper(thousands)} হাজার ';
      number %= 1000;
    }
    
    // Hundreds
    if (number >= 100) {
      int hundreds = number ~/ 100;
      if (hundreds < 10) {
        result += '${bengaliHundreds[hundreds]} ';
      } else {
        result += '${_toBengaliHelper(hundreds)} শত ';
      }
      number %= 100;
    }
    
    // Remaining
    if (number > 0) {
      result += bengaliNames[number];
    }
    
    return result;
  }
}

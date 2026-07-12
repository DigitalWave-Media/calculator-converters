import 'package:flutter_test/flutter_test.dart';
import 'package:calculator_converters/core/utils/number_to_word_converter.dart';

void main() {
  group('NumberToWordConverter English tests', () {
    test('Zero and small digits', () {
      expect(NumberToWordConverter.toEnglish(0), 'Zero');
      expect(NumberToWordConverter.toEnglish(5), 'Five');
      expect(NumberToWordConverter.toEnglish(11), 'Eleven');
      expect(NumberToWordConverter.toEnglish(19), 'Nineteen');
    });

    test('Tens and Hundreds', () {
      expect(NumberToWordConverter.toEnglish(25), 'Twenty Five');
      expect(NumberToWordConverter.toEnglish(99), 'Ninety Nine');
      expect(NumberToWordConverter.toEnglish(100), 'One Hundred');
      expect(NumberToWordConverter.toEnglish(105), 'One Hundred Five');
      expect(NumberToWordConverter.toEnglish(342), 'Three Hundred Forty Two');
    });

    test('Thousands, Millions, Billions, Trillions', () {
      expect(NumberToWordConverter.toEnglish(1234), 'One Thousand Two Hundred Thirty Four');
      expect(NumberToWordConverter.toEnglish(10000), 'Ten Thousand');
      expect(NumberToWordConverter.toEnglish(100000), 'One Hundred Thousand');
      expect(NumberToWordConverter.toEnglish(1000000), 'One Million');
      expect(NumberToWordConverter.toEnglish(123456789), 'One Hundred Twenty Three Million Four Hundred Fifty Six Thousand Seven Hundred Eighty Nine');
      expect(NumberToWordConverter.toEnglish(1000000000000), 'One Trillion');
    });

    test('Negative numbers', () {
      expect(NumberToWordConverter.toEnglish(-15), 'Minus Fifteen');
      expect(NumberToWordConverter.toEnglish(-123), 'Minus One Hundred Twenty Three');
    });
  });

  group('NumberToWordConverter Hindi tests', () {
    test('Zero and small digits', () {
      expect(NumberToWordConverter.toHindi(0), 'शून्य');
      expect(NumberToWordConverter.toHindi(1), 'एक');
      expect(NumberToWordConverter.toHindi(9), 'नौ');
      expect(NumberToWordConverter.toHindi(15), 'पंद्रह');
    });

    test('Hundreds and Thousands', () {
      expect(NumberToWordConverter.toHindi(100), 'एक सौ');
      expect(NumberToWordConverter.toHindi(1234), 'एक हजार दो सौ चौंतीस');
      expect(NumberToWordConverter.toHindi(9999), 'नौ हजार नौ सौ निन्यान्वे');
    });

    test('Lakhs and Crores (Indian grouping)', () {
      expect(NumberToWordConverter.toHindi(100000), 'एक लाख');
      expect(NumberToWordConverter.toHindi(10000000), 'एक करोड़');
      expect(NumberToWordConverter.toHindi(12345678), 'एक करोड़ तेईस लाख पैंतालीस हजार छह सौ अठहत्तर');
      expect(NumberToWordConverter.toHindi(999999999), 'निन्यान्वे करोड़ निन्यान्वे लाख निन्यान्वे हजार नौ सौ निन्यान्वे');
    });

    test('Negative numbers', () {
      expect(NumberToWordConverter.toHindi(-56), 'ऋण छप्पन');
    });
  });

  group('NumberToWordConverter Bengali tests', () {
    test('Zero and small digits', () {
      expect(NumberToWordConverter.toBengali(0), 'শূন্য');
      expect(NumberToWordConverter.toBengali(1), 'এক');
      expect(NumberToWordConverter.toBengali(9), 'নয়');
      expect(NumberToWordConverter.toBengali(15), 'পনেরো');
    });

    test('Hundreds and Thousands', () {
      expect(NumberToWordConverter.toBengali(100), 'একশত');
      expect(NumberToWordConverter.toBengali(1234), 'এক হাজার দুইশত চৌত্রিশ');
      expect(NumberToWordConverter.toBengali(9999), 'নয় হাজার নয়শত নিরানব্বই');
    });

    test('Lakhs and Crores (Indian grouping)', () {
      expect(NumberToWordConverter.toBengali(100000), 'এক লক্ষ');
      expect(NumberToWordConverter.toBengali(10000000), 'এক কোটি');
      expect(NumberToWordConverter.toBengali(12345678), 'এক কোটি তেইশ লক্ষ পঁয়তাল্লিশ হাজার ছয়শত আটাত্তর');
    });

    test('Negative numbers', () {
      expect(NumberToWordConverter.toBengali(-88), 'ঋণাত্মক আটাশি');
    });
  });
}

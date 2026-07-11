import 'package:shared_preferences/shared_preferences.dart';

class UnitPreferenceService {
  Future<String?> getLastUnitA(String category) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('last_unit_a_$category');
    } catch (_) {
      return null;
    }
  }

  Future<String?> getLastUnitB(String category) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('last_unit_b_$category');
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLastUnits(String category, String unitA, String unitB) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_unit_a_$category', unitA);
      await prefs.setString('last_unit_b_$category', unitB);
    } catch (_) {}
  }
}

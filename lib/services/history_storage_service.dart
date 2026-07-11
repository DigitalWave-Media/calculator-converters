import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_entry.dart';

class HistoryStorageService {
  static const String _key = 'calc_history';

  Future<List<HistoryEntry>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_key) ?? [];
      return list
          .map((item) => HistoryEntry.fromJson(json.decode(item) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveHistory(List<HistoryEntry> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = history.map((item) => json.encode(item.toJson())).toList();
      await prefs.setStringList(_key, list);
    } catch (_) {}
  }

  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (_) {}
  }
}

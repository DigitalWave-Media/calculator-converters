import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/currency_option.dart';

class CurrencyFetchResult {
  final List<CurrencyOption> rates;
  final bool isLive;
  final DateTime? cacheTimestamp;

  const CurrencyFetchResult({
    required this.rates,
    required this.isLive,
    this.cacheTimestamp,
  });
}

class CurrencyRateService {
  final Dio _dio = Dio();
  static const String _ratesCacheKey = 'currency_rates_cache';
  static const String _timestampCacheKey = 'currency_rates_timestamp';

  static const Map<String, String> _currencyNames = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'INR': 'Indian Rupee',
    'JPY': 'Japanese Yen',
    'CAD': 'Canadian Dollar',
    'AUD': 'Australian Dollar',
    'CHF': 'Swiss Franc',
    'CNY': 'Chinese Yuan',
    'SGD': 'Singapore Dollar',
    'NZD': 'New Zealand Dollar',
    'HKD': 'Hong Kong Dollar',
    'AED': 'UAE Dirham',
    'SAR': 'Saudi Riyal',
    'ZAR': 'South African Rand',
  };

  static final List<CurrencyOption> defaultRates = [
    const CurrencyOption(name: 'US Dollar', isoCode: 'USD', rate: 1.0),
    const CurrencyOption(name: 'Euro', isoCode: 'EUR', rate: 0.92),
    const CurrencyOption(name: 'British Pound', isoCode: 'GBP', rate: 0.78),
    const CurrencyOption(name: 'Indian Rupee', isoCode: 'INR', rate: 83.50),
    const CurrencyOption(name: 'Japanese Yen', isoCode: 'JPY', rate: 161.00),
    const CurrencyOption(name: 'Canadian Dollar', isoCode: 'CAD', rate: 1.36),
    const CurrencyOption(name: 'Australian Dollar', isoCode: 'AUD', rate: 1.49),
    const CurrencyOption(name: 'Swiss Franc', isoCode: 'CHF', rate: 0.89),
    const CurrencyOption(name: 'Chinese Yuan', isoCode: 'CNY', rate: 7.28),
    const CurrencyOption(name: 'Singapore Dollar', isoCode: 'SGD', rate: 1.35),
  ];

  Future<CurrencyFetchResult> fetchRates() async {
    try {
      final response = await _dio.get('https://open.er-api.com/v6/latest/USD');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        final Map<String, dynamic> rates = data['rates'] as Map<String, dynamic>;
        
        final List<CurrencyOption> fetchedList = [];
        // Extract only currencies we support/have names for, or dynamically include them
        rates.forEach((key, value) {
          final String name = _currencyNames[key] ?? '$key Currency';
          final double rate = (value as num).toDouble();
          fetchedList.add(CurrencyOption(name: name, isoCode: key, rate: rate));
        });

        // Save to cache
        if (fetchedList.isNotEmpty) {
          await _saveToCache(fetchedList);
          return CurrencyFetchResult(rates: fetchedList, isLive: true);
        }
      }
    } catch (e, st) {
      debugPrint('CurrencyRateService.fetchRates failed: $e\n$st');
    }

    // Fallback to cache or defaults
    final cached = await _loadFromCache();
    final timestamp = await _getCacheTimestamp();
    return CurrencyFetchResult(
      rates: cached,
      isLive: false,
      cacheTimestamp: timestamp,
    );
  }

  Future<void> _saveToCache(List<CurrencyOption> list) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonStr = json.encode(list.map((item) => item.toJson()).toList());
      await prefs.setString(_ratesCacheKey, jsonStr);
      await prefs.setInt(_timestampCacheKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e, st) {
      debugPrint('CurrencyRateService._saveToCache failed: $e\n$st');
    }
  }

  Future<List<CurrencyOption>> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonStr = prefs.getString(_ratesCacheKey);
      if (jsonStr != null) {
        final List<dynamic> decoded = json.decode(jsonStr) as List<dynamic>;
        return decoded
            .map((item) => CurrencyOption.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e, st) {
      debugPrint('CurrencyRateService._loadFromCache failed: $e\n$st');
    }
    return defaultRates;
  }

  Future<DateTime?> _getCacheTimestamp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? ms = prefs.getInt(_timestampCacheKey);
      if (ms != null) {
        return DateTime.fromMillisecondsSinceEpoch(ms);
      }
    } catch (e, st) {
      debugPrint('CurrencyRateService._getCacheTimestamp failed: $e\n$st');
    }
    return null;
  }
}

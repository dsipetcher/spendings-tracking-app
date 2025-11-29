import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/settings/application/settings_controller.dart';

class ExchangeRatesData {
  ExchangeRatesData({
    required this.baseCurrency,
    required this.rates,
    required this.updatedAt,
  });

  final String baseCurrency;
  final Map<String, double> rates;
  final DateTime updatedAt;
}

class ExchangeRateService {
  ExchangeRateService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  Future<Map<String, double>> fetchRates(String baseCurrency) async {
    final uri = Uri.https(
      'api.exchangerate.host',
      '/latest',
      {'base': baseCurrency},
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Exchange rate request failed: ${response.statusCode}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final rates = body['rates'] as Map<String, dynamic>;
    return rates.map(
      (key, value) => MapEntry(key.toUpperCase(), (value as num).toDouble()),
    );
  }
}

class ExchangeRateRepository {
  ExchangeRateRepository({ExchangeRateService? service})
      : _service = service ?? ExchangeRateService();

  final ExchangeRateService _service;
  static const _cachePrefix = 'exchange_rates_';
  static const _ttl = Duration(hours: 12);

  Future<ExchangeRatesData> getRates(String baseCurrency) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cachePrefix$baseCurrency';
    final tsKey = '${cacheKey}_ts';

    final cachedJson = prefs.getString(cacheKey);
    final cachedTs = prefs.getInt(tsKey);
    if (cachedJson != null && cachedTs != null) {
      final updatedAt = DateTime.fromMillisecondsSinceEpoch(cachedTs);
      if (DateTime.now().difference(updatedAt) < _ttl) {
        final rates = Map<String, double>.from(
          (jsonDecode(cachedJson) as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, (value as num).toDouble())),
        );
        return ExchangeRatesData(
          baseCurrency: baseCurrency,
          rates: rates,
          updatedAt: updatedAt,
        );
      }
    }

    final fetchedRates = await _service.fetchRates(baseCurrency);
    final now = DateTime.now();
    final normalized = jsonEncode(fetchedRates);
    await prefs.setString(cacheKey, normalized);
    await prefs.setInt(tsKey, now.millisecondsSinceEpoch);
    return ExchangeRatesData(
      baseCurrency: baseCurrency,
      rates: fetchedRates,
      updatedAt: now,
    );
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys =
        prefs.getKeys().where((key) => key.startsWith(_cachePrefix)).toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}

final exchangeRateRepositoryProvider = Provider<ExchangeRateRepository>(
  (ref) => ExchangeRateRepository(),
);

final exchangeRatesProvider = FutureProvider<ExchangeRatesData>((ref) async {
  final settings = ref.watch(settingsControllerProvider);
  final repository = ref.watch(exchangeRateRepositoryProvider);
  return repository.getRates(settings.baseCurrency);
});

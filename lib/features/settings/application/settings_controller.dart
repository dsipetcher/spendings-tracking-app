import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>(
  (ref) => SettingsController(),
);

class SettingsState {
  const SettingsState({
    this.storeOriginalImages = true,
    this.baseCurrency = 'USD',
    this.personalCurrency = 'USD',
  });

  final bool storeOriginalImages;
  final String baseCurrency;
  final String personalCurrency;

  SettingsState copyWith({
    bool? storeOriginalImages,
    String? baseCurrency,
    String? personalCurrency,
  }) =>
      SettingsState(
        storeOriginalImages: storeOriginalImages ?? this.storeOriginalImages,
        baseCurrency: baseCurrency ?? this.baseCurrency,
        personalCurrency: personalCurrency ?? this.personalCurrency,
      );
}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(const SettingsState()) {
    _load();
  }

  static const _storeImagesKey = 'store_original_images';
  static const _baseCurrencyKey = 'base_currency';
  static const _personalCurrencyKey = 'personal_currency';
  SharedPreferences? _prefs;

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storeImagesValue = prefs.getBool(_storeImagesKey);
      final baseCurrency = prefs.getString(_baseCurrencyKey);
      final personalCurrency = prefs.getString(_personalCurrencyKey);
      _prefs = prefs;
      state = state.copyWith(
        storeOriginalImages: storeImagesValue ?? state.storeOriginalImages,
        baseCurrency: baseCurrency ?? state.baseCurrency,
        personalCurrency: personalCurrency ?? state.personalCurrency,
      );
    } catch (e, stackTrace) {
      // Если SharedPreferences недоступен, используем значения по умолчанию
      // Это может произойти при первом запуске или если платформа ещё не инициализирована
      // Значения по умолчанию уже установлены в конструкторе
      if (kDebugMode) {
        debugPrint('⚠️ Failed to load settings from SharedPreferences: $e');
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }

  Future<void> setStoreOriginalImages(bool value) async {
    state = state.copyWith(storeOriginalImages: value);
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setBool(_storeImagesKey, value);
      _prefs = prefs;
    } catch (e) {
      // Игнорируем ошибки сохранения, состояние уже обновлено
    }
  }

  Future<void> setBaseCurrency(String value) async {
    final normalized = (value == 'EUR') ? 'EUR' : 'USD';
    state = state.copyWith(baseCurrency: normalized);
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setString(_baseCurrencyKey, normalized);
      _prefs = prefs;
    } catch (e) {
      // Игнорируем ошибки сохранения, состояние уже обновлено
    }
  }

  Future<void> setPersonalCurrency(String value) async {
    state = state.copyWith(personalCurrency: value.toUpperCase());
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setString(_personalCurrencyKey, value.toUpperCase());
      _prefs = prefs;
    } catch (e) {
      // Игнорируем ошибки сохранения, состояние уже обновлено
    }
  }
}

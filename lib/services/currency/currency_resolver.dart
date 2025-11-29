class CurrencyResolver {
  const CurrencyResolver._();

  static const _languageToCurrency = {
    'ru': 'RUB',
    'en': 'USD',
    'fr': 'EUR',
    'de': 'EUR',
    'es': 'EUR',
    'pt': 'EUR',
    'it': 'EUR',
    'kk': 'KZT',
    'hy': 'AMD',
    'uk': 'UAH',
    'pl': 'PLN',
    'tr': 'TRY',
    'zh': 'CNY',
    'ja': 'JPY',
  };

  static String resolveCurrency({
    required String? sourceLanguageCode,
    String? detectedCurrencySymbol,
  }) {
    final symbolCurrency = _symbolToCurrency(detectedCurrencySymbol);
    if (symbolCurrency != null) return symbolCurrency;

    final language =
        sourceLanguageCode?.split(RegExp('[-_]')).first.toLowerCase();
    if (language != null && _languageToCurrency.containsKey(language)) {
      return _languageToCurrency[language]!;
    }
    return 'USD';
  }

  static String? _symbolToCurrency(String? symbol) {
    if (symbol == null) return null;
    switch (symbol) {
      case r'$':
        return 'USD';
      case '€':
        return 'EUR';
      case '£':
        return 'GBP';
      case '₽':
        return 'RUB';
      case '₸':
        return 'KZT';
      case '֏':
        return 'AMD';
      case '¥':
        return 'JPY';
      default:
        return null;
    }
  }
}

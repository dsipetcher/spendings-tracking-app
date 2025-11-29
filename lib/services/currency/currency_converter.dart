import '../../features/settings/application/settings_controller.dart';
import 'exchange_rate_service.dart';

double? convertCurrency({
  required double amount,
  required String from,
  required String to,
  required ExchangeRatesData ratesData,
}) {
  final base = ratesData.baseCurrency;
  final normalizedFrom = from.toUpperCase();
  final normalizedTo = to.toUpperCase();
  final rates = ratesData.rates;

  double amountInBase;
  if (normalizedFrom == base) {
    amountInBase = amount;
  } else {
    final rateFrom = rates[normalizedFrom];
    if (rateFrom == null || rateFrom == 0) return null;
    amountInBase = amount / rateFrom;
  }

  if (normalizedTo == base) return amountInBase;
  final rateTo = rates[normalizedTo];
  if (rateTo == null) return null;
  return amountInBase * rateTo;
}

class CurrencyDisplayValues {
  CurrencyDisplayValues({
    required this.originalAmount,
    required this.originalCurrency,
    required this.baseCurrency,
    required this.personalCurrency,
    this.baseAmount,
    this.personalAmount,
  });

  final double originalAmount;
  final String originalCurrency;
  final String baseCurrency;
  final String personalCurrency;
  final double? baseAmount;
  final double? personalAmount;
}

CurrencyDisplayValues buildCurrencyDisplay({
  required double amount,
  required String currency,
  required ExchangeRatesData ratesData,
  required SettingsState settings,
}) {
  final base = settings.baseCurrency;
  final personal = settings.personalCurrency;

  final baseAmount = convertCurrency(
    amount: amount,
    from: currency,
    to: base,
    ratesData: ratesData,
  );
  final personalAmount = convertCurrency(
    amount: amount,
    from: currency,
    to: personal,
    ratesData: ratesData,
  );

  return CurrencyDisplayValues(
    originalAmount: amount,
    originalCurrency: currency,
    baseCurrency: base,
    personalCurrency: personal,
    baseAmount: baseAmount,
    personalAmount: personalAmount,
  );
}

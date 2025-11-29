import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../features/receipts/domain/models/receipt_models.dart';
import 'cloud_translation_service.dart';

class ReceiptCaptureService {
  ReceiptCaptureService({
    TextRecognizer? textRecognizer,
    LanguageIdentifier? languageIdentifier,
    CloudTranslationService? cloudTranslationService,
  })  : _textRecognizer = textRecognizer ??
            TextRecognizer(script: TextRecognitionScript.latin),
        _languageIdentifier =
            languageIdentifier ?? LanguageIdentifier(confidenceThreshold: 0.5),
        _cloudTranslator = cloudTranslationService ?? CloudTranslationService();

  final TextRecognizer _textRecognizer;
  final LanguageIdentifier _languageIdentifier;
  final CloudTranslationService _cloudTranslator;
  final CategoryEngine _categoryEngine = CategoryEngine();
  final Uuid _uuid = const Uuid();

  Future<ReceiptDraft> fromImage(
    XFile file, {
    String targetLocale = 'en',
  }) async {
    final inputImage = InputImage.fromFilePath(file.path);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    final rawText = recognizedText.text;
    if (kDebugMode) {
      debugPrint('🧾 OCR raw text (${rawText.length} chars):\n$rawText');
    }
    final sourceLanguage = await _detectLanguage(rawText);
    final store = _parseStore(recognizedText);
    final date = _parseDate(rawText) ?? DateTime.now();
    final items = _parseLineItems(recognizedText);
    final totals = _extractTotals(recognizedText, items);

    final translatedItems = await _translateItems(
      items,
      sourceLanguage: sourceLanguage,
      targetLocale: targetLocale,
    );

    final categorizedItems = translatedItems
        .map((item) => item.copyWith(category: _categoryEngine.classify(item)))
        .toList();

    final subtotal = totals.subtotal ?? _computeSubtotal(categorizedItems);
    final total = totals.total ?? subtotal;

    return ReceiptDraft(
      store: store,
      createdAt: date,
      items: categorizedItems,
      currency: totals.currency ?? 'USD',
      subtotal: subtotal,
      tax: totals.tax,
      serviceFee: totals.serviceFee,
      total: total,
      paymentMethod: totals.paymentMethod,
      sourceLanguage: sourceLanguage,
      translatedLanguage: targetLocale,
      requiresReview: categorizedItems.isEmpty ||
          categorizedItems.any((item) => item.confidence < 0.6),
      rawText: rawText,
    );
  }

  Future<ReceiptDraft> demo({String targetLocale = 'en'}) async {
    final payload =
        await rootBundle.loadString('assets/demo/sample_receipt.json');
    final json = jsonDecode(payload) as Map<String, dynamic>;
    final items = (json['items'] as List)
        .map(
          (raw) => LineItem(
            id: _uuid.v4(),
            name: raw['name'] as String,
            translatedName: raw['translatedName'] as String?,
            quantity: (raw['qty'] as num).toDouble(),
            unitPrice: (raw['price'] as num).toDouble(),
          ),
        )
        .toList();

    final translatedItems = await _translateItems(
      items,
      sourceLanguage: 'ru',
      targetLocale: targetLocale,
    );

    final categorizedItems = translatedItems
        .map((item) => item.copyWith(category: _categoryEngine.classify(item)))
        .toList();

    return ReceiptDraft(
      store: StoreInfo(
        name: (json['store'] as Map<String, dynamic>)['name'] as String,
        address: (json['store'] as Map<String, dynamic>)['address'] as String?,
        city: (json['store'] as Map<String, dynamic>)['city'] as String?,
        country: (json['store'] as Map<String, dynamic>)['country'] as String?,
      ),
      createdAt: DateTime.tryParse(json['date'] as String),
      currency: json['currency'] as String? ?? 'USD',
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      serviceFee: (json['serviceFee'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      items: categorizedItems,
      sourceLanguage: 'ru',
      translatedLanguage: targetLocale,
      rawText: payload,
    );
  }

  Future<String?> _detectLanguage(String text) async {
    try {
      final code = await _languageIdentifier.identifyLanguage(text);
      if (code == 'und') return null;
      return code;
    } catch (_) {
      return null;
    }
  }

  Future<List<LineItem>> _translateItems(
    List<LineItem> items, {
    required String? sourceLanguage,
    required String targetLocale,
  }) async {
    final source = _translateLanguageFromCode(sourceLanguage);
    final target = _translateLanguageFromCode(targetLocale);
    if (source != null && target != null && source != target) {
      return _translateOnDevice(items, source, target);
    }

    if (_cloudTranslator.isEnabled) {
      try {
        final translations = await _cloudTranslator.translate(
          items.map((e) => e.name).toList(),
          targetLanguage: _normalizeLanguageCode(targetLocale),
          sourceLanguage: sourceLanguage != null
              ? _normalizeLanguageCode(sourceLanguage)
              : null,
        );
        return [
          for (var i = 0; i < items.length; i++)
            items[i].copyWith(translatedName: translations[i]),
        ];
      } catch (error, stackTrace) {
        if (kDebugMode) {
          debugPrint('⚠️ Cloud translation failed: $error\n$stackTrace');
        }
      }
    } else if (kDebugMode) {
      debugPrint(
        '⚠️ Translation skipped (lang not supported on-device and TRANSLATE_API_KEY missing).',
      );
    }

    return items;
  }

  StoreInfo _parseStore(RecognizedText recognizedText) {
    final firstBlock = recognizedText.blocks.firstOrNull;
    final fallbackName = firstBlock?.text.split('\n').first.trim();
    final address = firstBlock?.text
        .split('\n')
        .skip(1)
        .take(2)
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .join(', ');
    return StoreInfo(
      name: (fallbackName == null || fallbackName.isEmpty)
          ? 'Unknown merchant'
          : fallbackName,
      address: address?.isEmpty ?? true ? null : address,
    );
  }

  List<LineItem> _parseLineItems(RecognizedText text) {
    final totalsKeywords = [
      'total',
      'итог',
      'итого',
      'sum',
      'amount',
      'ընդամենը'
    ];
    final lines = text.blocks
        .expand((block) => block.lines)
        .map((line) => line.text.replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((line) => line.isNotEmpty)
        .toList();

    final items = <LineItem>[];
    String? pendingName;
    for (final rawLine in lines) {
      final line = rawLine;
      final lower = line.toLowerCase();
      if (totalsKeywords.any(lower.contains)) continue;

      final amountMatch = _findTrailingAmount(line);
      if (_containsLetters(line)) {
        pendingName = line;
      }

      if (amountMatch != null) {
        final prefix = line.substring(0, amountMatch.start).trim();
        final extractedName =
            _containsLetters(prefix) ? prefix : pendingName ?? prefix;
        final name = (extractedName?.isNotEmpty ?? false)
            ? extractedName!
            : 'Item ${items.length + 1}';
        final quantity = _extractQuantity(prefix) ?? 1;
        final unitPrice = quantity == 0
            ? amountMatch.value
            : double.parse((amountMatch.value / quantity).toStringAsFixed(2));

        items.add(
          LineItem(
            id: _uuid.v4(),
            name: name,
            quantity: quantity,
            unitPrice: unitPrice,
            confidence: _containsLetters(name) ? 0.75 : 0.4,
          ),
        );
        pendingName = null;
      }
    }

    if (kDebugMode) {
      debugPrint('ℹ️ Parsed ${items.length} candidate items from OCR output.');
      for (final item in items) {
        debugPrint(' • ${item.quantity}× ${item.name} = ${item.unitPrice}');
      }
    }

    return items;
  }

  _TotalsResult _extractTotals(RecognizedText text, List<LineItem> items) {
    double? subtotal = items.isEmpty
        ? null
        : items.fold<double>(
            0,
            (value, item) => value + (item.unitPrice * item.quantity),
          );
    double? total;
    double? tax;
    double? serviceFee;
    String? currency;
    String? paymentMethod;

    final lines = text.text.split('\n');
    for (final line in lines) {
      final normalized = line.toLowerCase();
      currency ??= _detectCurrency(line);
      if (normalized.contains('tax') ||
          normalized.contains('nds') ||
          normalized.contains('vat') ||
          normalized.contains('налог')) {
        tax ??= _parseAmount(line);
      } else if (normalized.contains('service') ||
          normalized.contains('tip') ||
          normalized.contains('fee')) {
        serviceFee ??= _parseAmount(line);
      } else if (normalized.contains('subtotal') ||
          normalized.contains('sub total') ||
          normalized.contains('sum')) {
        subtotal ??= _parseAmount(line);
      } else if (normalized.contains('total') ||
          normalized.contains('amount due') ||
          normalized.contains('итого')) {
        total ??= _parseAmount(line);
      }

      paymentMethod ??= _detectPaymentMethod(normalized);
    }

    return _TotalsResult(
      subtotal: subtotal,
      total: total,
      tax: tax,
      serviceFee: serviceFee,
      currency: currency,
      paymentMethod: paymentMethod,
    );
  }

  double _computeSubtotal(List<LineItem> items) => items.fold<double>(
        0,
        (value, item) => value + (item.unitPrice * item.quantity),
      );

  _AmountMatch? _findTrailingAmount(String line) {
    final normalized = line.replaceAll(',', '.');
    final match =
        RegExp(r'(-?\d[\d\s]*\.\d{1,2})\s*$').firstMatch(normalized) ??
            RegExp(r'(-?\d+)\s*$').firstMatch(normalized);
    if (match == null) return null;
    final value = double.tryParse(match.group(1)!.replaceAll(' ', ''));
    if (value == null) return null;
    return _AmountMatch(value, match.start);
  }

  double? _extractQuantity(String text) {
    final match = RegExp(r'^(\d+(?:[.,]\d+)?)\s*[x×]').firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1)!.replaceAll(',', '.'));
    }
    return null;
  }

  bool _containsLetters(String text) =>
      RegExp(r'[A-Za-zА-Яа-я\u0400-\u04FF\u0530-\u058F]').hasMatch(text);

  double? _parseAmount(String input) {
    final match =
        RegExp(r'(-?\d+([.,]\d{1,2})?)').firstMatch(input.replaceAll(',', '.'));
    if (match == null) return null;
    return double.tryParse(match.group(1)!.replaceAll(',', '.'));
  }

  DateTime? _parseDate(String text) {
    final clean = text.replaceAll('\n', ' ');
    final match =
        RegExp(r'(\d{1,2}[./-]\d{1,2}[./-]\d{2,4})').firstMatch(clean);
    if (match == null) return null;
    final raw = match.group(1)!;
    final parts = raw.split(RegExp(r'[./-]'));
    if (parts.length < 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year =
        int.tryParse(parts[2].length == 2 ? '20${parts[2]}' : parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  String? _detectCurrency(String line) {
    final normalized = line.toUpperCase();
    if (normalized.contains('USD') || normalized.contains(r'$')) return 'USD';
    if (normalized.contains('EUR') || normalized.contains('€')) return 'EUR';
    if (normalized.contains('KZT')) return 'KZT';
    if (normalized.contains('RUB') || normalized.contains('₽')) return 'RUB';
    if (normalized.contains('GBP') || normalized.contains('£')) return 'GBP';
    return null;
  }

  String? _detectPaymentMethod(String line) {
    if (line.contains('visa')) return 'Visa';
    if (line.contains('mastercard') || line.contains('mc')) return 'Mastercard';
    if (line.contains('cash')) return 'Cash';
    if (line.contains('apple pay')) return 'Apple Pay';
    if (line.contains('google pay')) return 'Google Pay';
    return null;
  }

  TranslateLanguage? _translateLanguageFromCode(String? code) {
    if (code == null) return null;
    switch (code.substring(0, 2).toLowerCase()) {
      case 'en':
        return TranslateLanguage.english;
      case 'ru':
        return TranslateLanguage.russian;
      case 'es':
        return TranslateLanguage.spanish;
      case 'de':
        return TranslateLanguage.german;
      case 'fr':
        return TranslateLanguage.french;
      case 'it':
        return TranslateLanguage.italian;
      case 'pt':
        return TranslateLanguage.portuguese;
      case 'tr':
        return TranslateLanguage.turkish;
      default:
        return null;
    }
  }

  Future<void> dispose() async {
    await _textRecognizer.close();
    await _languageIdentifier.close();
    await _cloudTranslator.close();
  }

  Future<List<LineItem>> _translateOnDevice(
    List<LineItem> items,
    TranslateLanguage source,
    TranslateLanguage target,
  ) async {
    final translator = OnDeviceTranslator(
      sourceLanguage: source,
      targetLanguage: target,
    );

    try {
      final translated = <LineItem>[];
      for (final item in items) {
        final translatedName = await translator.translateText(item.name);
        translated.add(
          item.copyWith(translatedName: translatedName),
        );
      }
      return translated;
    } finally {
      await translator.close();
    }
  }

  String _normalizeLanguageCode(String code) =>
      code.split(RegExp('[-_]')).first.toLowerCase();
}

class _AmountMatch {
  _AmountMatch(this.value, this.start);

  final double value;
  final int start;
}

class _TotalsResult {
  _TotalsResult({
    required this.subtotal,
    required this.total,
    required this.tax,
    required this.serviceFee,
    required this.currency,
    required this.paymentMethod,
  });

  final double? subtotal;
  final double? total;
  final double? tax;
  final double? serviceFee;
  final String? currency;
  final String? paymentMethod;
}

class CategoryEngine {
  SpendingCategory classify(LineItem item) {
    final text = item.name.toLowerCase();
    if (text.contains('coffee') ||
        text.contains('pizza') ||
        text.contains('bread')) {
      return SpendingCategory.dining;
    }
    if (text.contains('salary') || text.contains('payroll')) {
      return SpendingCategory.salary;
    }
    if (text.contains('electric') || text.contains('energy')) {
      return SpendingCategory.utilities;
    }
    if (text.contains('spinach') ||
        text.contains('organic') ||
        text.contains('apple')) {
      return SpendingCategory.groceries;
    }
    if (text.contains('soap') || text.contains('tabs')) {
      return SpendingCategory.household;
    }
    if (text.contains('uber') || text.contains('taxi')) {
      return SpendingCategory.transport;
    }
    return SpendingCategory.other;
  }
}

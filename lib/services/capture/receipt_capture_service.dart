import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../features/receipts/domain/models/receipt_models.dart';

class ReceiptCaptureService {
  ReceiptCaptureService({
    ReceiptOcrEngine? ocrEngine,
    TranslationService? translationService,
    CategoryEngine? categoryEngine,
  })  : _ocrEngine = ocrEngine ?? MockReceiptOcrEngine(),
        _translationService = translationService ?? TranslationService(),
        _categoryEngine = categoryEngine ?? CategoryEngine();

  final ReceiptOcrEngine _ocrEngine;
  final TranslationService _translationService;
  final CategoryEngine _categoryEngine;

  Future<ReceiptDraft> fromImage(XFile file,
      {String targetLocale = 'en'}) async {
    final draft = await _ocrEngine.extractDraft(file);
    return _postProcessDraft(draft, targetLocale: targetLocale);
  }

  Future<ReceiptDraft> demo({String targetLocale = 'en'}) async {
    final draft = await _ocrEngine.extractDemo();
    return _postProcessDraft(draft, targetLocale: targetLocale);
  }

  Future<ReceiptDraft> _postProcessDraft(
    ReceiptDraft draft, {
    required String targetLocale,
  }) async {
    final translatedItems = await _translationService.translateItems(
      draft.items,
      targetLocale: targetLocale,
    );
    final categorizedItems = translatedItems
        .map((item) => item.copyWith(category: _categoryEngine.classify(item)))
        .toList();

    return draft.copyWith(
      items: categorizedItems,
      translatedLanguage: targetLocale,
      requiresReview: categorizedItems.any((item) => item.confidence < 0.7),
    );
  }
}

abstract class ReceiptOcrEngine {
  Future<ReceiptDraft> extractDraft(XFile file);
  Future<ReceiptDraft> extractDemo();
}

class MockReceiptOcrEngine implements ReceiptOcrEngine {
  final Uuid _uuid = const Uuid();

  @override
  Future<ReceiptDraft> extractDraft(XFile file) async {
    // In the MVP we fall back to a mocked payload that imitates OCR output.
    return extractDemo();
  }

  @override
  Future<ReceiptDraft> extractDemo() async {
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
      items: items,
      sourceLanguage: 'ru',
      translatedLanguage: 'en',
    );
  }
}

class TranslationService {
  Future<List<LineItem>> translateItems(
    List<LineItem> items, {
    required String targetLocale,
  }) async {
    // Placeholder translation implementation.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return items
        .map(
          (item) => item.copyWith(
            translatedName: item.translatedName ?? item.name,
          ),
        )
        .toList(growable: false);
  }
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
    return SpendingCategory.other;
  }
}

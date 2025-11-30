import 'dart:math';
import 'package:uuid/uuid.dart';
import '../../features/receipts/domain/models/receipt_models.dart';
import '../currency/currency_resolver.dart';

/// Универсальный парсер чеков для всех языков и стран
/// Использует паттерны и эвристики для извлечения данных
class ReceiptParser {
  static const _uuid = Uuid();

  /// Парсит текст чека и возвращает ReceiptDraft
  ReceiptDraft parseReceiptText({
    required String text,
    String? imagePath,
    String? detectedLanguage,
  }) {
    // Нормализуем текст: заменяем множественные пробелы и переносы
    final normalizedText = text
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'\n\s*\n'), '\n');
    
    // Разбиваем на строки, сохраняя все непустые
    final lines = normalizedText
        .split(RegExp(r'[\n\r]+'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    
    if (lines.isEmpty) {
      return _createEmptyDraft(imagePath: imagePath, rawText: text);
    }

    // Определяем язык и валюту
    final language = detectedLanguage ?? _detectLanguage(text);
    final currency = CurrencyResolver.resolveCurrency(
      sourceLanguageCode: language,
      detectedCurrencySymbol: _extractCurrencySymbol(text),
    );

    // Извлекаем данные
    final store = _extractStoreInfo(lines, language);
    final date = _extractDate(lines, language);
    final total = _extractTotal(lines, language, currency);
    final subtotal = _extractSubtotal(lines, language, currency, total);
    final tax = _extractTax(lines, language, currency);
    final serviceFee = _extractServiceFee(lines, language, currency);
    // discount извлекается, но пока не используется в логике
    _extractDiscount(lines, language, currency);
    final items = _extractItems(lines, language, currency);
    final paymentMethod = _extractPaymentMethod(lines, language);

    // Определяем, требуется ли проверка
    final requiresReview = _shouldRequireReview(
      items: items,
      total: total,
      subtotal: subtotal,
      tax: tax,
    );

    return ReceiptDraft(
      store: store,
      createdAt: date ?? DateTime.now(),
      items: items,
      currency: currency,
      flowType: MoneyFlowType.expense,
      subtotal: subtotal ?? total,
      tax: tax,
      serviceFee: serviceFee,
      total: total,
      paymentMethod: paymentMethod,
      sourceLanguage: language,
      sourceImagePath: imagePath,
      rawText: text,
      requiresReview: requiresReview,
    );
  }

  ReceiptDraft _createEmptyDraft({String? imagePath, String? rawText}) {
    return ReceiptDraft(
      currency: 'USD',
      flowType: MoneyFlowType.expense,
      createdAt: DateTime.now(),
      items: const [],
      sourceImagePath: imagePath,
      rawText: rawText,
      requiresReview: true,
    );
  }

  /// Определяет язык текста на основе Unicode диапазонов
  String? _detectLanguage(String text) {
    // Проверяем различные алфавиты по приоритету
    final patterns = {
      'hy': RegExp(r'[\u0530-\u058F]'), // Армянский
      'ru': RegExp(r'[А-Яа-яЁё]'), // Кириллица (русский)
      'zh': RegExp(r'[\u4e00-\u9fff]'), // Китайский
      'ja': RegExp(r'[\u3040-\u309F\u30A0-\u30FF]'), // Японский
      'ar': RegExp(r'[\u0600-\u06FF]'), // Арабский
      'he': RegExp(r'[\u0590-\u05FF]'), // Иврит
      'th': RegExp(r'[\u0E00-\u0E7F]'), // Тайский
      'ko': RegExp(r'[\uAC00-\uD7AF]'), // Корейский
      'el': RegExp(r'[\u0370-\u03FF]'), // Греческий
    };

    // Проверяем в порядке приоритета
    for (final entry in patterns.entries) {
      if (entry.value.hasMatch(text)) {
        return entry.key;
      }
    }
    
    // Если найдены только латинские символы, пытаемся определить язык по ключевым словам
    final latinOnly = RegExp(r'^[a-zA-Z0-9\s\.,;:!?\-\(\)]+$').hasMatch(text);
    if (latinOnly) {
      return _detectLanguageByKeywords(text);
    }
    
    // По умолчанию английский
    return 'en';
  }
  
  /// Определяет язык по ключевым словам (для латинского текста)
  String? _detectLanguageByKeywords(String text) {
    final lower = text.toLowerCase();
    
    // Немецкий
    if (RegExp(r'\b(der|die|das|und|ist|sind|waren|gesamt|summe)\b').hasMatch(lower)) {
      return 'de';
    }
    // Французский
    if (RegExp(r'\b(le|la|les|et|est|sont|total|montant)\b').hasMatch(lower)) {
      return 'fr';
    }
    // Испанский
    if (RegExp(r'\b(el|la|los|y|es|son|total|importe)\b').hasMatch(lower)) {
      return 'es';
    }
    // Итальянский
    if (RegExp(r'\b(il|la|gli|e|è|sono|totale|importo)\b').hasMatch(lower)) {
      return 'it';
    }
    // Португальский
    if (RegExp(r'\b(o|a|os|e|é|são|total|valor)\b').hasMatch(lower)) {
      return 'pt';
    }
    
    return 'en';
  }

  /// Извлекает символ валюты из текста
  String? _extractCurrencySymbol(String text) {
    final currencySymbols = [r'$', '€', '£', '₽', '₸', '֏', '¥', '₹', '₴'];
    for (final symbol in currencySymbols) {
      if (text.contains(symbol)) return symbol;
    }
    return null;
  }

  /// Извлекает информацию о магазине
  StoreInfo? _extractStoreInfo(List<String> lines, String? language) {
    if (lines.isEmpty) return null;

    // Обычно название магазина в первых строках
    String? name;
    String? address;
    String? city;
    String? country;

    // Ищем название магазина (обычно первая или вторая строка)
    for (int i = 0; i < min(5, lines.length); i++) {
      final line = lines[i].trim();
      if (line.length > 3 && line.length < 100 && !_isNumericLine(line)) {
        if (name == null) {
          name = line;
        } else if (address == null && _looksLikeAddress(line)) {
          address = line;
        }
      }
    }

    // Если не нашли название, используем первую строку
    name ??= lines.first.trim();

    return StoreInfo(
      name: name,
      address: address,
      city: city,
      country: country,
    );
  }

  bool _isNumericLine(String line) {
    // Проверяем, является ли строка в основном числами
    final numbers = RegExp(r'[\d.,\s]+').allMatches(line).fold<int>(
      0,
      (sum, match) => sum + match.group(0)!.length,
    );
    return numbers > line.length * 0.7;
  }

  bool _looksLikeAddress(String line) {
    final addressKeywords = [
      'street', 'st', 'avenue', 'ave', 'road', 'rd', 'boulevard', 'blvd',
      'улица', 'ул', 'проспект', 'пр', 'переулок', 'пер',
      'straße', 'str', 'platz', 'weg',
    ];
    final lower = line.toLowerCase();
    return addressKeywords.any((keyword) => lower.contains(keyword));
  }

  /// Извлекает дату
  DateTime? _extractDate(List<String> lines, String? language) {
    // Паттерны для дат в разных форматах
    final datePatterns = [
      // DD/MM/YYYY, MM/DD/YYYY, YYYY-MM-DD
      RegExp(r'\b(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})\b'),
      // DD.MM.YYYY
      RegExp(r'\b(\d{1,2})\.(\d{1,2})\.(\d{2,4})\b'),
      // YYYY/MM/DD
      RegExp(r'\b(\d{4})[/-](\d{1,2})[/-](\d{1,2})\b'),
    ];

    for (final line in lines) {
      for (final pattern in datePatterns) {
        final match = pattern.firstMatch(line);
        if (match != null) {
          try {
            final groups = match.groups([1, 2, 3]);
            final group0 = groups[0];
            final group1 = groups[1];
            final group2 = groups[2];
            
            if (group0 != null && group1 != null && group2 != null) {
              int? day, month, year;
              
              // Определяем формат
              if (group2.length == 4) {
                // YYYY-MM-DD или DD-MM-YYYY
                if (int.parse(group0) > 31) {
                  year = int.parse(group0);
                  month = int.parse(group1);
                  day = int.parse(group2);
                } else {
                  day = int.parse(group0);
                  month = int.parse(group1);
                  year = int.parse(group2);
                }
              } else {
                // DD/MM/YY или MM/DD/YY
                day = int.parse(group0);
                month = int.parse(group1);
                year = int.parse(group2);
                if (year < 100) {
                  year += year < 50 ? 2000 : 1900;
                }
              }

              return DateTime(year, month, day);
            }
          } catch (e) {
            continue;
          }
        }
      }
    }

    return null;
  }

  /// Извлекает общую сумму
  double? _extractTotal(List<String> lines, String? language, String currency) {
    // Ключевые слова для общей суммы на разных языках
    final totalKeywords = {
      'en': ['total', 'amount', 'sum', 'due', 'pay', 'grand total', 'to pay'],
      'ru': ['итого', 'к оплате', 'сумма', 'всего', 'к уплате', 'к оплате'],
      'de': ['gesamt', 'summe', 'betrag', 'zu zahlen', 'gesamtbetrag'],
      'fr': ['total', 'montant', 'à payer', 'somme', 'montant total'],
      'es': ['total', 'importe', 'a pagar', 'suma', 'importe total'],
      'it': ['totale', 'importo', 'da pagare', 'somma', 'totale da pagare'],
      'pt': ['total', 'valor', 'a pagar', 'soma', 'valor total'],
      'zh': ['总计', '合计', '总额', '应付'],
      'ja': ['合計', '総額', 'お支払い', '合計金額'],
      'hy': ['ընդամենը', 'գումար', 'վճարել', 'ընդհանուր'], // Армянский
      'ar': ['المجموع', 'المبلغ', 'الدفع', 'الإجمالي'],
      'he': ['סה"כ', 'סכום', 'לתשלום', 'סה"כ לתשלום'],
      'th': ['รวม', 'จำนวนเงิน', 'ชำระ', 'ยอดรวม'],
      'ko': ['합계', '금액', '지불', '총액'],
      'el': ['σύνολο', 'ποσό', 'πληρωμή', 'συνολικό ποσό'],
    };

    final keywords = totalKeywords[language] ?? totalKeywords['en']!;
    final currencySymbol = _getCurrencySymbol(currency);

    // Ищем строку с ключевым словом и числом
    for (final line in lines.reversed) {
      final lower = line.toLowerCase();
      for (final keyword in keywords) {
        if (lower.contains(keyword.toLowerCase())) {
          final amount = _extractAmountFromLine(line, currencySymbol);
          if (amount != null) return amount;
        }
      }
    }

    // Если не нашли по ключевым словам, ищем самое большое число в конце
    for (int i = lines.length - 1; i >= max(0, lines.length - 10); i--) {
      final amount = _extractAmountFromLine(lines[i], currencySymbol);
      if (amount != null && amount > 0) {
        // Проверяем, что это не номер телефона или другой идентификатор
        if (amount < 1000000) {
          return amount;
        }
      }
    }

    return null;
  }

  /// Извлекает сумму без налогов
  double? _extractSubtotal(
    List<String> lines,
    String? language,
    String currency,
    double? total,
  ) {
    final subtotalKeywords = {
      'en': ['subtotal', 'sub-total', 'net', 'before tax', 'net amount'],
      'ru': ['без ндс', 'без налога', 'субтотал', 'нетто'],
      'de': ['zwischensumme', 'netto', 'nettobetrag'],
      'fr': ['sous-total', 'net', 'montant net'],
      'es': ['subtotal', 'neto', 'importe neto'],
      'it': ['subtotale', 'netto', 'importo netto'],
      'pt': ['subtotal', 'líquido', 'valor líquido'],
      'zh': ['小计', '净额', '不含税'],
      'ja': ['小計', '税抜', '税抜き'],
      'hy': ['ենթագումար', 'զուտ'], // Армянский
      'ar': ['المجموع الفرعي', 'صافي'],
      'he': ['סה"כ ביניים', 'נטו'],
      'th': ['ยอดรวมย่อย', 'สุทธิ'],
      'ko': ['소계', '순액'],
      'el': ['υποσύνολο', 'καθαρό'],
    };

    final keywords = subtotalKeywords[language] ?? subtotalKeywords['en']!;
    final currencySymbol = _getCurrencySymbol(currency);

    for (final line in lines) {
      final lower = line.toLowerCase();
      for (final keyword in keywords) {
        if (lower.contains(keyword.toLowerCase())) {
          final amount = _extractAmountFromLine(line, currencySymbol);
          if (amount != null) return amount;
        }
      }
    }

    // Если есть налог и общая сумма, вычисляем
    final tax = _extractTax(lines, language, currency);
    if (total != null && tax != null) {
      return total - tax;
    }

    return total;
  }

  /// Извлекает налог
  double? _extractTax(List<String> lines, String? language, String currency) {
    final taxKeywords = {
      'en': ['tax', 'vat', 'gst', 'hst', 'sales tax', 'service tax'],
      'ru': ['ндс', 'налог', 'сбор', 'налог на добавленную стоимость'],
      'de': ['mwst', 'umsatzsteuer', 'steuer', 'mehrwertsteuer'],
      'fr': ['tva', 'taxe', 'taxe sur la valeur ajoutée'],
      'es': ['iva', 'impuesto', 'impuesto sobre el valor añadido'],
      'it': ['iva', 'imposta', 'imposta sul valore aggiunto'],
      'pt': ['iva', 'imposto', 'imposto sobre valor agregado'],
      'zh': ['税', '增值税', '消费税'],
      'ja': ['税', '消費税', '付加価値税'],
      'hy': ['հարկ', 'ավելացված արժեքի հարկ'], // Армянский
      'ar': ['ضريبة', 'ضريبة القيمة المضافة'],
      'he': ['מס', 'מע"מ', 'מס ערך מוסף'],
      'th': ['ภาษี', 'ภาษีมูลค่าเพิ่ม'],
      'ko': ['세금', '부가세', '부가가치세'],
      'el': ['φόρος', 'ΦΠΑ', 'φόρος προστιθέμενης αξίας'],
    };

    final keywords = taxKeywords[language] ?? taxKeywords['en']!;
    final currencySymbol = _getCurrencySymbol(currency);

    for (final line in lines) {
      final lower = line.toLowerCase();
      for (final keyword in keywords) {
        if (lower.contains(keyword.toLowerCase())) {
          final amount = _extractAmountFromLine(line, currencySymbol);
          if (amount != null) return amount;
        }
      }
    }

    return null;
  }

  /// Извлекает сервисный сбор
  double? _extractServiceFee(
    List<String> lines,
    String? language,
    String currency,
  ) {
    final feeKeywords = {
      'en': ['service fee', 'service charge', 'tip', 'gratuity', 'service'],
      'ru': ['сервисный сбор', 'чаевые', 'обслуживание', 'сервис'],
      'de': ['servicegebühr', 'trinkgeld', 'bedienung', 'service'],
      'fr': ['frais de service', 'pourboire', 'service'],
      'es': ['cargo por servicio', 'propina', 'servicio'],
      'it': ['commissione di servizio', 'mancia', 'servizio'],
      'pt': ['taxa de serviço', 'gorjeta', 'serviço'],
      'zh': ['服务费', '小费', '服务'],
      'ja': ['サービス料', 'チップ', 'サービス'],
      'hy': ['ծառայության վճար', 'մուրաբա'], // Армянский
      'ar': ['رسوم الخدمة', 'إكرامية'],
      'he': ['דמי שירות', 'טיפ'],
      'th': ['ค่าบริการ', 'ทิป'],
      'ko': ['서비스 요금', '팁'],
      'el': ['χρέωση υπηρεσίας', 'φιλοδώρημα'],
    };

    final keywords = feeKeywords[language] ?? feeKeywords['en']!;
    final currencySymbol = _getCurrencySymbol(currency);

    for (final line in lines) {
      final lower = line.toLowerCase();
      for (final keyword in keywords) {
        if (lower.contains(keyword.toLowerCase())) {
          final amount = _extractAmountFromLine(line, currencySymbol);
          if (amount != null) return amount;
        }
      }
    }

    return null;
  }

  /// Извлекает скидку
  double? _extractDiscount(
    List<String> lines,
    String? language,
    String currency,
  ) {
    final discountKeywords = {
      'en': ['discount', 'off', 'save', 'reduction', 'promotion'],
      'ru': ['скидка', 'скид', 'экономия', 'промо'],
      'de': ['rabatt', 'nachlass', 'ermäßigung'],
      'fr': ['réduction', 'remise', 'promotion'],
      'es': ['descuento', 'rebaja', 'promoción'],
      'it': ['sconto', 'riduzione', 'promozione'],
      'pt': ['desconto', 'redução', 'promoção'],
      'zh': ['折扣', '优惠', '减价'],
      'ja': ['割引', 'ディスカウント', '特価'],
      'hy': ['զեղչ', 'նվազեցում'], // Армянский
      'ar': ['خصم', 'تخفيض'],
      'he': ['הנחה', 'הנחה'],
      'th': ['ส่วนลด', 'ลดราคา'],
      'ko': ['할인', '할인가'],
      'el': ['έκπτωση', 'προσφορά'],
    };

    final keywords = discountKeywords[language] ?? discountKeywords['en']!;
    final currencySymbol = _getCurrencySymbol(currency);

    for (final line in lines) {
      final lower = line.toLowerCase();
      for (final keyword in keywords) {
        if (lower.contains(keyword.toLowerCase())) {
          final amount = _extractAmountFromLine(line, currencySymbol);
          if (amount != null) return amount;
        }
      }
    }

    return null;
  }

  /// Извлекает товары из чека
  /// Использует умную логику поиска цен и названий товаров
  List<LineItem> _extractItems(
    List<String> lines,
    String? language,
    String currency,
  ) {
    final items = <LineItem>[];
    final currencySymbol = _getCurrencySymbol(currency);
    
    // Паттерн для поиска цен: числа с запятой/точкой, возможно с валютным символом
    final pricePattern = RegExp(
      r'(\d{1,6}(?:[.,]\d{1,2})?)' + 
      (currencySymbol != null ? r'\s*' + currencySymbol.replaceAll(r'$', r'\$').replaceAll('€', r'\€') : ''),
      caseSensitive: false,
    );
    
    // Паттерн для поиска количества: число перед x или ×
    final quantityPattern = RegExp(r'(\d+(?:[.,]\d+)?)\s*[x×]', caseSensitive: false);
    
    // Сначала пытаемся найти товары с помощью стандартных паттернов
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();
      
      // Пропускаем служебные строки
      if (_isServiceLine(trimmed, language)) continue;
      if (_looksLikeTotalLine(trimmed, language)) continue;
      
      // Пропускаем слишком короткие строки или строки только с цифрами
      if (trimmed.length < 3 || _isNumericLine(trimmed)) continue;
      
      // Ищем все возможные цены в строке
      final priceMatches = pricePattern.allMatches(trimmed);
      if (priceMatches.isEmpty) continue;
      
      // Берем последнюю цену в строке (обычно это цена товара)
      final lastPriceMatch = priceMatches.last;
      final priceStr = lastPriceMatch.group(1)?.replaceAll(RegExp(r'[^\d.,]'), '') ?? '';
      if (priceStr.isEmpty) continue;
      
      final price = _parseNumber(priceStr);
      if (price <= 0 || price >= 100000) continue; // Фильтруем неразумные цены
      
      // Извлекаем название товара - все до последней цены
      final priceStart = lastPriceMatch.start;
      var itemName = trimmed.substring(0, priceStart).trim();
      
      // Удаляем количество, если оно есть в начале или середине
      final qtyMatch = quantityPattern.firstMatch(itemName);
      double quantity = 1.0;
      if (qtyMatch != null) {
        quantity = _parseNumber(qtyMatch.group(1) ?? '1');
        // Удаляем количество из названия
        itemName = itemName.replaceFirst(qtyMatch.group(0) ?? '', '').trim();
      }
      
      // Очищаем название от лишних символов в конце
      // Поддерживаем Unicode символы для всех языков: кириллица, армянский, иврит, арабский, китайский, японский, корейский, тайский, греческий
      itemName = itemName.replaceAll(RegExp(r'[^\w\s\u0400-\u04FF\u0530-\u058F\u0590-\u05FF\u0600-\u06FF\u4E00-\u9FFF\u3040-\u309F\u30A0-\u30FF\uAC00-\uD7AF\u0E00-\u0E7F\u0370-\u03FF]+$'), '').trim();
      
      // Проверяем, что название не пустое и не только цифры/символы
      if (itemName.isEmpty || itemName.length < 2 || _isNumericLine(itemName)) continue;
      
      // Проверяем, что это не служебная информация
      if (_containsOnlyServiceInfo(itemName, language)) continue;
      
      // Вычисляем цену за единицу
      final unitPrice = quantity > 0 ? price / quantity : price;
      
      items.add(LineItem(
        id: _uuid.v4(),
        name: itemName,
        quantity: quantity > 0 ? quantity : 1.0,
        unitPrice: unitPrice,
      ));
    }
    
    // Если не нашли товары стандартным способом, используем более агрессивный поиск
    if (items.isEmpty) {
      return _extractItemsAggressive(lines, language, currency);
    }
    
    return items;
  }
  
  /// Агрессивный метод извлечения товаров для частично распознанного текста
  List<LineItem> _extractItemsAggressive(
    List<String> lines,
    String? language,
    String currency,
  ) {
    final items = <LineItem>[];
    
    // Ищем все строки, содержащие числа (возможные цены)
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.length < 3) continue;
      if (_isServiceLine(trimmed, language)) continue;
      if (_looksLikeTotalLine(trimmed, language)) continue;
      
      // Ищем числа в строке
      final numberPattern = RegExp(r'\b(\d{1,6}(?:[.,]\d{1,2})?)\b');
      final numbers = numberPattern.allMatches(trimmed);
      
      if (numbers.isEmpty) continue;
      
      // Берем последнее число как возможную цену
      final lastNumber = numbers.last;
      final priceStr = lastNumber.group(1)?.replaceAll(',', '.') ?? '';
      if (priceStr.isEmpty) continue;
      
      final price = double.tryParse(priceStr);
      if (price == null || price <= 0 || price >= 100000) continue;
      
      // Извлекаем название - все до последнего числа
      var itemName = trimmed.substring(0, lastNumber.start).trim();
      
      // Очищаем название
      itemName = itemName.replaceAll(RegExp(r'^\d+\s*[x×]\s*'), ''); // Удаляем количество
      // Поддерживаем Unicode символы для всех языков
      itemName = itemName.replaceAll(RegExp(r'[^\w\s\u0400-\u04FF\u0530-\u058F\u0590-\u05FF\u0600-\u06FF\u4E00-\u9FFF\u3040-\u309F\u30A0-\u30FF\uAC00-\uD7AF\u0E00-\u0E7F\u0370-\u03FF]+$'), '').trim();
      
      if (itemName.length >= 2 && !_isNumericLine(itemName)) {
        items.add(LineItem(
          id: _uuid.v4(),
          name: itemName,
          quantity: 1.0,
          unitPrice: price,
        ));
      }
    }
    
    return items;
  }
  
  /// Проверяет, содержит ли строка только служебную информацию
  bool _containsOnlyServiceInfo(String text, String? language) {
    final servicePatterns = [
      r'^\d+$', // Только цифры
      r'^[^\w\s]+$', // Только символы
      r'^(total|итого|сумма|amount|tax|налог|nds|ндс)', // Служебные слова
    ];
    
    final lower = text.toLowerCase();
    return servicePatterns.any((pattern) => RegExp(pattern, caseSensitive: false).hasMatch(lower));
  }
  
  /// Проверяет, похожа ли строка на строку с итоговой суммой
  bool _looksLikeTotalLine(String line, String? language) {
    final totalKeywords = {
      'en': ['total', 'amount', 'sum', 'due', 'pay', 'grand total', 'subtotal'],
      'ru': ['итого', 'к оплате', 'сумма', 'всего', 'к уплате', 'без ндс', 'подытог'],
      'de': ['gesamt', 'summe', 'betrag', 'zu zahlen', 'zwischensumme', 'gesamtbetrag'],
      'fr': ['total', 'montant', 'à payer', 'somme', 'sous-total', 'montant total'],
      'es': ['total', 'importe', 'a pagar', 'suma', 'subtotal', 'importe total'],
      'it': ['totale', 'importo', 'da pagare', 'somma', 'sottototale'],
      'pt': ['total', 'valor', 'a pagar', 'soma', 'subtotal'],
      'zh': ['总计', '合计', '总额', '小计'],
      'ja': ['合計', '総額', 'お支払い', '小計'],
      'hy': ['ընդամենը', 'գումար', 'վճարել', 'ընդհանուր'], // Армянский
      'ar': ['المجموع', 'المبلغ', 'الدفع', 'الإجمالي', 'المجموع الفرعي'],
      'he': ['סה"כ', 'סכום', 'לתשלום', 'סה"כ לתשלום'],
      'th': ['รวม', 'จำนวนเงิน', 'ชำระ', 'ยอดรวม'],
      'ko': ['합계', '금액', '지불', '총액', '소계'],
      'el': ['σύνολο', 'ποσό', 'πληρωμή', 'συνολικό ποσό'],
    };
    
    final keywords = totalKeywords[language] ?? totalKeywords['en']!;
    final lower = line.toLowerCase();
    
    return keywords.any((keyword) => lower.contains(keyword));
  }

  bool _isServiceLine(String line, String? language) {
    final serviceKeywords = {
      'en': ['total', 'subtotal', 'tax', 'discount', 'change', 'cash', 'card', 'vat'],
      'ru': ['итого', 'ндс', 'налог', 'скидка', 'сдача', 'наличные', 'карта', 'подытог'],
      'de': ['gesamt', 'summe', 'steuer', 'rabatt', 'wechselgeld', 'bar', 'karte', 'mwst'],
      'fr': ['total', 'sous-total', 'taxe', 'remise', 'monnaie', 'espèces', 'carte', 'tva'],
      'es': ['total', 'subtotal', 'impuesto', 'descuento', 'cambio', 'efectivo', 'tarjeta', 'iva'],
      'it': ['totale', 'sottototale', 'tassa', 'sconto', 'resto', 'contanti', 'carta', 'iva'],
      'pt': ['total', 'subtotal', 'imposto', 'desconto', 'troco', 'dinheiro', 'cartão', 'iva'],
      'zh': ['总计', '小计', '税', '折扣', '找零', '现金', '卡'],
      'ja': ['合計', '小計', '税', '割引', 'おつり', '現金', 'カード'],
      'hy': ['ընդամենը', 'գումար', 'հարկ', 'զեղչ', 'մանր'], // Армянский
      'ar': ['المجموع', 'الضريبة', 'الخصم', 'نقد', 'بطاقة'],
      'he': ['סה"כ', 'מס', 'הנחה', 'מזומן', 'כרטיס'],
      'th': ['รวม', 'ภาษี', 'ส่วนลด', 'เงินสด', 'บัตร'],
      'ko': ['합계', '세금', '할인', '현금', '카드'],
      'el': ['σύνολο', 'φόρος', 'έκπτωση', 'μετρητά', 'κάρτα'],
    };
    
    final keywords = serviceKeywords[language] ?? serviceKeywords['en']!;
    final lower = line.toLowerCase();
    
    return keywords.any((keyword) => lower.contains(keyword)) ||
           _isNumericLine(line);
  }

  /// Извлекает метод оплаты
  String? _extractPaymentMethod(List<String> lines, String? language) {
    final paymentKeywords = {
      'en': ['cash', 'card', 'credit', 'debit', 'visa', 'mastercard', 'paypal', 'apple pay'],
      'ru': ['наличные', 'карта', 'безнал', 'кредит', 'дебет', 'виза', 'мастеркард'],
      'de': ['bar', 'karte', 'kreditkarte', 'debitkarte', 'visa', 'mastercard'],
      'fr': ['espèces', 'carte', 'carte de crédit', 'carte bancaire', 'visa', 'mastercard'],
      'es': ['efectivo', 'tarjeta', 'tarjeta de crédito', 'visa', 'mastercard'],
      'it': ['contanti', 'carta', 'carta di credito', 'visa', 'mastercard'],
      'pt': ['dinheiro', 'cartão', 'cartão de crédito', 'visa', 'mastercard'],
      'zh': ['现金', '卡', '信用卡', '借记卡'],
      'ja': ['現金', 'カード', 'クレジットカード'],
      'hy': ['կանխիկ', 'քարտ', 'վիզա', 'մաստերկարդ'], // Армянский
      'ar': ['نقد', 'بطاقة', 'بطاقة ائتمان'],
      'he': ['מזומן', 'כרטיס', 'כרטיס אשראי'],
      'th': ['เงินสด', 'บัตร', 'บัตรเครดิต'],
      'ko': ['현금', '카드', '신용카드'],
      'el': ['μετρητά', 'κάρτα', 'πιστωτική κάρτα'],
    };

    final keywords = paymentKeywords[language] ?? paymentKeywords['en']!;

    for (final line in lines) {
      final lower = line.toLowerCase();
      for (final keyword in keywords) {
        if (lower.contains(keyword.toLowerCase())) {
          return keyword;
        }
      }
    }

    return null;
  }

  /// Извлекает сумму из строки
  double? _extractAmountFromLine(String line, String? currencySymbol) {
    // Удаляем все кроме цифр, точек, запятых и символов валюты
    final cleaned = line.replaceAll(RegExp(r'[^\d.,' + 
        (currencySymbol != null ? currencySymbol.replaceAll(r'$', r'\$') : '') + 
        r']'), '');
    
    // Ищем числа в строке
    final numberPattern = RegExp(r'[\d.,]+');
    final matches = numberPattern.allMatches(cleaned);
    
    // Берем самое большое число (обычно это сумма)
    double? maxAmount;
    for (final match in matches) {
      final amount = _parseNumber(match.group(0)!);
      if (amount > 0 && (maxAmount == null || amount > maxAmount)) {
        maxAmount = amount;
      }
    }
    
    return maxAmount;
  }

  /// Парсит число с учетом разных форматов (точка/запятая как разделитель)
  double _parseNumber(String str) {
    if (str.isEmpty) return 0;
    
    // Заменяем запятую на точку для парсинга
    final normalized = str.replaceAll(',', '.');
    
    // Удаляем все кроме цифр и точки
    final cleaned = normalized.replaceAll(RegExp(r'[^\d.]'), '');
    
    if (cleaned.isEmpty) return 0;
    
    try {
      return double.parse(cleaned);
    } catch (e) {
      return 0;
    }
  }

  /// Получает символ валюты
  String? _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return r'$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'RUB':
        return '₽';
      case 'KZT':
        return '₸';
      case 'AMD':
        return '֏';
      case 'JPY':
      case 'CNY':
        return '¥';
      default:
        return null;
    }
  }

  /// Определяет, требуется ли проверка чека
  bool _shouldRequireReview({
    required List<LineItem> items,
    double? total,
    double? subtotal,
    double? tax,
  }) {
    // Требуем проверку, если:
    // 1. Нет товаров
    if (items.isEmpty) return true;
    
    // 2. Нет общей суммы
    if (total == null) return true;
    
    // 3. Сумма товаров сильно отличается от общей суммы
    final itemsSum = items.fold<double>(
      0,
      (sum, item) => sum + (item.unitPrice * item.quantity),
    );
    
    final difference = (itemsSum - (subtotal ?? total)).abs();
    if (difference > total * 0.2) return true; // Разница больше 20%
    
    return false;
  }
}


# Использование универсального парсера чеков

## Быстрый старт

```dart
import 'package:image_picker/image_picker.dart';
import 'package:spendings_tracking_app/services/receipt/receipt_scanning_service.dart';

// 1. Создайте сервис
final scanningService = ReceiptScanningService();

// 2. Выберите изображение
final imagePicker = ImagePicker();
final image = await imagePicker.pickImage(source: ImageSource.camera);

if (image != null) {
  // 3. Сканируйте чек
  final receiptDraft = await scanningService.scanReceiptFromXFile(image);
  
  // 4. Используйте данные
  print('Магазин: ${receiptDraft.store?.name}');
  print('Сумма: ${receiptDraft.total} ${receiptDraft.currency}');
  print('Товаров: ${receiptDraft.items.length}');
  
  // 5. Проверьте, требуется ли ручная проверка
  if (receiptDraft.requiresReview) {
    // Покажите пользователю для проверки
  }
}

// 6. Освободите ресурсы
scanningService.dispose();
```

## Особенности

- ✅ **Бесплатно** - Google ML Kit работает офлайн
- ✅ **Универсально** - поддерживает множество языков
- ✅ **Автоматическое определение** - язык и валюта определяются автоматически

## Поддерживаемые языки

Английский, Русский, Немецкий, Французский, Испанский, Итальянский, Португальский, Китайский, Японский, Арабский и другие.

## Извлекаемые данные

- Название и адрес магазина
- Дата покупки
- Список товаров с ценами
- Общая сумма, налоги, скидки
- Метод оплаты
- Валюта


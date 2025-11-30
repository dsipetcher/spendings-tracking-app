import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'ocr_service.dart';
import 'receipt_parser.dart';
import '../../features/receipts/domain/models/receipt_models.dart';

/// Основной сервис для сканирования и парсинга чеков
/// Объединяет OCR и парсинг в единый интерфейс
class ReceiptScanningService {
  final OCRService _ocrService;
  final ReceiptParser _parser;

  ReceiptScanningService()
      : _ocrService = OCRService(),
        _parser = ReceiptParser();

  /// Сканирует чек с изображения и возвращает ReceiptDraft
  /// 
  /// [imageFile] - файл изображения чека
  /// [detectedLanguage] - опционально предопределенный язык (если известен)
  /// 
  /// Возвращает [ReceiptDraft] с распознанными данными
  Future<ReceiptDraft> scanReceiptFromFile(
    File imageFile, {
    String? detectedLanguage,
  }) async {
    try {
      // Распознаем текст с изображения
      final text = await _ocrService.recognizeTextFromFile(imageFile);
      
      if (text.trim().isEmpty) {
        return _createEmptyDraft(imagePath: imageFile.path);
      }

      // Парсим текст в структурированные данные
      return _parser.parseReceiptText(
        text: text,
        imagePath: imageFile.path,
        detectedLanguage: detectedLanguage,
      );
    } catch (e) {
      // В случае ошибки возвращаем пустой черновик
      return _createEmptyDraft(imagePath: imageFile.path);
    }
  }

  /// Сканирует чек с изображения из XFile (из image_picker)
  Future<ReceiptDraft> scanReceiptFromXFile(
    XFile imageFile, {
    String? detectedLanguage,
  }) async {
    try {
      // Распознаем текст с изображения
      final text = await _ocrService.recognizeTextFromXFile(imageFile);
      
      if (text.trim().isEmpty) {
        return _createEmptyDraft(imagePath: imageFile.path);
      }

      // Парсим текст в структурированные данные
      return _parser.parseReceiptText(
        text: text,
        imagePath: imageFile.path,
        detectedLanguage: detectedLanguage,
      );
    } catch (e) {
      // В случае ошибки возвращаем пустой черновик
      return _createEmptyDraft(imagePath: imageFile.path);
    }
  }

  /// Парсит уже распознанный текст чека
  /// Полезно, если текст уже был получен из другого источника
  ReceiptDraft parseReceiptText({
    required String text,
    String? imagePath,
    String? detectedLanguage,
  }) {
    return _parser.parseReceiptText(
      text: text,
      imagePath: imagePath,
      detectedLanguage: detectedLanguage,
    );
  }

  ReceiptDraft _createEmptyDraft({String? imagePath}) {
    return ReceiptDraft(
      currency: 'USD',
      flowType: MoneyFlowType.expense,
      createdAt: DateTime.now(),
      items: const [],
      sourceImagePath: imagePath,
      requiresReview: true,
    );
  }

  void dispose() {
    _ocrService.dispose();
  }
}


import 'dart:io';
import 'dart:typed_data';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

/// Сервис для распознавания текста с изображений чеков
/// Использует Google ML Kit - бесплатное офлайн решение
/// 
/// Примечание: Google ML Kit Text Recognition поддерживает ограниченный набор языков.
/// Для языков с нелатинскими алфавитами (армянский, арабский и т.д.) распознавание
/// может быть неточным. В таких случаях парсер использует умную логику для извлечения
/// товаров даже из частично распознанного текста.
class OCRService {
  final TextRecognizer _textRecognizer;

  OCRService() : _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  /// Распознает текст с изображения файла
  Future<String> recognizeTextFromFile(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    
    // Собираем весь текст из всех блоков, сохраняя структуру
    return _extractFullText(recognizedText);
  }

  /// Распознает текст с изображения из XFile (из image_picker)
  Future<String> recognizeTextFromXFile(XFile imageFile) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final recognizedText = await _textRecognizer.processImage(inputImage);
    
    // Собираем весь текст из всех блоков, сохраняя структуру
    return _extractFullText(recognizedText);
  }
  
  /// Извлекает полный текст из всех блоков распознанного текста
  /// Сохраняет структуру строк для лучшего парсинга
  String _extractFullText(RecognizedText recognizedText) {
    final buffer = StringBuffer();
    
    // Проходим по всем блокам текста
    for (final block in recognizedText.blocks) {
      // Проходим по всем строкам в блоке
      for (final line in block.lines) {
        // Собираем текст из всех элементов строки
        final lineText = line.elements.map((e) => e.text).join(' ');
        if (lineText.trim().isNotEmpty) {
          buffer.writeln(lineText.trim());
        }
      }
    }
    
    final fullText = buffer.toString().trim();
    
    // Если текст пустой, возвращаем просто recognizedText.text как fallback
    return fullText.isNotEmpty ? fullText : recognizedText.text;
  }

  /// Распознает текст с изображения из байтов
  Future<String> recognizeTextFromBytes(
    Uint8List imageBytes,
    InputImageMetadata metadata,
  ) async {
    final inputImage = InputImage.fromBytes(
      bytes: imageBytes,
      metadata: metadata,
    );
    final recognizedText = await _textRecognizer.processImage(inputImage);
    
    return recognizedText.text;
  }

  void dispose() {
    _textRecognizer.close();
  }
}


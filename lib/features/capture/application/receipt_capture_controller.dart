import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../services/capture/receipt_capture_service.dart';
import '../../../services/receipt/receipt_scanning_service.dart';
import '../../receipts/application/receipts_controller.dart';
import '../../receipts/domain/models/receipt_models.dart';
import '../../settings/application/settings_controller.dart';

final receiptCaptureServiceProvider = Provider<ReceiptCaptureService>((ref) {
  final service = ReceiptCaptureService();
  ref.onDispose(service.dispose);
  return service;
});

final receiptCaptureControllerProvider =
    StateNotifierProvider<ReceiptCaptureController, ReceiptCaptureState>(
  (ref) => ReceiptCaptureController(
    ref: ref,
    service: ref.watch(receiptCaptureServiceProvider),
    receiptsController: ref.watch(receiptsProvider.notifier),
  ),
);

class ReceiptCaptureController extends StateNotifier<ReceiptCaptureState> {
  ReceiptCaptureController({
    required this.ref,
    required ReceiptCaptureService service,
    required this.receiptsController,
  })  : _service = service,
        super(const ReceiptCaptureState.idle());

  final Ref ref;
  final ReceiptCaptureService _service;
  final ReceiptsController receiptsController;
  final Uuid _uuid = const Uuid();
  final ReceiptScanningService _scanningService = ReceiptScanningService();

  Future<void> captureFromDemo() async {
    state = const ReceiptCaptureState.processing();
    try {
      final draft = await _service.demo();
      state = ReceiptCaptureState.success(draft, file: null);
    } catch (error) {
      state =
          ReceiptCaptureState.failure('Failed to process demo data: $error');
    }
  }

  Future<void> captureFromFile(XFile file) async {
    state = ReceiptCaptureState.processing(file: file);
    try {
      final draft = await _service.fromImage(file);
      state = ReceiptCaptureState.success(draft, file: file);
    } catch (error) {
      state = ReceiptCaptureState.failure('Failed to read receipt: $error');
    }
  }

  Future<void> commitDraft() async {
    final current = state;
    if (current is _CaptureSuccess) {
      try {
        final settings = ref.read(settingsControllerProvider);
        String? imagePath = current.draft.sourceImagePath;
        if (settings.storeOriginalImages && current.file != null) {
          imagePath = await _persistImage(current.file!);
        }
        if (!settings.storeOriginalImages) {
          imagePath = null;
        }
        final draftToSave = current.draft.copyWith(
          sourceImagePath: imagePath,
        );
        await receiptsController.addFromDraft(draftToSave);
        state = const ReceiptCaptureState.completed();
      } catch (error) {
        state = ReceiptCaptureState.failure('Failed to save receipt: $error');
      }
    }
  }

  /// Парсит переведённый текст из Google Lens
  /// 
  /// [text] - переведённый текст чека из Google Lens
  /// [imageFile] - опциональный файл изображения (для сохранения)
  Future<void> parseFromText(String text, {XFile? imageFile}) async {
    if (text.trim().isEmpty) {
      state = const ReceiptCaptureState.failure('Текст не может быть пустым');
      return;
    }

    state = ReceiptCaptureState.processing(file: imageFile);
    
    // Используем Future.microtask для асинхронной обработки
    await Future.microtask(() {
      try {
        final draft = _scanningService.parseReceiptText(
          text: text,
          imagePath: imageFile?.path,
        );
        state = ReceiptCaptureState.success(draft, file: imageFile);
      } catch (error, stackTrace) {
        // Логируем ошибку для отладки
        debugPrint('❌ Ошибка при парсинге текста из Google Lens: $error');
        debugPrint('Stack trace: $stackTrace');
        state = ReceiptCaptureState.failure(
          'Не удалось распарсить текст: ${error.toString()}',
        );
      }
    });
  }

  void reset() => state = const ReceiptCaptureState.idle();

  Future<String?> _persistImage(XFile file) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final receiptsDir = Directory(p.join(docsDir.path, 'receipts'));
    await receiptsDir.create(recursive: true);
    final extension =
        p.extension(file.path).isEmpty ? '.jpg' : p.extension(file.path);
    final newPath = p.join(receiptsDir.path, '${_uuid.v4()}$extension');
    await File(file.path).copy(newPath);
    return newPath;
  }
}

sealed class ReceiptCaptureState {
  const ReceiptCaptureState();

  const factory ReceiptCaptureState.idle() = _CaptureIdle;

  const factory ReceiptCaptureState.processing({XFile? file}) =
      _CaptureProcessing;

  const factory ReceiptCaptureState.success(ReceiptDraft draft, {XFile? file}) =
      _CaptureSuccess;

  const factory ReceiptCaptureState.failure(String message) = _CaptureFailure;

  const factory ReceiptCaptureState.completed() = _CaptureCompleted;

  T? whenOrNull<T>({
    T Function()? idle,
    T Function(XFile? file)? processing,
    T Function(ReceiptDraft draft, XFile? file)? success,
    T Function(String message)? failure,
    T Function()? completed,
  }) {
    final self = this;
    if (self is _CaptureIdle) return idle?.call();
    if (self is _CaptureProcessing) return processing?.call(self.file);
    if (self is _CaptureSuccess) return success?.call(self.draft, self.file);
    if (self is _CaptureFailure) return failure?.call(self.message);
    if (self is _CaptureCompleted) return completed?.call();
    return null;
  }

  T maybeWhen<T>({
    T Function()? idle,
    T Function(XFile? file)? processing,
    T Function(ReceiptDraft draft, XFile? file)? success,
    T Function(String message)? failure,
    T Function()? completed,
    required T Function() orElse,
  }) {
    final matched = whenOrNull(
      idle: idle,
      processing: processing,
      success: success,
      failure: failure,
      completed: completed,
    );
    return matched ?? orElse();
  }
}

class _CaptureIdle extends ReceiptCaptureState {
  const _CaptureIdle() : super();
}

class _CaptureProcessing extends ReceiptCaptureState {
  const _CaptureProcessing({this.file}) : super();

  final XFile? file;
}

class _CaptureSuccess extends ReceiptCaptureState {
  const _CaptureSuccess(this.draft, {this.file}) : super();

  final ReceiptDraft draft;
  final XFile? file;
}

class _CaptureFailure extends ReceiptCaptureState {
  const _CaptureFailure(this.message) : super();

  final String message;
}

class _CaptureCompleted extends ReceiptCaptureState {
  const _CaptureCompleted() : super();
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/capture/receipt_capture_service.dart';
import '../../receipts/application/receipts_controller.dart';
import '../../receipts/domain/models/receipt_models.dart';

final receiptCaptureServiceProvider = Provider<ReceiptCaptureService>(
  (ref) => ReceiptCaptureService(),
);

final receiptCaptureControllerProvider =
    StateNotifierProvider<ReceiptCaptureController, ReceiptCaptureState>(
  (ref) => ReceiptCaptureController(
    service: ref.watch(receiptCaptureServiceProvider),
    receiptsController: ref.watch(receiptsProvider.notifier),
  ),
);

class ReceiptCaptureController extends StateNotifier<ReceiptCaptureState> {
  ReceiptCaptureController({
    required ReceiptCaptureService service,
    required this.receiptsController,
  })  : _service = service,
        super(const ReceiptCaptureState.idle());

  final ReceiptCaptureService _service;
  final ReceiptsController receiptsController;

  Future<void> captureFromDemo() async {
    state = const ReceiptCaptureState.processing();
    try {
      final draft = await _service.demo();
      state = ReceiptCaptureState.success(draft);
    } catch (error) {
      state =
          ReceiptCaptureState.failure('Failed to process demo data: $error');
    }
  }

  Future<void> captureFromFile(XFile file) async {
    state = ReceiptCaptureState.processing(file: file);
    try {
      final draft = await _service.fromImage(file);
      state = ReceiptCaptureState.success(draft);
    } catch (error) {
      state = ReceiptCaptureState.failure('Failed to read receipt: $error');
    }
  }

  void commitDraft() {
    state.maybeWhen(
      success: (draft) {
        receiptsController.addFromDraft(draft);
        state = const ReceiptCaptureState.completed();
      },
      orElse: () {},
    );
  }

  void reset() => state = const ReceiptCaptureState.idle();
}

sealed class ReceiptCaptureState {
  const ReceiptCaptureState();

  const factory ReceiptCaptureState.idle() = _CaptureIdle;

  const factory ReceiptCaptureState.processing({XFile? file}) =
      _CaptureProcessing;

  const factory ReceiptCaptureState.success(ReceiptDraft draft) =
      _CaptureSuccess;

  const factory ReceiptCaptureState.failure(String message) = _CaptureFailure;

  const factory ReceiptCaptureState.completed() = _CaptureCompleted;

  T? whenOrNull<T>({
    T Function()? idle,
    T Function(XFile? file)? processing,
    T Function(ReceiptDraft draft)? success,
    T Function(String message)? failure,
    T Function()? completed,
  }) {
    final self = this;
    if (self is _CaptureIdle) return idle?.call();
    if (self is _CaptureProcessing) return processing?.call(self.file);
    if (self is _CaptureSuccess) return success?.call(self.draft);
    if (self is _CaptureFailure) return failure?.call(self.message);
    if (self is _CaptureCompleted) return completed?.call();
    return null;
  }

  T maybeWhen<T>({
    T Function()? idle,
    T Function(XFile? file)? processing,
    T Function(ReceiptDraft draft)? success,
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
  const _CaptureSuccess(this.draft) : super();

  final ReceiptDraft draft;
}

class _CaptureFailure extends ReceiptCaptureState {
  const _CaptureFailure(this.message) : super();

  final String message;
}

class _CaptureCompleted extends ReceiptCaptureState {
  const _CaptureCompleted() : super();
}

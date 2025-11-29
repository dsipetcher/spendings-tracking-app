import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/receipt_repository.dart';
import '../domain/models/receipt_models.dart';

final receiptsProvider =
    AsyncNotifierProvider<ReceiptsController, List<Receipt>>(
        ReceiptsController.new);

class ReceiptsController extends AsyncNotifier<List<Receipt>> {
  ReceiptsController();

  final Uuid _uuid = const Uuid();
  StreamSubscription<List<Receipt>>? _subscription;

  ReceiptRepository get _repository => ref.read(receiptRepositoryProvider);

  @override
  Future<List<Receipt>> build() async {
    final initial = await _repository.getAllReceipts();
    _subscription?.cancel();
    _subscription = _repository.watchReceipts().listen((data) {
      state = AsyncData(data);
    });
    ref.onDispose(() => _subscription?.cancel());
    return initial;
  }

  Receipt? findById(String id) =>
      state.asData?.value.firstWhereOrNull((receipt) => receipt.id == id);

  Future<void> addReceipt(Receipt receipt) async {
    await _repository.upsertReceipt(receipt);
  }

  Future<void> addFromDraft(ReceiptDraft draft) async {
    final receipt = draft.finalize(id: _uuid.v4());
    await addReceipt(receipt);
  }

  Future<void> updateReceipt(Receipt updated) async {
    await _repository.upsertReceipt(updated);
  }

  Future<void> deleteReceipt(String id) async {
    await _repository.deleteReceipt(id);
  }
}

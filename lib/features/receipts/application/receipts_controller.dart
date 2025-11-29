import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/demo_receipts.dart';
import '../domain/models/receipt_models.dart';

final receiptsProvider =
    NotifierProvider<ReceiptsController, List<Receipt>>(ReceiptsController.new);

class ReceiptsController extends Notifier<List<Receipt>> {
  ReceiptsController();

  final Uuid _uuid = const Uuid();

  @override
  List<Receipt> build() => DemoReceipts.initialPool;

  Receipt? findById(String id) =>
      state.firstWhereOrNull((receipt) => receipt.id == id);

  void addReceipt(Receipt receipt) {
    state = [...state, receipt];
  }

  void addFromDraft(ReceiptDraft draft) {
    final receipt = draft.finalize(id: _uuid.v4());
    addReceipt(receipt);
  }

  void updateReceipt(Receipt updated) {
    state = [
      for (final receipt in state)
        if (receipt.id == updated.id) updated else receipt,
    ];
  }

  void deleteReceipt(String id) {
    state = state.where((receipt) => receipt.id != id).toList(growable: false);
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/demo_receipts.dart';
import '../domain/models/receipt_models.dart';

class ReceiptRepository {
  ReceiptRepository();

  static const _boxName = 'receipts_box';
  bool _initialized = false;
  Box<Map>? _box;

  Future<Box<Map>> get _store async {
    if (!_initialized) {
      await Hive.initFlutter();
      _initialized = true;
    }
    _box ??= await Hive.openBox<Map>(_boxName);
    return _box!;
  }

  Future<List<Receipt>> getAllReceipts() async {
    final box = await _store;
    if (box.isEmpty) {
      await seedDemoData();
      return getAllReceipts();
    }
    return _readBox(box);
  }

  Stream<List<Receipt>> watchReceipts() async* {
    final box = await _store;
    yield _readBox(box);
    yield* box.watch().map((_) => _readBox(box));
  }

  Future<void> upsertReceipt(Receipt receipt) async {
    final box = await _store;
    await box.put(receipt.id, _serialize(receipt));
  }

  Future<void> upsertMany(Iterable<Receipt> receipts) async {
    final box = await _store;
    await box.putAll({
      for (final receipt in receipts) receipt.id: _serialize(receipt),
    });
  }

  Future<void> deleteReceipt(String receiptId) async {
    final box = await _store;
    await box.delete(receiptId);
  }

  Map<String, dynamic> _serialize(Receipt receipt) => Map<String, dynamic>.from(
        jsonDecode(jsonEncode(receipt.toJson())) as Map<String, dynamic>,
      );

  Future<void> seedDemoData() async {
    await upsertMany(DemoReceipts.initialPool);
  }

  Future<void> close() async {
    await _box?.close();
    _box = null;
  }

  List<Receipt> _readBox(Box<Map> box) {
    final receipts = box.values
        .map(
          (entry) => Receipt.fromJson(
            jsonDecode(jsonEncode(entry)) as Map<String, dynamic>,
          ),
        )
        .toList();
    receipts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return receipts;
  }
}

final receiptRepositoryProvider = Provider<ReceiptRepository>((ref) {
  final repo = ReceiptRepository();
  ref.onDispose(repo.close);
  return repo;
});

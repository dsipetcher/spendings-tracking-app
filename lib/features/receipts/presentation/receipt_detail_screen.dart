import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../core/utils/currency_formatter.dart';
import '../application/receipts_controller.dart';
import '../domain/models/receipt_models.dart';

class ReceiptDetailScreen extends ConsumerWidget {
  const ReceiptDetailScreen({required this.receiptId, super.key});

  static const routeName = '/receipts/detail';

  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receipt = ref.watch(receiptsProvider).firstWhere(
          (item) => item.id == receiptId,
          orElse: () => throw StateError('Receipt not found'),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(receipt.store.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _openEditSheet(context, ref, receipt),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _DetailHeader(receipt: receipt),
          const SizedBox(height: 20),
          _TotalsCard(receipt: receipt),
          const SizedBox(height: 20),
          _LineItemsCard(receipt: receipt),
          const SizedBox(height: 20),
          _MetaCard(receipt: receipt),
        ],
      ),
    );
  }

  Future<void> _openEditSheet(
      BuildContext context, WidgetRef ref, Receipt receipt) async {
    final storeController = TextEditingController(text: receipt.store.name);
    final addressController =
        TextEditingController(text: receipt.store.address ?? '');
    final noteController = TextEditingController(text: receipt.notes ?? '');

    final result = await showModalBottomSheet<Receipt>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit receipt',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: storeController,
                decoration: const InputDecoration(labelText: 'Store name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      receipt.copyWith(
                        store: receipt.store.copyWith(
                          name: storeController.text.trim(),
                          address: addressController.text.trim().isEmpty
                              ? null
                              : addressController.text.trim(),
                        ),
                        notes: noteController.text.trim().isEmpty
                            ? null
                            : noteController.text.trim(),
                        autoCategorized: false,
                      ),
                    );
                  },
                  child: const Text('Save changes'),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      ref.read(receiptsProvider.notifier).updateReceipt(result);
    }
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.receipt});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              receipt.store.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            if (receipt.store.address != null) ...[
              const SizedBox(height: 4),
              Text(receipt.store.address!,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  avatar: Icon(
                    receipt.flowType == MoneyFlowType.expense
                        ? Icons.south_west
                        : Icons.north_east,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(receipt.flowType == MoneyFlowType.expense
                      ? 'Expense'
                      : 'Income'),
                ),
                const SizedBox(width: 8),
                Chip(
                  avatar: const Icon(Icons.language, size: 16),
                  label: Text(receipt.sourceLanguage ?? 'auto'),
                ),
                if (receipt.requiresReview) ...[
                  const SizedBox(width: 8),
                  Chip(
                    avatar: const Icon(Icons.warning_amber_outlined, size: 16),
                    label: const Text('Review'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.receipt});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  formatCurrency(receipt.total, currency: receipt.currency),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const Divider(height: 32),
            _TotalRow(
                label: 'Subtotal',
                value: receipt.subtotal,
                currency: receipt.currency),
            if (receipt.tax != null)
              _TotalRow(
                  label: 'Tax',
                  value: receipt.tax!,
                  currency: receipt.currency),
            if (receipt.serviceFee != null)
              _TotalRow(
                  label: 'Service fee',
                  value: receipt.serviceFee!,
                  currency: receipt.currency),
            if (receipt.discount != null)
              _TotalRow(
                label: 'Discount',
                value: -receipt.discount!,
                currency: receipt.currency,
              ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow(
      {required this.label, required this.value, required this.currency});

  final String label;
  final double value;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            formatCurrency(value, currency: currency),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _LineItemsCard extends ConsumerWidget {
  const _LineItemsCard({required this.receipt});

  final Receipt receipt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Line items', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            for (final item in receipt.items) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.translatedName ?? item.name),
                subtitle: Text(
                    '${item.quantity} × ${formatCurrency(item.unitPrice, currency: receipt.currency)}'),
                trailing: DropdownButton<SpendingCategory>(
                  value: item.category,
                  items: SpendingCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
                  onChanged: (category) {
                    if (category == null) return;
                    final updated = receipt.copyWith(
                      items: [
                        for (final current in receipt.items)
                          if (current.id == item.id)
                            current.copyWith(category: category)
                          else
                            current,
                      ],
                      autoCategorized: false,
                    );
                    ref.read(receiptsProvider.notifier).updateReceipt(updated);
                  },
                ),
              ),
              const Divider(),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetaCard extends StatelessWidget {
  const _MetaCard({required this.receipt});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Metadata', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.today_outlined),
              title: const Text('Captured'),
              subtitle: Text(receipt.createdAt.toReceiptLabel()),
            ),
            if (receipt.paymentMethod != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.credit_card),
                title: const Text('Payment'),
                subtitle: Text(receipt.paymentMethod!),
              ),
            if (receipt.notes != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.notes),
                title: const Text('Notes'),
                subtitle: Text(receipt.notes!),
              ),
          ],
        ),
      ),
    );
  }
}

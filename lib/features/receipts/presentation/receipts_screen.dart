import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../services/currency/currency_converter.dart';
import '../../../services/currency/exchange_rate_service.dart';
import '../../settings/application/settings_controller.dart';
import '../application/receipts_controller.dart';
import '../domain/models/receipt_models.dart';
import 'receipt_detail_screen.dart';

class ReceiptsScreen extends ConsumerStatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  ConsumerState<ReceiptsScreen> createState() => _ReceiptsScreenState();
}

enum _ReceiptFilter { all, expenses, income, review }

class _ReceiptsScreenState extends ConsumerState<ReceiptsScreen> {
  _ReceiptFilter filter = _ReceiptFilter.all;
  String query = '';

  @override
  Widget build(BuildContext context) {
    final receiptsAsync = ref.watch(receiptsProvider);

    return receiptsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('Failed to load receipts: $error')),
      data: (receipts) {
        final filtered = receipts.where((receipt) {
          switch (filter) {
            case _ReceiptFilter.expenses:
              return receipt.flowType == MoneyFlowType.expense;
            case _ReceiptFilter.income:
              return receipt.flowType == MoneyFlowType.income;
            case _ReceiptFilter.review:
              return receipt.requiresReview;
            case _ReceiptFilter.all:
              return true;
          }
        }).where((receipt) {
          if (query.isEmpty) return true;
          final normalized = query.toLowerCase();
          return receipt.store.name.toLowerCase().contains(normalized) ||
              receipt.items
                  .any((item) => item.name.toLowerCase().contains(normalized));
        }).toList();

        final grouped = filtered
            .groupListsBy((receipt) => DateUtils.dateOnly(receipt.createdAt));

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            _buildFilterBar(),
            const SizedBox(height: 12),
            _buildSearchField(),
            const SizedBox(height: 20),
            if (filtered.isEmpty)
              const _EmptyState()
            else
              ...grouped.entries.sorted((a, b) => b.key.compareTo(a.key)).map(
                    (entry) => _ReceiptDaySection(
                      date: entry.key,
                      receipts: entry.value,
                    ),
                  ),
          ],
        );
      },
    );
  }

  Widget _buildFilterBar() {
    return SegmentedButton<_ReceiptFilter>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(value: _ReceiptFilter.all, label: Text('All')),
        ButtonSegment(value: _ReceiptFilter.expenses, label: Text('Expenses')),
        ButtonSegment(value: _ReceiptFilter.income, label: Text('Income')),
        ButtonSegment(
            value: _ReceiptFilter.review, label: Text('Needs review')),
      ],
      selected: {filter},
      onSelectionChanged: (selection) {
        setState(() {
          filter = selection.first;
        });
      },
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search store, item or note',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onChanged: (value) => setState(() => query = value),
    );
  }
}

class _ReceiptDaySection extends StatelessWidget {
  const _ReceiptDaySection({required this.date, required this.receipts});

  final DateTime date;
  final List<Receipt> receipts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date.toDayLabel(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        for (final receipt in receipts) ...[
          _ReceiptCard(receipt: receipt),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}

class _ReceiptCard extends ConsumerWidget {
  const _ReceiptCard({required this.receipt});

  final Receipt receipt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final ratesAsync = ref.watch(exchangeRatesProvider);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).pushNamed(
          ReceiptDetailScreen.routeName,
          arguments: receipt.id,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(.1),
                    child: Icon(
                      receipt.flowType == MoneyFlowType.expense
                          ? Icons.store_mall_directory
                          : Icons.savings,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          receipt.store.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (receipt.store.address != null)
                          Text(
                            receipt.store.address!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  ratesAsync.when(
                    data: (ratesData) {
                      final amounts = buildCurrencyDisplay(
                        amount: receipt.total,
                        currency: receipt.currency,
                        ratesData: ratesData,
                        settings: settings,
                      );
                      final originalValue =
                          receipt.flowType == MoneyFlowType.expense
                              ? -amounts.originalAmount
                              : amounts.originalAmount;
                      final baseValue =
                          receipt.flowType == MoneyFlowType.expense
                              ? -(amounts.baseAmount ?? 0)
                              : amounts.baseAmount;
                      final personalValue =
                          receipt.flowType == MoneyFlowType.expense
                              ? -(amounts.personalAmount ?? 0)
                              : amounts.personalAmount;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatCurrency(
                              originalValue,
                              currency: amounts.originalCurrency,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: receipt.flowType == MoneyFlowType.expense
                                  ? Colors.redAccent
                                  : Colors.teal,
                            ),
                          ),
                          if (baseValue != null)
                            Text(
                              '≈ ${formatCurrency(baseValue, currency: amounts.baseCurrency)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          if (personalValue != null &&
                              settings.personalCurrency != amounts.baseCurrency)
                            Text(
                              '≈ ${formatCurrency(personalValue, currency: amounts.personalCurrency)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      );
                    },
                    loading: () => Text(
                      formatCurrency(
                        receipt.flowType == MoneyFlowType.expense
                            ? -receipt.total
                            : receipt.total,
                        currency: receipt.currency,
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: receipt.flowType == MoneyFlowType.expense
                            ? Colors.redAccent
                            : Colors.teal,
                      ),
                    ),
                    error: (error, _) => Text(
                      formatCurrency(
                        receipt.flowType == MoneyFlowType.expense
                            ? -receipt.total
                            : receipt.total,
                        currency: receipt.currency,
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: receipt.flowType == MoneyFlowType.expense
                            ? Colors.redAccent
                            : Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    visualDensity: VisualDensity.compact,
                    avatar: const Icon(Icons.category, size: 16),
                    label: Text(_dominantCategory(receipt)),
                  ),
                  Chip(
                    visualDensity: VisualDensity.compact,
                    avatar: Icon(
                      receipt.autoCategorized ? Icons.bolt : Icons.edit,
                      size: 16,
                    ),
                    label: Text(receipt.autoCategorized ? 'Auto' : 'Manual'),
                  ),
                  Chip(
                    visualDensity: VisualDensity.compact,
                    avatar: const Icon(Icons.calendar_today, size: 16),
                    label: Text(receipt.createdAt.toReceiptLabel()),
                  ),
                  if (receipt.requiresReview)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      avatar:
                          const Icon(Icons.warning_amber_outlined, size: 16),
                      label: const Text('Review recommended'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dominantCategory(Receipt receipt) {
    final grouped = receipt.items.groupListsBy((item) => item.category);
    if (grouped.isEmpty) return 'Uncategorized';
    final sorted = grouped.entries.sorted(
      (a, b) => b.value.length.compareTo(a.value.length),
    );
    return sorted.first.key.name;
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No receipts yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text('Scan your first receipt to see spending insights here.'),
        ],
      ),
    );
  }
}

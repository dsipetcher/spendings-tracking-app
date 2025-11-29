import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../receipts/application/receipts_controller.dart';
import '../../receipts/domain/models/receipt_models.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiptsAsync = ref.watch(receiptsProvider);

    return receiptsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          Center(child: Text('Failed to load receipts: $error')),
      data: (receipts) {
        final analytics = _AnalyticsSnapshot.fromReceipts(receipts);
        final currency = receipts.isEmpty ? 'USD' : receipts.first.currency;

        return RefreshIndicator(
          onRefresh: () async =>
              Future<void>.delayed(const Duration(milliseconds: 600)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            children: [
              _BalanceCard(analytics: analytics, currency: currency),
              const SizedBox(height: 20),
              _WeeklyChart(analytics: analytics, currency: currency),
              const SizedBox(height: 20),
              _CategoryHighlights(analytics: analytics, currency: currency),
              const SizedBox(height: 20),
              _RecentActivity(receipts: receipts, currency: currency),
            ],
          ),
        );
      },
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.analytics, required this.currency});

  final _AnalyticsSnapshot analytics;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('This month', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              formatCurrency(analytics.netBalance, currency: currency),
              style: textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _BalanceTile(
                    label: 'Income',
                    value: analytics.totalIncome,
                    currency: currency,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BalanceTile(
                    label: 'Expenses',
                    value: analytics.totalExpenses,
                    currency: currency,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceTile extends StatelessWidget {
  const _BalanceTile({
    required this.label,
    required this.value,
    required this.currency,
    required this.color,
  });

  final String label;
  final double value;
  final String currency;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withOpacity(.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(
            formatCurrency(value, currency: currency),
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.analytics, required this.currency});

  final _AnalyticsSnapshot analytics;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final points = analytics.weeklyExpenses;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('7-day spending',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Text(
                  formatCurrency(
                      analytics.weeklyExpenses.fold(0, (v, p) => v + p.amount),
                      currency: currency),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.round();
                          if (index < 0 || index >= points.length)
                            return const SizedBox.shrink();
                          return Text(points[index].dateLabel,
                              style: const TextStyle(fontSize: 11));
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, _) => Text(
                          '${value.toInt()}',
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      spots: [
                        for (int i = 0; i < points.length; i++)
                          FlSpot(i.toDouble(), points[i].amount),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryHighlights extends StatelessWidget {
  const _CategoryHighlights({required this.analytics, required this.currency});

  final _AnalyticsSnapshot analytics;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final topCategories = analytics.categoryTotals.entries.sorted(
      (a, b) => b.value.compareTo(a.value),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Top categories',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            for (final entry in topCategories.take(4)) ...[
              Row(
                children: [
                  Expanded(child: Text(entry.key.name)),
                  Text(
                    formatCurrency(entry.value, currency: currency),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity({required this.receipts, required this.currency});

  final List<Receipt> receipts;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent activity',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final receipt in receipts.take(5)) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(receipt.store.name),
                subtitle: Text(receipt.createdAt.toReceiptLabel()),
                trailing: Text(
                  formatCurrency(
                    receipt.flowType == MoneyFlowType.expense
                        ? -receipt.total
                        : receipt.total,
                    currency: receipt.currency,
                  ),
                  style: TextStyle(
                    color: receipt.flowType == MoneyFlowType.expense
                        ? Colors.redAccent
                        : Colors.teal,
                    fontWeight: FontWeight.w600,
                  ),
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

class _AnalyticsSnapshot {
  _AnalyticsSnapshot({
    required this.totalExpenses,
    required this.totalIncome,
    required this.categoryTotals,
    required this.weeklyExpenses,
  });

  final double totalExpenses;
  final double totalIncome;
  final Map<SpendingCategory, double> categoryTotals;
  final List<_DailyPoint> weeklyExpenses;

  double get netBalance => totalIncome - totalExpenses;

  factory _AnalyticsSnapshot.fromReceipts(List<Receipt> receipts) {
    final expenses = receipts
        .where((receipt) => receipt.flowType == MoneyFlowType.expense)
        .fold<double>(0, (value, receipt) => value + receipt.total);
    final income = receipts
        .where((receipt) => receipt.flowType == MoneyFlowType.income)
        .fold<double>(0, (value, receipt) => value + receipt.total);

    final categoryTotals = <SpendingCategory, double>{};
    for (final receipt in receipts) {
      for (final item in receipt.items) {
        categoryTotals.update(
          item.category,
          (value) => value + (item.unitPrice * item.quantity),
          ifAbsent: () => item.unitPrice * item.quantity,
        );
      }
    }

    final now = DateTime.now();
    final lastWeek = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      final dayTotal = receipts
          .where((receipt) =>
              receipt.flowType == MoneyFlowType.expense &&
              receipt.createdAt.year == date.year &&
              receipt.createdAt.month == date.month &&
              receipt.createdAt.day == date.day)
          .fold<double>(0, (value, receipt) => value + receipt.total);
      return _DailyPoint(amount: dayTotal, date: date);
    });

    return _AnalyticsSnapshot(
      totalExpenses: expenses,
      totalIncome: income,
      categoryTotals: categoryTotals,
      weeklyExpenses: lastWeek,
    );
  }
}

class _DailyPoint {
  const _DailyPoint({required this.amount, required this.date});

  final double amount;
  final DateTime date;

  String get dateLabel => date.toGraphLabel();
}

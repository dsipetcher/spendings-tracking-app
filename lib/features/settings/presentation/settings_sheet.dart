import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/settings_controller.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

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
          Text(
            'Settings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Store original receipt images'),
            subtitle: const Text('Disable to save storage space'),
            value: settings.storeOriginalImages,
            onChanged: controller.setStoreOriginalImages,
          ),
          const SizedBox(height: 12),
          Text(
            'When disabled, images are processed in-memory and discarded after OCR. '
            'Already saved receipts keep their image references.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 20),
          Text('Base currency', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'USD', label: Text('USD')),
              ButtonSegment(value: 'EUR', label: Text('EUR')),
            ],
            selected: {settings.baseCurrency},
            onSelectionChanged: (selection) =>
                controller.setBaseCurrency(selection.first),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Personal currency'),
            subtitle: Text(
              settings.personalCurrency,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: TextButton(
              onPressed: () => showCurrencyPicker(
                context: context,
                showFlag: true,
                showSearchField: true,
                onSelect: (currency) =>
                    controller.setPersonalCurrency(currency.code),
              ),
              child: const Text('Change'),
            ),
          ),
          Text(
            'Spending totals are shown in the original receipt currency, your base (USD/EUR) '
            'and your personal currency for easier comparison.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

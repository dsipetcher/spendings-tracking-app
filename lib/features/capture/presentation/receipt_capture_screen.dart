import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../receipts/domain/models/receipt_models.dart';
import '../application/receipt_capture_controller.dart';

class ReceiptCaptureScreen extends ConsumerWidget {
  const ReceiptCaptureScreen({super.key});

  static const routeName = '/capture';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(receiptCaptureControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan receipt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () =>
                ref.read(receiptCaptureControllerProvider.notifier).reset(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _CaptureHero(state: state),
          const SizedBox(height: 20),
          _CaptureActions(state: state),
          const SizedBox(height: 20),
          state.maybeWhen(
            success: (draft, _) => _DraftPreview(draft: draft),
            completed: () => const _SuccessMessage(),
            failure: (message) => _ErrorCard(message: message),
            orElse: () => const _HintsCard(),
          ),
        ],
      ),
    );
  }
}

class _CaptureHero extends StatelessWidget {
  const _CaptureHero({required this.state});

  final ReceiptCaptureState state;

  @override
  Widget build(BuildContext context) {
    final processing = state.whenOrNull(processing: (_) => true) ?? false;
    final previewFile = state.whenOrNull(
      processing: (file) => file,
      success: (_, file) => file,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attach receipt',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (previewFile != null && !kIsWeb)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(previewFile.path),
                  height: 180,
                  fit: BoxFit.cover,
                ),
              )
            else
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.05),
                  ),
                  child: Icon(
                    processing
                        ? Icons.downloading
                        : Icons.receipt_long_outlined,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              processing
                  ? 'Reading text and detecting fields…'
                  : 'Use the camera or import from gallery',
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptureActions extends ConsumerWidget {
  const _CaptureActions({required this.state});

  final ReceiptCaptureState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(receiptCaptureControllerProvider.notifier);
    final picker = ImagePicker();
    final hasDraft = state.whenOrNull(success: (_, __) => true) ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: () async {
            final image = await picker.pickImage(source: ImageSource.camera);
            if (image != null) {
              controller.captureFromFile(image);
            }
          },
          icon: const Icon(Icons.photo_camera_outlined),
          label: const Text('Camera'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              controller.captureFromFile(image);
            }
          },
          icon: const Icon(Icons.photo_library_outlined),
          label: const Text('Gallery'),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () => controller.captureFromDemo(),
          icon: const Icon(Icons.auto_awesome),
          label: const Text('Use demo receipt'),
        ),
        if (hasDraft)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: FilledButton(
              onPressed: controller.commitDraft,
              child: const Text('Save to ledger'),
            ),
          ),
      ],
    );
  }
}

class _DraftPreview extends StatelessWidget {
  const _DraftPreview({required this.draft});

  final ReceiptDraft draft;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detected items',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            for (final item in draft.items) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(item.translatedName ?? item.name),
                subtitle: Text(item.category.name),
                trailing: Text(
                  formatCurrency(item.unitPrice * item.quantity,
                      currency: draft.currency),
                ),
              ),
              const Divider(),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Estimated total',
                    style: Theme.of(context).textTheme.titleMedium),
                Text(
                  formatCurrency(draft.total ?? 0, currency: draft.currency),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline,
                color: Theme.of(context).colorScheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HintsCard extends StatelessWidget {
  const _HintsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tips', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('• Place the receipt on a dark background'),
            const Text('• Ensure the totals area is in the frame'),
            const Text('• You can always fix extracted fields manually later'),
          ],
        ),
      ),
    );
  }
}

class _SuccessMessage extends StatelessWidget {
  const _SuccessMessage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.task_alt, color: Colors.teal.shade600, size: 64),
        const SizedBox(height: 12),
        const Text('Receipt saved!'),
        const Text('You can find it in the receipts tab.'),
      ],
    );
  }
}

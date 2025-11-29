// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:spendings_tracking_app/app.dart';
import 'package:spendings_tracking_app/core/constants/demo_receipts.dart';
import 'package:spendings_tracking_app/features/receipts/application/receipts_controller.dart';
import 'package:spendings_tracking_app/features/receipts/domain/models/receipt_models.dart';

void main() {
  testWidgets('Home shell renders overview and receipts tabs', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          receiptsProvider.overrideWith(_FakeReceiptsController.new),
        ],
        child: const SpendingsApp(),
      ),
    );

    expect(find.text('Overview'), findsWidgets);
    expect(find.text('Receipts'), findsWidgets);

    // Switch tab and expect to see the receipts list scaffold.
    await tester.tap(find.text('Receipts').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('Scan receipt'), findsOneWidget);
  });
}

class _FakeReceiptsController extends ReceiptsController {
  @override
  Future<List<Receipt>> build() async => DemoReceipts.initialPool;
}

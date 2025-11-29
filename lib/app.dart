import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/home/presentation/home_shell.dart';
import 'features/receipts/presentation/receipt_detail_screen.dart';
import 'features/capture/presentation/receipt_capture_screen.dart';

class SpendingsApp extends ConsumerWidget {
  const SpendingsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Spendings Tracking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case ReceiptDetailScreen.routeName:
            final receiptId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) => ReceiptDetailScreen(receiptId: receiptId),
            );
          case ReceiptCaptureScreen.routeName:
            return MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => const ReceiptCaptureScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const HomeShell(),
            );
        }
      },
      home: const HomeShell(),
    );
  }
}

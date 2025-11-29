import 'package:intl/intl.dart';

String formatCurrency(double amount, {String currency = 'USD'}) {
  final format = NumberFormat.simpleCurrency(name: currency);
  return format.format(amount);
}

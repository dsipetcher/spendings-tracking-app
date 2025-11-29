import 'package:intl/intl.dart';

extension DateFormattingX on DateTime {
  String toReceiptLabel() => DateFormat('d MMM, HH:mm').format(this);
  String toDayLabel() => DateFormat('EEE, d MMM').format(this);
  String toGraphLabel() => DateFormat('MMM d').format(this);
}

import 'package:intl/intl.dart';

final currency =
    NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2);

final dateWithoutTime = DateFormat('dd-MM-yyyy');

extension StringExtension on String {
  String capitalized() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

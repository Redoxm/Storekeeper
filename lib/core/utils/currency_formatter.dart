import 'package:intl/intl.dart';

class CurrencyFormatter {
  // Nigerian Naira formatter
  static final naira = NumberFormat.currency(symbol: '₦', decimalDigits: 0);

  // Format with thousand separators
  static String formatNaira(double amount) {
    return naira.format(amount);
  }

  // Format without decimals
  static String formatNairaCompact(double amount) {
    if (amount >= 1000000) {
      return '₦${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '₦${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '₦${amount.toStringAsFixed(0)}';
  }
}

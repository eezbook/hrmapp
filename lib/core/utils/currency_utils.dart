import 'package:intl/intl.dart';

abstract class CurrencyUtils {
  static NumberFormat? _pkrFormatter;

  static String formatPkr(num amount) {
    _pkrFormatter ??= _buildFormatter();
    return _pkrFormatter!.format(amount);
  }

  static NumberFormat _buildFormatter() {
    try {
      return NumberFormat.currency(locale: 'ur_PK', symbol: 'PKR ');
    } catch (_) {
      return NumberFormat.currency(locale: 'en_US', symbol: 'PKR ');
    }
  }

  static String formatShort(num amount) {
    if (amount >= 1000000) {
      return 'PKR ${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return 'PKR ${(amount / 1000).toStringAsFixed(1)}K';
    }
    return formatPkr(amount);
  }
}

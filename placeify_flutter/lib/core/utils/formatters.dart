abstract final class Formatters {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// Nepali Rupee prefix (ISO 4217: NPR).
  static const String nprPrefix = 'NPR ';

  static String currency(double amount) {
    if (amount >= 1000) {
      return '$nprPrefix${(amount / 1000).toStringAsFixed(1)}k';
    }
    return '$nprPrefix${amount.toInt()}';
  }

  static String currencyFull(double amount) =>
      '$nprPrefix${_insertThousandsSeparator(amount.toInt().toString())}';

  /// Cart / checkout — always two decimal places (e.g. NPR 199.00).
  static String currencyDecimal(double amount) {
    final fixed = amount.toStringAsFixed(2);
    final parts = fixed.split('.');
    final whole = parts[0];
    final frac = parts[1];
    final withCommas = _insertThousandsSeparator(whole);
    return '$nprPrefix$withCommas.$frac';
  }

  /// Discount / deduction row (e.g. - NPR 566.00).
  static String currencyDecimalDiscount(double amount) =>
      '- ${currencyDecimal(amount)}';

  static String _insertThousandsSeparator(String digits) {
    if (digits.length <= 3) return digits;
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  static String shortDate(DateTime date) {
    return '${_months[date.month - 1]} ${date.day}';
  }

  static String shortDateTime(DateTime date) {
    final local = date.toLocal();
    final hour24 = local.hour;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    return '${_months[local.month - 1]} ${local.day}, ${local.year} · '
        '$hour12:$minute $period';
  }

  static String orderMeta(String orderNumber, DateTime date) {
    return 'Order #$orderNumber · ${shortDate(date)}';
  }
}

import 'package:intl/intl.dart';

class NumberFormatter {
  /// تنسيق السعر مع فواصل للأرقام الكبيرة
  /// مثال: 1000 -> "1,000"
  static String formatPrice(double price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price);
  }

  /// تنسيق أي رقم مع فواصل للأرقام الكبيرة
  /// مثال: 1000 -> "1,000"
  static String formatNumber(num number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  /// تنسيق السعر مع فواصل وبدون كسور عشرية
  /// مثال: 1000.5 -> "1,000"
  static String formatPriceNoDecimals(double price) {
    final formatter = NumberFormat('#,###');
    return formatter.format(price.round());
  }
}






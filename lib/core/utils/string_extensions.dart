extension StringExtensions on String {
  /// تنظيف اسم الطابق من المسافات الزائدة والأحرف الخاصة
  String cleanFloorName() {
    // إزالة المسافات الزائدة من البداية والنهاية
    String cleaned = trim();

    // إزالة الأحرف الخاصة مثل \r
    cleaned = cleaned.replaceAll('\r', '');

    // استخراج اسم الطابق فقط (قبل "م:-" أو أي معلومات إضافية)
    if (cleaned.contains('م:-')) {
      cleaned = cleaned.split('م:-').first.trim();
    }

    // إزالة المسافات الزائدة مرة أخرى
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleaned;
  }
}

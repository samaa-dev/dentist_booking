/// Algerian Arabic month names (French-derived), used across date pickers.
abstract final class AlgerianMonths {
  static const names = <String>[
    'جانفي',
    'فيفري',
    'مارس',
    'أفريل',
    'ماي',
    'جوان',
    'جويلية',
    'أوت',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  /// [month] is 1–12.
  static String nameOf(int month) {
    if (month < 1 || month > 12) return month.toString();
    return names[month - 1];
  }
}

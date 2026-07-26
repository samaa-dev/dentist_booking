/// Forces Western/Latin digits (0-9) regardless of Arabic locale shaping.
String toLatinDigits(String input) {
  const eastern = '٠١٢٣٤٥٦٧٨٩';
  const persian = '۰۱۲۳۴۵۶۷۸۹';
  const western = '0123456789';

  final buffer = StringBuffer();
  for (final unit in input.runes) {
    final ch = String.fromCharCode(unit);
    final e = eastern.indexOf(ch);
    if (e >= 0) {
      buffer.write(western[e]);
      continue;
    }
    final p = persian.indexOf(ch);
    if (p >= 0) {
      buffer.write(western[p]);
      continue;
    }
    buffer.write(ch);
  }
  return buffer.toString();
}

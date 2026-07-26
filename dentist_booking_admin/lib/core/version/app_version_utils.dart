enum AppVersionTarget {
  patient,
  admin,
  desktop,
  tv,
}

extension AppVersionTargetKey on AppVersionTarget {
  String get jsonKey {
    switch (this) {
      case AppVersionTarget.patient:
        return 'min_version_patient';
      case AppVersionTarget.admin:
        return 'min_version_admin';
      case AppVersionTarget.desktop:
        return 'min_version_desktop';
      case AppVersionTarget.tv:
        return 'min_version_tv';
    }
  }
}

int compareSemver(String current, String minimum) {
  List<int> parse(String raw) {
    final cleaned =
        raw.trim().replaceFirst(RegExp(r'^v', caseSensitive: false), '');
    if (cleaned.isEmpty) return [0];
    return cleaned
        .split(RegExp(r'[^0-9]+'))
        .where((p) => p.isNotEmpty)
        .map((p) => int.tryParse(p) ?? 0)
        .toList();
  }

  final a = parse(current);
  final b = parse(minimum);
  final len = a.length > b.length ? a.length : b.length;
  for (var i = 0; i < len; i++) {
    final ai = i < a.length ? a[i] : 0;
    final bi = i < b.length ? b[i] : 0;
    if (ai != bi) return ai.compareTo(bi);
  }
  return 0;
}

bool isVersionOutdated({
  required String current,
  required String? minimum,
}) {
  if (minimum == null || minimum.trim().isEmpty) return false;
  return compareSemver(current, minimum) < 0;
}

import 'package:flutter/material.dart';

/// Desktop update screen — hardcoded Arabic (no EasyLocalization dependency here).
class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({
    super.key,
    required this.currentVersion,
    required this.minimumVersion,
  });

  final String currentVersion;
  final String minimumVersion;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.system_update_alt_rounded,
                    size: 52,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'يلزم تحديث التطبيق',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'الإصدار الحالي ($currentVersion) لا يلبّي الحد الأدنى المطلوب ($minimumVersion). '
                  'يُرجى تثبيت أحدث إصدار من لوحة الإدارة لمتابعة العمل بأمان واستقرار.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    height: 1.55,
                    color: colorScheme.onSurface.withOpacity(0.72),
                  ),
                ),
                const SizedBox(height: 28),
                _chip(context, 'الإصدار الحالي', 'v$currentVersion'),
                const SizedBox(height: 10),
                _chip(
                  context,
                  'الحد الأدنى المطلوب',
                  'v$minimumVersion',
                  emphasized: true,
                ),
                const SizedBox(height: 28),
                Text(
                  'يرجى التواصل مع مسؤول النظام للحصول على أحدث إصدار وتثبيته على هذا الجهاز.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(
    BuildContext context,
    String label,
    String value, {
    bool emphasized = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: emphasized
            ? colorScheme.primary.withOpacity(0.12)
            : colorScheme.surfaceContainerHighest.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: emphasized
              ? colorScheme.primary.withOpacity(0.35)
              : colorScheme.outline.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: emphasized ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

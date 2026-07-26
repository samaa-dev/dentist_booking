import 'package:flutter/material.dart';

/// TV update screen — hardcoded Arabic.
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
      backgroundColor: colorScheme.surface,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.system_update_alt_rounded,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'يلزم تحديث تطبيق الشاشة',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'الإصدار الحالي ($currentVersion) أقل من الحد الأدنى المطلوب ($minimumVersion). '
                  'يرجى تثبيت أحدث إصدار من تطبيق الشاشة لاستئناف العرض.',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    height: 1.6,
                    color: colorScheme.onSurface.withOpacity(0.72),
                  ),
                ),
                const SizedBox(height: 36),
                Row(
                  children: [
                    Expanded(
                      child: _chip(
                        context,
                        'الإصدار الحالي',
                        'v$currentVersion',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _chip(
                        context,
                        'الحد الأدنى',
                        'v$minimumVersion',
                        emphasized: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  'يرجى التواصل مع مسؤول العيادة لتحديث هذا الجهاز.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: emphasized
            ? colorScheme.primary.withOpacity(0.12)
            : colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: emphasized
              ? colorScheme.primary.withOpacity(0.35)
              : colorScheme.outline.withOpacity(0.12),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: emphasized ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

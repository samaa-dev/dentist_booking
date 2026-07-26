import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/core/util/info_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../generated/locale_keys.g.dart';

class DentistInfoCard extends StatelessWidget {
  const DentistInfoCard({super.key, this.clinicPhone});

  /// Clinic phone from settings. If null or empty, fallback to default number.
  final String? clinicPhone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Positioned(
      top: 88,
      left: 16,
      right: 16,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        tween: Tween(begin: 0, end: 1),
        curve: Curves.easeOut,
        builder: (context, value, child) => Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: Opacity(opacity: value, child: child),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.surface,
                colorScheme.surface.withOpacity(0.96),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.10),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  "assets/images/logo.png", // تأكد من مطابقة المسار هنا لما هو موجود في pubspec.yaml
                  width: 40,
                  height: 40,
                  color: colorScheme.primary,
                  // يفضل إضافة errorBuilder لتجنب كراش التطبيق مستقبلاً
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.specialized_clinic.trnsltd,
                      style: textTheme.labelMedium!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      LocaleKeys.dr_kheireddine_clinic.trnsltd,
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          LocaleKeys.dental_specialist.trnsltd,
                          style: textTheme.bodySmall!.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              IconButton(
                style: IconButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  backgroundColor: colorScheme.primary.withOpacity(0.1),
                ),
                onPressed: () => SnackbarMes.launchCallPhone(
                  phoneNumber: (clinicPhone?.trim().isNotEmpty == true
                      ? clinicPhone!.trim()
                      : '+2130675677070'),
                ),
                icon: const Icon(size: 20, HugeIcons.strokeRoundedCall02),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

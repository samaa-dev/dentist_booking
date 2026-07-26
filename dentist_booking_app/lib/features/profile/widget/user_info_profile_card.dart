import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/features/auth/blocs/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../../generated/locale_keys.g.dart';

class UserInfoProfileCard extends StatelessWidget {
  const UserInfoProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        final user = Supabase.instance.client.auth.currentUser;
        final meta = user?.userMetadata ?? {};

        final raw = state.mapOrNull(
              status: (value) =>
                  value.data is Map && value.data['raw_user_meta_data'] is Map
                      ? Map<String, dynamic>.from(
                          value.data['raw_user_meta_data'] as Map,
                        )
                      : null,
            ) ??
            <String, dynamic>{};

        final fullName =
            _stringOrNull(raw['full_name'])?.trim().isNotEmpty == true
                ? raw['full_name'] as String
                : LocaleKeys.user_default_name.trnsltd;
        final phone = _stringOrNull(raw['phone'])?.trim();

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
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(2),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.primary,
                  backgroundImage: meta['avatar_url'] != null ? NetworkImage(meta['avatar_url']) : null,
                  child: meta['avatar_url'] == null
                      ? Icon(
                          HugeIcons.strokeRoundedUserCircle,
                          color: colorScheme.primary.withOpacity(0.8),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.navigation_bar_profile.trnsltd,
                      style: textTheme.labelMedium!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fullName,
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (phone != null && phone.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: colorScheme.outline.withOpacity(0.2),
                      ),
                      const SizedBox(height: 12),
                      _profileDetailRow(
                        context,
                        icon: HugeIcons.strokeRoundedSmartPhone01,
                        label: LocaleKeys.phone.trnsltd,
                        value: _formatPhoneForDisplay(phone),
                        textTheme: textTheme,
                        colorScheme: colorScheme,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
      },
    );
  }

  static String? _stringOrNull(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }

  /// ينسق رقم الهاتف للعرض: إذا كان 9 أرقام يضيف 0 في البداية (مثلاً 656903182 -> 0656903182).
  static String _formatPhoneForDisplay(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 9 && !phone.trimLeft().startsWith('0')) {
      return '0$digits';
    }
    return phone;
  }

  static Widget _profileDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required TextTheme textTheme,
    required ColorScheme colorScheme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

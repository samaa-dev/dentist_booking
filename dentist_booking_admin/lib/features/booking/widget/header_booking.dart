import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/features/booking/widget/booking_form_dialog.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/booking/booking_cubit.dart';

class BookingHeader extends StatelessWidget {
  const BookingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final cubit = context.watch<BookingCubit>();
    final state = cubit.state.maybeWhen(
      orElse: () => false,
      loaded: (bookings) => true,
    );

    return Row(
      children: [
        Text(
          LocaleKeys.booking_management.trnsltd,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const Spacer(),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
              child: child,
            );
          },
          child: ElevatedButton.icon(
            key: ValueKey(state),
            style: ElevatedButton.styleFrom(
              backgroundColor: state
                  ? colorScheme.primary
                  : colorScheme.surface.withOpacity(0.3),
              foregroundColor: state
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface.withOpacity(0.4),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.add),
            label: Text(LocaleKeys.booking_add.trnsltd),
            onPressed: state
                ? () => showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<BookingCubit>(),
                      child: const BookingFormDialog(),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

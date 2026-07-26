import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/booking/booking_cubit.dart';
import 'booking_item.dart';
import 'booking_item_shimmer.dart';
import 'empty_booking.dart';
import 'error_booking.dart';

class BookingStatusListView extends StatelessWidget {
  const BookingStatusListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (previous, current) {
        return current.maybeWhen(
          orElse: () => false,
          loading: () => true,
          loaded: (_) => true,
          error: (_) => true,
        );
      },

      builder: (context, state) {
        return state.maybeWhen(
          loading: () => ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: 5,
            itemBuilder: (context, index) => const BookingItemShimmer(),
          ),

          loaded: (bookings) {
            if (bookings.isEmpty) return const EmptyBooking();

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BookingItem(booking: booking),
                );
              },
            );
          },

          error: (message) => ErrorBooking(message: message),
          orElse: () => const EmptyBooking(),
        );
      },
    );
  }
}

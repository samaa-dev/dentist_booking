import 'package:dentist_booking_app/core/enum/enum.dart';
import 'package:dentist_booking_app/core/model/booking_model.dart';
import 'package:dentist_booking_app/core/model/tracking_model.dart';
import 'package:dentist_booking_app/features/booking/repo/booking_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QueueRepo {
  final SupabaseClient _client;
  final BookingRepo _bookingRepo;

  QueueRepo({
    required SupabaseClient client,
    required BookingRepo bookingRepo,
  }) : _client = client,
       _bookingRepo = bookingRepo;

  Stream<List<Map<String, dynamic>>> watchBookings() {
    return _bookingRepo.watchBookings();
  }

  Stream<List<Map<String, dynamic>>> watchQueueState() {
    return _client.from('queue_state').stream(primaryKey: ['shift']);
  }

  Future<TrackingModel?> getBookingQueue({required String ticketCode}) async {
    try {
      final response = await _client.rpc(
        'get_booking_tracking',
        params: {
          'ticket_code_param': ticketCode,
        },
      );

      debugPrint("Response TrackinModel: $response");

      if (response == null) {
        return null;
      } else {
        return TrackingModel.fromJson(response);
      }
    } catch (e) {
      debugPrint("Failed to fetch tracking details: $e");
      throw Exception('Failed to fetch tracking details: $e');
    }
  }

  /// Bookings shown on today's home panel: active + already called.
  bool _isTodayHomeVisibleBooking(BookingModel booking) {
    final status = booking.bookingStatus;
    final isVisibleStatus = status == BookingStatus.pending ||
        status == BookingStatus.confirmed ||
        status == BookingStatus.completed ||
        status == BookingStatus.noShow;
    final hasTicket =
        booking.ticketCode != null && booking.ticketCode!.isNotEmpty;
    return isVisibleStatus && hasTicket;
  }

  Future<TrackingModel?> getActiveBookingQueue() async {
    try {
      final today = DateTime.now();

      // جلب حجوزات المستخدم لليوم الحالي
      final bookings = await _bookingRepo.getBookings(
        startDate: DateTime(today.year, today.month, today.day),
        endDate: DateTime(today.year, today.month, today.day, 23, 59, 59),
        searchQuery: null,
      );

      // نشط أو تم استدعاؤه اليوم (completed / noShow)
      BookingModel? activeBooking;
      try {
        activeBooking = bookings.firstWhere(_isTodayHomeVisibleBooking);
      } catch (e) {
        return null;
      }

      return await getBookingQueue(ticketCode: activeBooking.ticketCode!);
    } catch (e) {
      debugPrint("Failed to fetch active booking queue: $e");
      return null;
    }
  }

  Future<List<TrackingModel>> getAllActiveBookingQueues() async {
    try {
      final today = DateTime.now();

      // جلب حجوزات المستخدم لليوم الحالي
      final bookings = await _bookingRepo.getBookings(
        startDate: DateTime(today.year, today.month, today.day),
        endDate: DateTime(today.year, today.month, today.day, 23, 59, 59),
        searchQuery: null,
      );

      final visibleBookings =
          bookings.where(_isTodayHomeVisibleBooking).toList();

      if (visibleBookings.isEmpty) {
        return [];
      }

      final List<TrackingModel> queues = [];
      for (final booking in visibleBookings) {
        try {
          final queue = await getBookingQueue(ticketCode: booking.ticketCode!);
          if (queue != null) {
            queues.add(queue);
          }
        } catch (e) {
          debugPrint("Failed to fetch queue for ticket ${booking.ticketCode}: $e");
        }
      }

      return queues;
    } catch (e) {
      debugPrint("Failed to fetch all active booking queues: $e");
      return [];
    }
  }

  Future<bool> hasActiveBookingForCurrentUser() async {
    try {
      final today = DateTime.now();
      
      // جلب حجوزات المستخدم لليوم الحالي
      final bookings = await _bookingRepo.getBookings(
        startDate: DateTime(today.year, today.month, today.day),
        endDate: DateTime(today.year, today.month, today.day, 23, 59, 59),
        searchQuery: null,
      );

      // البحث عن حجز فعال للمستخدم نفسه
      // بما أن patientId دائماً currentUserId (حتى عند الحجز لشخص آخر)
      // نتحقق من patientName == null للتمييز بين الحجز للمستخدم نفسه والحجز لشخص آخر
      final hasActiveBooking = bookings.any(
        (booking) =>
            (booking.bookingStatus == BookingStatus.pending ||
                booking.bookingStatus == BookingStatus.confirmed) &&
            booking.patientName == null, // patientName == null يعني الحجز للمستخدم نفسه وليس لشخص آخر
      );

      return hasActiveBooking;
    } catch (e) {
      debugPrint("Failed to check active booking for current user: $e");
      return false;
    }
  }
}

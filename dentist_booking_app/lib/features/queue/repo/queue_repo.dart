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

  Future<TrackingModel?> getActiveBookingQueue() async {
    try {
      final today = DateTime.now();
      
      // جلب حجوزات المستخدم لليوم الحالي
      final bookings = await _bookingRepo.getBookings(
        startDate: DateTime(today.year, today.month, today.day),
        endDate: DateTime(today.year, today.month, today.day, 23, 59, 59),
        searchQuery: null,
      );

      // البحث عن حجز فعال (pending أو confirmed)
      BookingModel? activeBooking;
      try {
        activeBooking = bookings.firstWhere(
          (booking) =>
              booking.bookingStatus == BookingStatus.pending ||
              booking.bookingStatus == BookingStatus.confirmed,
        );
      } catch (e) {
        // لا يوجد حجز فعال
        return null;
      }

      // إذا لم يكن هناك ticketCode، إرجاع null
      if (activeBooking.ticketCode == null || activeBooking.ticketCode!.isEmpty) {
        return null;
      }

      // جلب معلومات الطابور باستخدام ticketCode
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

      // فلترة الحجوزات الفعالة (pending أو confirmed)
      final activeBookings = bookings.where(
        (booking) =>
            (booking.bookingStatus == BookingStatus.pending ||
                booking.bookingStatus == BookingStatus.confirmed) &&
            booking.ticketCode != null &&
            booking.ticketCode!.isNotEmpty,
      ).toList();

      if (activeBookings.isEmpty) {
        return [];
      }

      // جلب معلومات الطابور لكل حجز فعال
      final List<TrackingModel> queues = [];
      for (final booking in activeBookings) {
        try {
          final queue = await getBookingQueue(ticketCode: booking.ticketCode!);
          if (queue != null) {
            queues.add(queue);
          }
        } catch (e) {
          debugPrint("Failed to fetch queue for ticket ${booking.ticketCode}: $e");
          // نستمر في الحلقة حتى لو فشل حجز واحد
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

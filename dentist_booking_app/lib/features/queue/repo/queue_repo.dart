import 'package:dentist_booking_app/core/enum/enum.dart';
import 'package:dentist_booking_app/core/model/booking_model.dart';
import 'package:dentist_booking_app/core/model/queue_stats_model.dart';
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
      }

      final map = response is Map<String, dynamic>
          ? response
          : Map<String, dynamic>.from(response as Map);
      return TrackingModel.fromJson(map);
    } catch (e) {
      debugPrint("Failed to fetch tracking details: $e");
      throw Exception('Failed to fetch tracking details: $e');
    }
  }

  /// Minimal tracking from list row when get_booking_tracking fails.
  TrackingModel _fallbackTrackingFromBooking(BookingModel booking) {
    final peopleBefore = booking.peopleBefore ?? 0;
    return TrackingModel(
      booking: booking,
      queueStats: QueueStatsModel(
        isPaused: false,
        currentQueueNumber: 0,
        patientsBeforeYou: peopleBefore,
        lastUpdated: DateTime.now(),
        totalInQueue: peopleBefore + 1,
        estimatedWaitTime: peopleBefore * 15,
      ),
    );
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

  bool _isSameLocalDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<TrackingModel?> getActiveBookingQueue() async {
    try {
      final today = DateTime.now();

      final bookings = await _bookingRepo.getBookings(
        startDate: DateTime(today.year, today.month, today.day),
        endDate: DateTime(today.year, today.month, today.day, 23, 59, 59),
        searchQuery: null,
      );

      BookingModel? activeBooking;
      try {
        activeBooking = bookings.firstWhere(_isTodayHomeVisibleBooking);
      } catch (e) {
        return null;
      }

      try {
        final queue =
            await getBookingQueue(ticketCode: activeBooking.ticketCode!);
        return queue ?? _fallbackTrackingFromBooking(activeBooking);
      } catch (e) {
        debugPrint(
          "Tracking failed for ${activeBooking.ticketCode}, using fallback: $e",
        );
        return _fallbackTrackingFromBooking(activeBooking);
      }
    } catch (e) {
      debugPrint("Failed to fetch active booking queue: $e");
      return null;
    }
  }

  Future<List<TrackingModel>> getAllActiveBookingQueues() async {
    try {
      final today = DateTime.now();

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
          queues.add(queue ?? _fallbackTrackingFromBooking(booking));
        } catch (e) {
          debugPrint(
            "Failed to fetch queue for ticket ${booking.ticketCode}: $e — using list fallback",
          );
          queues.add(_fallbackTrackingFromBooking(booking));
        }
      }

      return queues;
    } catch (e) {
      debugPrint("Failed to fetch all active booking queues: $e");
      return [];
    }
  }

  /// Self-booking = empty guest_name (same rule as create_booking server check).
  /// List RPC always fills patient_name from profile, so patientName == null is wrong.
  Future<bool> hasActiveBookingForCurrentUser() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;

      final today = DateTime.now();
      final rows = await _client
          .from('bookings')
          .select('id, guest_name, booking_status, booking_date')
          .eq('patient_id', userId)
          .inFilter('booking_status', ['pending', 'confirmed']);

      return rows.any((row) {
        final guestName = (row['guest_name'] as String?)?.trim() ?? '';
        if (guestName.isNotEmpty) return false;

        final rawDate = row['booking_date'];
        if (rawDate == null) return false;
        final bookingDate = DateTime.tryParse(rawDate.toString());
        if (bookingDate == null) return false;
        return _isSameLocalDay(bookingDate, today);
      });
    } catch (e) {
      debugPrint("Failed to check active booking for current user: $e");
      return false;
    }
  }
}

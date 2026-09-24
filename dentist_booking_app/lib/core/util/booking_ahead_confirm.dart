import '../../generated/locale_keys.g.dart';

/// Helpers for the pre-create booking confirmation dialog.
abstract final class BookingAheadConfirm {
  /// Locale key for the confirm body based on people ahead count.
  static String messageKey(int peopleAhead) {
    if (peopleAhead <= 0) {
      return LocaleKeys.booking_ahead_first_message;
    }
    return LocaleKeys.booking_ahead_confirm_message;
  }

  static bool isFirstInLine(int peopleAhead) => peopleAhead <= 0;
}

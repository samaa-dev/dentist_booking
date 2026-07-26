/// Shared Arabic copy for TV queue display widgets.
abstract final class TvDisplayStrings {
  static const directionToDoctor = 'يرجى التوجه إلى الطبيب';

  /// Spoken when a new queue turn is called (TTS).
  static String queueTurnAnnouncement(int turnNumber) =>
      'صاحب الدور $turnNumber يرجى التوجه إلى مكتب الطبيب';
}

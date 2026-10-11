/// Parsed result of the `get_clinic_statistics` RPC.
class ClinicStatistics {
  const ClinicStatistics({
    required this.from,
    required this.to,
    required this.days,
    required this.workingDays,
    required this.total,
    required this.status,
    required this.morning,
    required this.evening,
    required this.fromPatientApp,
    required this.fromClinic,
    required this.forOthers,
    required this.busiestDay,
    required this.busiestDayTotal,
    required this.previous,
    required this.daily,
    required this.weekday,
    required this.patientsRegistered,
    required this.patientsNew,
    required this.patientsActive,
    required this.today,
  });

  final DateTime from;
  final DateTime to;
  final int days;
  final int workingDays;
  final int total;
  final StatusCounts status;
  final int morning;
  final int evening;
  final int fromPatientApp;
  final int fromClinic;
  final int forOthers;
  final DateTime? busiestDay;
  final int busiestDayTotal;
  final PeriodTotals previous;
  final List<DailyPoint> daily;
  final List<WeekdayPoint> weekday;
  final int patientsRegistered;
  final int patientsNew;
  final int patientsActive;
  final TodaySnapshot today;

  int get cancelled => status.cancelledByPatient + status.cancelledByStaff;

  double rate(int part) => total == 0 ? 0 : part / total;

  double get averagePerWorkingDay => workingDays == 0 ? 0 : total / workingDays;

  factory ClinicStatistics.fromJson(Map<String, dynamic> json) {
    final period = _map(json['period']);
    final bookings = _map(json['bookings']);
    final byShift = _map(bookings['by_shift']);
    final bySource = _map(bookings['by_source']);
    final busiest = _map(bookings['busiest_day']);
    final patients = _map(json['patients']);

    return ClinicStatistics(
      from: DateTime.parse('${period['from']}'),
      to: DateTime.parse('${period['to']}'),
      days: _int(period['days']),
      workingDays: _int(period['working_days']),
      total: _int(bookings['total']),
      status: StatusCounts.fromJson(_map(bookings['by_status'])),
      morning: _int(byShift['morning']),
      evening: _int(byShift['evening']),
      fromPatientApp: _int(bySource['patient_app']),
      fromClinic: _int(bySource['clinic']),
      forOthers: _int(bookings['for_others']),
      busiestDay: DateTime.tryParse('${busiest['date']}'),
      busiestDayTotal: _int(busiest['total']),
      previous: PeriodTotals.fromJson(_map(json['previous'])),
      daily: (json['daily'] as List? ?? const [])
          .map((e) => DailyPoint.fromJson(_map(e)))
          .toList(),
      weekday: (json['weekday'] as List? ?? const [])
          .map((e) => WeekdayPoint.fromJson(_map(e)))
          .toList(),
      patientsRegistered: _int(patients['registered_total']),
      patientsNew: _int(patients['new_in_period']),
      patientsActive: _int(patients['active_in_period']),
      today: TodaySnapshot.fromJson(_map(json['today'])),
    );
  }
}

class StatusCounts {
  const StatusCounts({
    required this.pending,
    required this.confirmed,
    required this.completed,
    required this.noShow,
    required this.cancelledByPatient,
    required this.cancelledByStaff,
  });

  final int pending;
  final int confirmed;
  final int completed;
  final int noShow;
  final int cancelledByPatient;
  final int cancelledByStaff;

  factory StatusCounts.fromJson(Map<String, dynamic> json) => StatusCounts(
    pending: _int(json['pending']),
    confirmed: _int(json['confirmed']),
    completed: _int(json['completed']),
    noShow: _int(json['no_show']),
    cancelledByPatient: _int(json['cancelled_by_patient']),
    cancelledByStaff: _int(json['cancelled_by_staff']),
  );
}

class PeriodTotals {
  const PeriodTotals({
    required this.total,
    required this.completed,
    required this.noShow,
    required this.cancelled,
  });

  final int total;
  final int completed;
  final int noShow;
  final int cancelled;

  factory PeriodTotals.fromJson(Map<String, dynamic> json) => PeriodTotals(
    total: _int(json['total']),
    completed: _int(json['completed']),
    noShow: _int(json['no_show']),
    cancelled: _int(json['cancelled']),
  );
}

class DailyPoint {
  const DailyPoint({
    required this.date,
    required this.total,
    required this.completed,
    required this.cancelled,
    required this.noShow,
  });

  final DateTime date;
  final int total;
  final int completed;
  final int cancelled;
  final int noShow;

  factory DailyPoint.fromJson(Map<String, dynamic> json) => DailyPoint(
    date: DateTime.parse('${json['date']}'),
    total: _int(json['total']),
    completed: _int(json['completed']),
    cancelled: _int(json['cancelled']),
    noShow: _int(json['no_show']),
  );
}

class WeekdayPoint {
  const WeekdayPoint({
    required this.dayOfWeek,
    required this.total,
    required this.average,
  });

  /// Clinic numbering: Saturday = 1 ... Friday = 7.
  final int dayOfWeek;
  final int total;
  final double average;

  factory WeekdayPoint.fromJson(Map<String, dynamic> json) => WeekdayPoint(
    dayOfWeek: _int(json['day_of_week']),
    total: _int(json['total']),
    average: (json['average'] as num?)?.toDouble() ?? 0,
  );
}

class TodaySnapshot {
  const TodaySnapshot({
    required this.total,
    required this.waiting,
    required this.completed,
    required this.noShow,
    required this.cancelled,
    required this.morning,
    required this.evening,
  });

  final int total;
  final int waiting;
  final int completed;
  final int noShow;
  final int cancelled;
  final int morning;
  final int evening;

  factory TodaySnapshot.fromJson(Map<String, dynamic> json) => TodaySnapshot(
    total: _int(json['total']),
    waiting: _int(json['waiting']),
    completed: _int(json['completed']),
    noShow: _int(json['no_show']),
    cancelled: _int(json['cancelled']),
    morning: _int(json['morning']),
    evening: _int(json['evening']),
  );
}

Map<String, dynamic> _map(Object? v) =>
    v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};

int _int(Object? v) => v is num ? v.toInt() : int.tryParse('$v') ?? 0;

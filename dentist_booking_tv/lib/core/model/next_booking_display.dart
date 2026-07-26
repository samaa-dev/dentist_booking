/// Minimal model for next_booking from queue_status (TV display only).
class NextBookingDisplay {
  const NextBookingDisplay({
    this.queueNumber,
    this.patientName,
    this.ticketCode,
  });

  final String? queueNumber;
  final String? patientName;
  final String? ticketCode;

  factory NextBookingDisplay.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const NextBookingDisplay();
    final q = json['queue_number'];
    return NextBookingDisplay(
      queueNumber: q?.toString(),
      patientName: json['patient_name'] as String?,
      ticketCode: json['ticket_code'] as String?,
    );
  }
}

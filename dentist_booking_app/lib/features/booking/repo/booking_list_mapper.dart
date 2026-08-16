import '../../../core/model/booking_model.dart';

/// Maps patient-app booking list RPC rows into [BookingModel]s.
///
/// Keeps UUID-like fields as strings and preserves the original error when
/// the response shape is wrong (empty list vs hard failure).
class BookingListMapper {
  const BookingListMapper._();

  static List<BookingModel> mapRpcResponse(dynamic response) {
    if (response == null) {
      return const [];
    }
    if (response is! List) {
      throw FormatException(
        'Expected List from bookings RPC, got ${response.runtimeType}',
      );
    }
    if (response.isEmpty) {
      return const [];
    }

    return response.map((item) {
      if (item is! Map) {
        throw FormatException(
          'Expected Map booking row, got ${item.runtimeType}',
        );
      }
      return BookingModel.fromJson(_normalizeRow(Map<String, dynamic>.from(item)));
    }).toList();
  }

  static Map<String, dynamic> _normalizeRow(Map<String, dynamic> row) {
    return {
      ...row,
      'id': row['id']?.toString(),
      'patient_id': row['patient_id']?.toString(),
      'booking_created_by': row['booking_created_by']?.toString(),
      'cancelled_by': row['cancelled_by']?.toString(),
      'queue_number': row['queue_number']?.toString(),
    };
  }
}

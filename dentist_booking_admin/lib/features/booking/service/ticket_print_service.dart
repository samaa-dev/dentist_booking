import 'dart:io';
import 'dart:typed_data';

import 'package:dentist_booking_admin/core/model/booking_model.dart';
import 'package:dentist_booking_admin/features/booking/service/ticket_pdf_service.dart';
import 'package:dentist_booking_admin/features/settings/repo/settings_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:printing_ffi/printing_ffi.dart' as pffi;

/// Handles printing a booking ticket: builds PDF, lists printers, and prints to selected or fallback.
class TicketPrintService {
  TicketPrintService({
    TicketPdfService? ticketPdfService,
    SettingsRepo? settingsRepo,
  })  : _ticketPdfService = ticketPdfService ?? TicketPdfService(),
        _settingsRepo = settingsRepo;

  final TicketPdfService _ticketPdfService;
  final SettingsRepo? _settingsRepo;

  /// Cached ticket footer note (synced from settings, refreshed before print when possible).
  String? ticketNote;

  /// Returns list of available printers (from printing_ffi). Empty list on unsupported platform or error.
  List<pffi.Printer> listPrinters() {
    try {
      return pffi.PrintingFfi.instance.listPrinters();
    } catch (e) {
      debugPrint('[TicketPrintService] listPrinters failed: $e');
      return [];
    }
  }

  Future<String?> _resolveTicketNote() async {
    final repo = _settingsRepo;
    if (repo == null) return ticketNote;
    try {
      final config = await repo.getSettings();
      ticketNote = config.settings.ticketNote;
    } catch (e) {
      debugPrint('[TicketPrintService] failed to refresh ticketNote: $e');
    }
    return ticketNote;
  }

  /// Prints ticket PDF to the given printer by name. Throws on failure.
  Future<void> printTicketToPrinter(BookingModel booking, String printerName) async {
    final note = await _resolveTicketNote();
    final bytes = await _ticketPdfService.buildTicketPdf(
      booking,
      ticketNote: note,
    );
    final name = 'booking-ticket-${booking.ticketCode ?? booking.id}';
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/$name.pdf';
    await File(path).writeAsBytes(bytes);
    try {
      final ok = await pffi.PrintingFfi.instance.printPdf(
        printerName,
        path,
        docName: name,
      );
      if (!ok) throw Exception('printPdf returned false');
      debugPrint('[TicketPrintService] printed to $printerName');
    } finally {
      try {
        await File(path).delete();
      } catch (_) {}
    }
  }

  /// Builds the ticket PDF and opens the platform print dialog (or fallback: save+open on macOS).
  /// Returns normally if print was sent or user completed the dialog; throws on failure.
  Future<void> printTicket(BookingModel booking) async {
    debugPrint('[TicketPrintService] printTicket started for booking id=${booking.id} ticketCode=${booking.ticketCode}');
    Uint8List bytes;
    try {
      final note = await _resolveTicketNote();
      bytes = await _ticketPdfService.buildTicketPdf(
        booking,
        ticketNote: note,
      );
      debugPrint('[TicketPrintService] PDF built successfully, size=${bytes.length} bytes');
    } catch (e, stack) {
      debugPrint('[TicketPrintService] buildTicketPdf failed: $e');
      debugPrint('[TicketPrintService] stack: $stack');
      rethrow;
    }
    final name = 'booking-ticket-${booking.ticketCode ?? booking.id}';

    if (Platform.isMacOS) {
      try {
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/$name.pdf';
        await File(path).writeAsBytes(bytes);
        await Process.run('open', [path]);
        debugPrint('[TicketPrintService] macOS: saved PDF and opened with default app; user can print from Preview');
      } catch (e, stack) {
        debugPrint('[TicketPrintService] macOS save/open failed: $e');
        debugPrint('[TicketPrintService] stack: $stack');
        rethrow;
      }
      return;
    }

    try {
      debugPrint('[TicketPrintService] opening print dialog, name=$name');
      await Printing.layoutPdf(
        onLayout: (_) async => bytes,
        name: name,
      );
      debugPrint('[TicketPrintService] print dialog completed successfully');
    } catch (e, stack) {
      debugPrint('[TicketPrintService] Printing.layoutPdf failed: $e');
      debugPrint('[TicketPrintService] stack: $stack');
      rethrow;
    }
  }
}

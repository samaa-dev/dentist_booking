import 'dart:typed_data';

import 'package:dentist_booking_admin/core/model/booking_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Builds a one-page PDF ticket sized for 80mm thermal printers.
/// Uses 72mm printable width (actual print area on 80mm roll) and a compact
/// page height so drivers that fit/center the page do not leave a large top gap.
class TicketPdfService {
  static const double _ticketWidthMm = 72;
  static const double _ticketHeightMm = 140;

  static const String _fontRegularAsset = 'assets/fonts/Amiri-Regular.ttf';
  static const String _fontBoldAsset = 'assets/fonts/Amiri-Bold.ttf';

  Uint8List? _cachedRegular;
  Uint8List? _cachedBold;

  Future<void> _ensureFontsLoaded() async {
    if (_cachedRegular != null) return;
    final regular = await rootBundle.load(_fontRegularAsset);
    final bold = await rootBundle.load(_fontBoldAsset);
    _cachedRegular = Uint8List.fromList(regular.buffer.asUint8List());
    _cachedBold = Uint8List.fromList(bold.buffer.asUint8List());
  }

  Future<pw.ThemeData?> _buildTheme() async {
    try {
      await _ensureFontsLoaded();
      final regularCopy = Uint8List.fromList(_cachedRegular!);
      final boldCopy = Uint8List.fromList(_cachedBold!);
      final base = pw.Font.ttf(regularCopy.buffer.asByteData());
      final bold = pw.Font.ttf(boldCopy.buffer.asByteData());
      return pw.ThemeData.withFont(base: base, bold: bold);
    } catch (e) {
      debugPrint('TicketPdfService: could not load Unicode fonts: $e');
      return null;
    }
  }

  Future<Uint8List> buildTicketPdf(
    BookingModel booking, {
    String? ticketNote,
    String? clinicPhone,
  }) async {
    debugPrint('[TicketPdfService] buildTicketPdf started for booking id=${booking.id}');
    pw.ThemeData? theme;
    try {
      theme = await _buildTheme();
      if (theme == null) {
        throw StateError(
          'TicketPdfService: Unicode fonts failed to load.',
        );
      }
    } catch (e, stack) {
      debugPrint('[TicketPdfService] _buildTheme failed: $e\n$stack');
      rethrow;
    }

    final doc = pw.Document(theme: theme);
    final pageFormat = PdfPageFormat(
      _ticketWidthMm * PdfPageFormat.mm,
      _ticketHeightMm * PdfPageFormat.mm,
      marginTop: 2 * PdfPageFormat.mm,
      marginBottom: 2 * PdfPageFormat.mm,
      marginLeft: 5 * PdfPageFormat.mm,
      marginRight: 5 * PdfPageFormat.mm,
    );

    final rawNote = ticketNote?.trim().replaceAll(RegExp(r'\s+'), ' ') ?? '';
    final note = rawNote.length > 90 ? '${rawNote.substring(0, 87)}...' : rawNote;
    final hasNote = note.isNotEmpty;

    final phone = clinicPhone?.trim();
    final phoneLine = (phone != null && phone.isNotEmpty)
        ? 'Tel: $phone'
        : 'Tel: 0675677070';

    final dateStr =
        '${booking.bookingDate.day.toString().padLeft(2, '0')}-'
        '${booking.bookingDate.month.toString().padLeft(2, '0')}-'
        '${booking.bookingDate.year}';

    doc.addPage(
      pw.Page(
        pageFormat: pageFormat,
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          final base = pw.Theme.of(context).defaultTextStyle;
          final bold14 = base.copyWith(fontSize: 14, fontWeight: pw.FontWeight.bold);
          final bold12 = base.copyWith(fontSize: 12, fontWeight: pw.FontWeight.bold);
          final normal10 = base.copyWith(fontSize: 10);
          final normal12 = base.copyWith(fontSize: 12);
          final bold26 = base.copyWith(fontSize: 26, fontWeight: pw.FontWeight.bold);
          final normal9 = base.copyWith(fontSize: 9);

          return pw.Align(
            alignment: pw.Alignment.topCenter,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
              // ── Header ──
              pw.Text('عيادة الوفاء', textDirection: pw.TextDirection.rtl, style: bold14),
              pw.SizedBox(height: 1),
              pw.Text('لطب الأسنان', textDirection: pw.TextDirection.rtl, style: bold12),
              pw.SizedBox(height: 1),
              pw.Text(phoneLine, style: normal10),
              pw.SizedBox(height: 4),
              pw.Divider(thickness: 0.5),
              pw.SizedBox(height: 4),

              // ── Queue box ──
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 1),
                ),
                child: pw.Column(
                  children: [
                    pw.Text(booking.queueNumber ?? '—', style: bold26),
                    pw.SizedBox(height: 2),
                    pw.Text(booking.ticketCode ?? '—', style: normal12),
                    if (booking.patientName != null && booking.patientName!.isNotEmpty) ...[
                      pw.SizedBox(height: 2),
                      pw.Text(
                        booking.patientName!,
                        textDirection: pw.TextDirection.rtl,
                        style: normal12,
                      ),
                    ],
                  ],
                ),
              ),
              pw.SizedBox(height: 4),

              // ── Info rows ──
              _infoRow('الوردية', booking.shift.name, normal9),
              _infoRow('التاريخ', dateStr, normal9),
              if (booking.patientPhone != null && booking.patientPhone!.isNotEmpty)
                _infoRow('الهاتف', booking.patientPhone!, normal9),

              pw.SizedBox(height: 4),
              pw.Divider(thickness: 0.5),
              pw.SizedBox(height: 4),

              // ── Footer: app promo ──
              pw.Text('يمكنك تحميل تطبيق', textDirection: pw.TextDirection.rtl, style: normal9),
              pw.SizedBox(height: 1),
              pw.Text('D.Bellem', style: normal9.copyWith(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 1),
              pw.Text('لتتبع دورك عن بعد', textDirection: pw.TextDirection.rtl, style: normal9),

              // ── Note from settings ──
              if (hasNote) ...[
                pw.SizedBox(height: 4),
                pw.Divider(thickness: 0.5),
                pw.SizedBox(height: 3),
                pw.Text(
                  note,
                  textDirection: pw.TextDirection.rtl,
                  textAlign: pw.TextAlign.center,
                  style: normal10,
                ),
              ],
              ],
            ),
          );
        },
      ),
    );

    try {
      final bytes = await doc.save();
      debugPrint('[TicketPdfService] doc.save() OK, ${bytes.length} bytes');
      return bytes;
    } catch (e, stack) {
      debugPrint('[TicketPdfService] doc.save() failed: $e\n$stack');
      rethrow;
    }
  }

  static pw.Widget _infoRow(String label, String value, pw.TextStyle style) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(value, style: style),
          pw.Text(label, textDirection: pw.TextDirection.rtl, style: style),
        ],
      ),
    );
  }
}

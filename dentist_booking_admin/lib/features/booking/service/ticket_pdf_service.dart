import 'dart:typed_data';

import 'package:dentist_booking_admin/core/model/booking_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Builds a one-page PDF ticket sized for 80mm thermal printers.
class TicketPdfService {
  static const double ticketWidthMm = 80;
  static const double ticketHeightMm = 65;

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
      ticketWidthMm * PdfPageFormat.mm,
      ticketHeightMm * PdfPageFormat.mm,
      marginTop: 2 * PdfPageFormat.mm,
      marginBottom: 2 * PdfPageFormat.mm,
      marginLeft: 4 * PdfPageFormat.mm,
      marginRight: 4 * PdfPageFormat.mm,
    );

    final note = ticketNote?.trim();
    final hasNote = note != null && note.isNotEmpty;

    doc.addPage(
      pw.Page(
        pageFormat: pageFormat,
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          final baseStyle = pw.Theme.of(context).defaultTextStyle;
          return pw.Align(
            alignment: pw.Alignment.topCenter,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                // --- Header: clinic info ---
                pw.Text(
                  'عيادة الوفاء',
                  textDirection: pw.TextDirection.rtl,
                  style: baseStyle.copyWith(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'لطب الأسنان',
                  textDirection: pw.TextDirection.rtl,
                  style: baseStyle.copyWith(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Tel: 0675677070',
                  style: baseStyle.copyWith(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),

                // --- Box: queue number + ticket code + patient name ---
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 8,
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1.5),
                  ),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        booking.queueNumber ?? '—',
                        style: baseStyle.copyWith(
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        booking.ticketCode ?? '—',
                        style: baseStyle.copyWith(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      if (booking.patientName != null &&
                          booking.patientName!.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          booking.patientName!,
                          textDirection: pw.TextDirection.rtl,
                          style: baseStyle.copyWith(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                pw.SizedBox(height: 8),

                // --- Footer: app promo ---
                pw.Text(
                  'يمكنك تحميل تطبيق',
                  textDirection: pw.TextDirection.rtl,
                  style: baseStyle.copyWith(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 1),
                pw.Text(
                  'D.Bellem',
                  style: baseStyle.copyWith(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 1),
                pw.Text(
                  'لتتبع دورك عن بعد',
                  textDirection: pw.TextDirection.rtl,
                  style: baseStyle.copyWith(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                // --- Configurable ticket note from settings ---
                if (hasNote) ...[
                  pw.SizedBox(height: 6),
                  pw.Divider(thickness: 0.8),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    note,
                    textDirection: pw.TextDirection.rtl,
                    textAlign: pw.TextAlign.center,
                    style: baseStyle.copyWith(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
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
}

import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:dentist_booking_admin/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:printing_ffi/printing_ffi.dart' as pffi;

/// Shows a dialog to select a printer from [printers].
/// Returns the selected printer name, or null if cancelled.
Future<String?> showPrinterSelectionDialog(
  BuildContext context, {
  required List<pffi.Printer> printers,
}) async {
  if (printers.isEmpty) return null;
  return showDialog<String>(
    context: context,
    builder: (context) => _PrinterSelectionDialog(printers: printers),
  );
}

class _PrinterSelectionDialog extends StatelessWidget {
  const _PrinterSelectionDialog({required this.printers});

  final List<pffi.Printer> printers;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(LocaleKeys.choose_printer.trnsltd),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: printers.length,
          itemBuilder: (context, index) {
            final p = printers[index];
            return ListTile(
              title: Text(p.name),
              subtitle: p.isDefault
                  ? Text(
                      LocaleKeys.printer_default.trnsltd,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.primary,
                      ),
                    )
                  : null,
              enabled: p.isAvailable,
              onTap: () => Navigator.of(context).pop(p.name),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(LocaleKeys.cancel_button.trnsltd),
        ),
      ],
    );
  }
}

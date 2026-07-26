import 'package:dentist_booking_admin/core/extensions/os_extensions.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:window_manager/window_manager.dart';

import '../../generated/locale_keys.g.dart';
import '../util/info_snackbar.dart';

class CustomTitleBar extends StatelessWidget {
  const CustomTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isArabic = context.locale.languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.ltr : TextDirection.rtl,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
        ),
        child: Row(
          children: [
            // منطقة ا  لسحب
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (details) => windowManager.startDragging(),
                child: Container(),
              ),
            ),

            // الأزرار
            const _WindowButton(
              icon: HugeIcons.strokeRoundedRemove01,
            ),
            const _WindowButton(
              icon: HugeIcons.strokeRoundedCrop,
            ),
            const _WindowButton(
              icon: HugeIcons.strokeRoundedCancel01,
              isClose: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _WindowButton extends StatefulWidget {
  final IconData icon;
  final bool isClose;

  const _WindowButton({
    required this.icon,
    this.isClose = false,
  });

  @override
  State<_WindowButton> createState() => _WindowButtonState();
}

class _WindowButtonState extends State<_WindowButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: () async {
          if (widget.isClose) {
            _onCloseApp();
          } else if (widget.icon == HugeIcons.strokeRoundedRemove01) {
            await windowManager.minimize();
          } else if (widget.icon == HugeIcons.strokeRoundedCrop) {
            bool maximized = await windowManager.isMaximized();
            if (maximized) {
              await windowManager.unmaximize();
            } else {
              await windowManager.maximize();
            }
          }
        },

        child: Container(
          width: 50,
          height: 34,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: hover
                ? colorScheme.primary.withOpacity(.12)
                : Colors.transparent,
          ),
          child: Icon(
            widget.icon,
            size: 17,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  _onCloseApp() {
    SnackbarMes.showCustomDialog(
      context,
      title: LocaleKeys.close_app_title.trnsltd,
      content: LocaleKeys.close_app_confirm.trnsltd,
      buttonCancelText: LocaleKeys.close_cancel_button.trnsltd,
      buttonConfirmText: LocaleKeys.colse_button.trnsltd,
      onCancel: () => Navigator.of(context).pop(),
      onConfirm: () async {
        Navigator.of(context).pop();
        await windowManager.close();
      },
    );
  }
}

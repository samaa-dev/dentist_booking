import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

abstract class SnackbarMes {
  static void showToastMsg(
    BuildContext context, {
    required String message,
  }) {
    showToast(
      message,
      context: context,
      animation: StyledToastAnimation.fade,
      position: const StyledToastPosition(
        align: Alignment.bottomCenter,
        offset: 90.0,
      ),
      reverseAnimation: StyledToastAnimation.fade,
      borderRadius: const BorderRadius.all(Radius.circular(32.0)),
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
    );
  }

  static void showCustomBottomSheet({
    required BuildContext context,
    required Widget child,
    bool isExpanded = false,
  }) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              isExpanded ? const SizedBox.shrink() : const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  static void showCustomDialog(
    BuildContext context, {
    required String title,
    required String content,
    bool barrierDismissible = true,
    required String buttonCancelText,
    required String buttonConfirmText,
    required VoidCallback onCancel,
    required VoidCallback onConfirm,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: onCancel,
              child: Text(buttonCancelText),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
              ),
              onPressed: onConfirm,
              child: Text(buttonConfirmText),
            ),
          ],
        );
      },
    );
  }
}

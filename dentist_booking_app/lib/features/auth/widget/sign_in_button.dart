import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color? disabledTextColor; // ⬅️ لون النص إذا الزر Disabled
  final bool isLoading;
  final Color disabledForegroundColor;
  final Color disabledBackgroundColor;

  const SignInButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.disabledTextColor, // ⬅️ إضافي
    this.isLoading = false,
    required this.disabledForegroundColor,
    required this.disabledBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isDisabled = onPressed == null || isLoading;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        disabledBackgroundColor: disabledBackgroundColor,
        disabledForegroundColor: disabledForegroundColor,
        elevation: null,
        shadowColor: Colors.transparent,
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  disabledForegroundColor,
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(
                    size: 20,
                    icon,
                    color: isDisabled
                        ? (disabledTextColor ?? textColor.withOpacity(0.5))
                        : textColor,
                  ),
                if (icon != null) const SizedBox(width: 8),
                Text(
                  text,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDisabled
                        ? (disabledTextColor ?? textColor.withOpacity(0.5))
                        : textColor,
                  ),
                ),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';

class AuthSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color? disabledTextColor; // ⬅️ لون النص إذا الزر Disabled
  final bool isLoading;

  const AuthSignInButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.disabledTextColor, // ⬅️ إضافي
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? backgroundColor.withOpacity(1)
              : backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledForegroundColor: textColor.withOpacity(1),
          disabledBackgroundColor: backgroundColor.withOpacity(1),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Icon(
                      icon,
                      color: isDisabled
                          ? (disabledTextColor ?? textColor.withOpacity(0.5))
                          : textColor,
                    ),
                  if (icon != null) const SizedBox(width: 8),
                  Text(
                    text,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDisabled
                          ? (disabledTextColor ?? textColor.withOpacity(0.5))
                          : textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

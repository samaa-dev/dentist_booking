import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';

import '../../../core/util/queue_turn_display.dart';
import '../../../generated/locale_keys.g.dart';

/// Shared ticket presentation: large queue number + ticket code.
class QueueTicketCard extends StatelessWidget {
  const QueueTicketCard({
    super.key,
    required this.queueNumber,
    required this.ticketCode,
    required this.turnKind,
    this.margin,
    this.padding = const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
    this.showChrome = true,
  });

  final String? queueNumber;
  final String? ticketCode;
  final QueueTurnKind turnKind;

  /// Outer margin (e.g. dialog horizontal inset). Ignored when [showChrome] is false
  /// unless explicitly set for spacing.
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry padding;

  /// When false, renders ticket content without the bordered surface card
  /// (for embedding inside an existing glass / surface panel).
  final bool showChrome;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final badgeText = QueueTurnDisplay.ticketBadgeText(turnKind);
    final paddedNumber = queueNumber?.padLeft(4, '0') ?? '----';

    final content = Column(
      children: [
        if (badgeText != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.secondary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              badgeText,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
        Text(
          '#$paddedNumber',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          LocaleKeys.your_booking_number.trnsltd,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 26),
        _TicketCodeBox(
          title: LocaleKeys.ticket_number.trnsltd,
          value: ticketCode ?? '',
          iconColor: colorScheme.secondary,
        ),
      ],
    );

    if (!showChrome) {
      return Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Padding(padding: padding, child: content),
      );
    }

    return Container(
      margin: margin ?? EdgeInsets.zero,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.surface,
            colorScheme.surface.withOpacity(0.96),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: content,
    );
  }
}

class _TicketCodeBox extends StatelessWidget {
  const _TicketCodeBox({
    required this.title,
    required this.value,
    this.iconColor,
  });

  final String title;
  final String value;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            colorScheme.surface,
            colorScheme.surface.withOpacity(0.96),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.list_alt_rounded,
            color: iconColor ?? colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

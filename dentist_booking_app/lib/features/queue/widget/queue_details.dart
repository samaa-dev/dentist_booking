import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/enum/enum.dart';
import '../../../core/model/tracking_model.dart';
import '../../../core/util/queue_turn_display.dart';
import '../../../generated/locale_keys.g.dart';

class QueueDetails extends StatelessWidget {
  const QueueDetails({super.key, required this.queue});

  final TrackingModel queue;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final turnKind = QueueTurnDisplay.resolve(
      stats: queue.queueStats,
      patientQueueNumber: queue.booking.queueNumber,
    );

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 350),
                tween: Tween(begin: 0, end: 1),
                curve: Curves.easeOut,
                builder: (context, value, child) => Transform.translate(
                  offset: Offset(0, (1 - value) * 20),
                  child: Opacity(opacity: value, child: child),
                ),

                child: _buildHeader(context),
              ),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 350),
                tween: Tween(begin: 0, end: 1),
                curve: Curves.easeOut,
                builder: (context, value, child) => Transform.translate(
                  offset: Offset(0, (1 - value) * 20),
                  child: Opacity(opacity: value, child: child),
                ),
                child: _buildTicketCard(context, turnKind),
              ),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 350),
                tween: Tween(begin: 0, end: 1),
                curve: Curves.easeOut,
                builder: (context, value, child) => Transform.translate(
                  offset: Offset(0, (1 - value) * 20),
                  child: Opacity(opacity: value, child: child),
                ),
                child: _buildStatsCard(context, turnKind),
              ),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 350),
                tween: Tween(begin: 0, end: 1),
                curve: Curves.easeOut,
                builder: (context, value, child) => Transform.translate(
                  offset: Offset(0, (1 - value) * 20),
                  child: Opacity(opacity: value, child: child),
                ),
                child: _buildPatientInfo(context),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// HEADER
  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 18, 10),
      child: Row(
        children: [
          Icon(Icons.confirmation_number, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              LocaleKeys.queue_details.trnsltd,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// TICKET CARD
  Widget _buildTicketCard(BuildContext context, QueueTurnKind turnKind) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final badgeText = QueueTurnDisplay.ticketBadgeText(turnKind);

    return _card(
      context,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(
        children: [
          if (badgeText != null)
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

          Text(
            "#${queue.booking.queueNumber?.padLeft(4, '0')}",
            style: textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            LocaleKeys.queue_number.trnsltd,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 26),

          _smallInfoBox(
            context,
            icon: Icons.list_alt_rounded,
            title: LocaleKeys.ticket_number.trnsltd,
            iconColor: colorScheme.secondary,
            value: queue.booking.ticketCode ?? '',
          ),
        ],
      ),
    );
  }

  /// STATS CARD
  Widget _buildStatsCard(BuildContext context, QueueTurnKind turnKind) {
    final colorScheme = Theme.of(context).colorScheme;
    final isHighlight = QueueTurnDisplay.isHighlightTurn(turnKind);

    return _card(
      context,
      margin: const EdgeInsets.only(left: 18, right: 18, top: 18),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statBlock(
                context,
                icon: Icons.play_arrow_rounded,
                value: QueueTurnDisplay.currentQueueValue(queue.queueStats),
                label: LocaleKeys.current_number.trnsltd,
                color: colorScheme.primary,
              ),
              _statBlock(
                context,
                icon: Icons.people_rounded,
                value: QueueTurnDisplay.beforeYouValue(
                  kind: turnKind,
                  stats: queue.queueStats,
                ),
                label: QueueTurnDisplay.beforeYouLabel(
                  kind: turnKind,
                  stats: queue.queueStats,
                ),
                color: isHighlight ? Colors.green : colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// PATIENT INFO
  Widget _buildPatientInfo(BuildContext context) {
    // إذا كانت معلومات guest موجودة، استخدمها مباشرة
    if (queue.booking.patientName != null &&
        queue.booking.patientName!.isNotEmpty) {
      return _card(
        context,
        margin: const EdgeInsets.only(left: 18, right: 18, top: 18),
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _infoRow(
              context,
              Icons.person,
              LocaleKeys.patient_name.trnsltd,
              queue.booking.patientName!,
            ),
            const SizedBox(height: 10),
            _infoRow(
              context,
              Icons.phone,
              LocaleKeys.phone_number.trnsltd,
              queue.booking.patientPhone ?? "_",
            ),
            if ((queue.booking.patientAddress ?? "").isNotEmpty) ...[
              const SizedBox(height: 10),
              _infoRow(
                context,
                Icons.home_rounded,
                LocaleKeys.address.trnsltd,
                queue.booking.patientAddress!,
              ),
            ],
            const SizedBox(height: 10),
            _infoRow(
              context,
              Icons.badge_rounded,
              LocaleKeys.patient_type.trnsltd,
              _getPatientTypeText(queue.booking.patientType),
            ),
          ],
        ),
      );
    }

    // إذا لم تكن هناك معلومات guest، جلب معلومات المريض من patientId
    return FutureBuilder<Map<String, dynamic>?>(
      future: _getPatientInfoFromId(queue.booking.patientId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _card(
            context,
            margin: const EdgeInsets.only(left: 18, right: 18, top: 18),
            padding: const EdgeInsets.all(18),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final patientInfo = snapshot.data ?? {};
        final meta = patientInfo['meta'] as Map<String, dynamic>? ?? {};
        final rawMeta = meta['raw_user_meta_data'] as Map<String, dynamic>? ?? {};

        final patientName = rawMeta['full_name'] as String? ?? "_";
        final patientPhone = rawMeta['phone'] as String? ?? "_";
        final patientAddress = rawMeta['address'] as String? ?? "_";

        return _card(
          context,
          margin: const EdgeInsets.only(left: 18, right: 18, top: 18),
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              _infoRow(
                context,
                Icons.person,
                LocaleKeys.patient_name.trnsltd,
                patientName,
              ),
              const SizedBox(height: 10),
              _infoRow(
                context,
                Icons.phone,
                LocaleKeys.phone_number.trnsltd,
                patientPhone,
              ),
              if (patientAddress.isNotEmpty && patientAddress != "_") ...[
                const SizedBox(height: 10),
                _infoRow(
                  context,
                  Icons.home_rounded,
                  LocaleKeys.address.trnsltd,
                  patientAddress,
                ),
              ],
              const SizedBox(height: 10),
              _infoRow(
                context,
                Icons.badge_rounded,
                LocaleKeys.patient_type.trnsltd,
                _getPatientTypeText(queue.booking.patientType),
              ),
            ],
          ),
        );
      },
    );
  }

  /// جلب معلومات المريض من patientId
  Future<Map<String, dynamic>?> _getPatientInfoFromId(String? patientId) async {
    if (patientId == null) return null;

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('meta')
          .eq('user_id', patientId)
          .maybeSingle();

      return response;
    } catch (e) {
      debugPrint("Failed to fetch patient info: $e");
      return null;
    }
  }

  // COMPONENTS -----------------------------

  Widget _card(
    BuildContext context, {
    required Widget child,
    required EdgeInsets margin,
    required EdgeInsets padding,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: margin,
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
      child: child,
    );
  }

  Widget _smallInfoBox(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    Color? iconColor,
  }) {
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
          Icon(icon, color: iconColor ?? colorScheme.primary),
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

  Widget _statBlock(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getPatientTypeText(PatientType? type) {
    switch (type) {
      case PatientType.registered:
        return LocaleKeys.registered_patient.trnsltd;
      case PatientType.guest:
        return LocaleKeys.guest_patient.trnsltd;
      default:
        return LocaleKeys.unknown.trnsltd;
    }
  }

}

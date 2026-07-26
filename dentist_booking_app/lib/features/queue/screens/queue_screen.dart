import 'package:dentist_booking_app/core/extensions/os_extensions.dart';
import 'package:dentist_booking_app/core/widgets/appbar/custom_app_bar.dart';
import 'package:dentist_booking_app/features/queue/blocs/queue/queue_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../core/app_setup.dart';
import '../../../core/util/util.dart';
import '../../../core/widgets/appbar/title_app_bar.dart';
import '../../../core/widgets/loading_dialog.dart';
import '../../../generated/locale_keys.g.dart';
import '../widget/queue_details.dart';
import '../widget/queue_tracking.dart';
import '../widget/queue_welcome.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QueueCubit>(
      create: (context) => getIt<QueueCubit>(),
      child: BlocListener<QueueCubit, QueueState>(
        listenWhen: (previous, current) {
          return current.maybeWhen(
            orElse: () => false,
            loading: () => true,
            loaded: (_) => true,
            error: (_) => true,
          );
        },
        listener: (context, state) {
          state.maybeWhen(
            orElse: () => {},

            loading: () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => LoadingDialog(),
            ),
            error: (message) {
              if (Navigator.canPop(context)) Navigator.pop(context);
              SnackbarMes.showToastMsg(context, message: message);
            },
            loaded: (queue) {
              if (Navigator.canPop(context)) Navigator.pop(context);

              if (queue == null) {
                SnackbarMes.showToastMsg(
                  context,
                  message: LocaleKeys.error_no_queue_found.trnsltd,
                );
                return;
              }

              showDialog(
                context: context,
                builder: (_) => QueueDetails(queue: queue),
              );
            },
          );
        },
        child: const _QueueLayout(),
      ),
    );
  }
}

class _QueueLayout extends StatelessWidget {
  const _QueueLayout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleAppBar: TitleAppBar(
          icon: HugeIcons.strokeRoundedUserGroup,
          text: LocaleKeys.navigation_bar_booking_tracking.trnsltd,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  SizedBox(height: 12),
                  QueueWelcome(),
                  SizedBox(height: 12),
                  QueueTracking(
                    onTrackPressed: (ticketCode) {
                      context.read<QueueCubit>().getQueue(
                        ticketCode: ticketCode,
                      );
                    },
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
